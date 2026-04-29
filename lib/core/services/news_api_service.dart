import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/article.dart';
import '../errors/app_exceptions.dart';

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKeyStorageKey = 'newsapi_key';
  
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  String? _apiKey;

  NewsApiService({
    Dio? dio,
    FlutterSecureStorage? secureStorage,
  })  : _dio = dio ?? Dio(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_apiKey == null) {
            _apiKey = await _secureStorage.read(key: _apiKeyStorageKey);
          }
          
          if (_apiKey != null) {
            options.queryParameters['apiKey'] = _apiKey!;
          }
          
          return handler.next(options);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> setApiKey(String apiKey) async {
    _apiKey = apiKey;
    await _secureStorage.write(key: _apiKeyStorageKey, value: apiKey);
  }

  Future<String?> getApiKey() async {
    _apiKey ??= await _secureStorage.read(key: _apiKeyStorageKey);
    return _apiKey;
  }

  Future<List<Article>> getTopHeadlines({
    required String category,
    int page = 1,
    int pageSize = 20,
    String country = 'us',
  }) async {
    try {
      final response = await _dio.get(
        '/top-headlines',
        queryParameters: {
          'category': category,
          'country': country,
          'page': page,
          'pageSize': pageSize,
        },
      );

      return _parseArticlesResponse(response, category);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Article>> searchArticles({
    required String query,
    int page = 1,
    int pageSize = 20,
    String sortBy = 'publishedAt',
  }) async {
    try {
      final response = await _dio.get(
        '/everything',
        queryParameters: {
          'q': query,
          'page': page,
          'pageSize': pageSize,
          'sortBy': sortBy,
          'language': 'en',
        },
      );

      return _parseArticlesResponse(response, 'search');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  List<Article> _parseArticlesResponse(Response response, String category) {
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final articles = data['articles'] as List<dynamic>?;

      if (articles == null) {
        return [];
      }

      return articles
          .map((json) => Article.fromJson(
                json as Map<String, dynamic>,
                category: category,
              ))
          .where((article) => article.url.isNotEmpty)
          .toList();
    } else {
      throw ApiException(
        'Failed to fetch articles',
        statusCode: response.statusCode,
      );
    }
  }

  AppException _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const NetworkException('Request timeout');
    }

    if (error.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }

    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      
      if (statusCode == 429) {
        return const RateLimitException();
      }
      
      if (statusCode == 401) {
        return const InvalidApiKeyException();
      }

      final message = error.response!.data?['message'] as String? ??
          'API error occurred';
      
      return ApiException(message, statusCode: statusCode);
    }

    return UnknownException(error.message);
  }
}
