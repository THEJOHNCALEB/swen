import 'package:dio/dio.dart';
import '../models/article.dart';
import '../errors/app_exceptions.dart';

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';

  final Dio _dio;
  String? _apiKey;
  String? _proxyUrl;

  NewsApiService({
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_proxyUrl != null) {
            if (_apiKey != null) {
              options.queryParameters['apiKey'] = _apiKey!;
            }
            final originalPath = options.path;
            final originalQuery =
                Uri(queryParameters: Map.from(options.queryParameters))
                    .query;
            options.path = '';
            options.baseUrl = _proxyUrl!;
            options.queryParameters.clear();
            options.queryParameters['url'] =
                '$_baseUrl$originalPath${originalQuery.isNotEmpty ? '?$originalQuery' : ''}';
          } else if (_apiKey != null) {
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

  void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }

  void setProxyUrl(String url) {
    _proxyUrl = url;
  }

  String? getApiKey() {
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

      final message =
          error.response!.data?['message'] as String? ?? 'API error occurred';

      return ApiException(message, statusCode: statusCode);
    }

    return UnknownException(error.message);
  }
}
