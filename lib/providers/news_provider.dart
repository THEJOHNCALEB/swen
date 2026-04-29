import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/news_api_service.dart';
import '../core/services/cache_service.dart';
import '../core/services/connectivity_service.dart';
import '../core/models/article.dart';
import '../core/models/api_response.dart';
import '../core/errors/app_exceptions.dart';

final newsApiServiceProvider = Provider<NewsApiService>((ref) {
  return NewsApiService();
});

final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService();
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectivityStream;
});

final topHeadlinesProvider = StateNotifierProvider.family<
    TopHeadlinesNotifier,
    ApiResponse<List<Article>>,
    String>((ref, category) {
  return TopHeadlinesNotifier(
    ref.watch(newsApiServiceProvider),
    ref.watch(cacheServiceProvider),
    ref.watch(connectivityServiceProvider),
    category,
  );
});

class TopHeadlinesNotifier extends StateNotifier<ApiResponse<List<Article>>> {
  final NewsApiService _newsApiService;
  final CacheService _cacheService;
  final ConnectivityService _connectivityService;
  final String category;

  TopHeadlinesNotifier(
    this._newsApiService,
    this._cacheService,
    this._connectivityService,
    this.category,
  ) : super(const ApiLoading()) {
    loadArticles();
  }

  Future<void> loadArticles({bool forceRefresh = false}) async {
    if (!forceRefresh && state is ApiSuccess) {
      return;
    }

    state = const ApiLoading();

    try {
      final isConnected = await _connectivityService.checkConnectivity();

      if (isConnected) {
        final articles = await _newsApiService.getTopHeadlines(
          category: category,
          pageSize: 50,
        );

        await _cacheService.cacheArticles(articles, category);

        final bookmarkedIds = <String>{};
        final bookmarks = await _cacheService.getBookmarks();
        for (final bookmark in bookmarks) {
          bookmarkedIds.add(bookmark.id);
        }

        final updatedArticles = articles.map((article) {
          return article.copyWith(
            isBookmarked: bookmarkedIds.contains(article.id),
          );
        }).toList();

        state = ApiSuccess(updatedArticles);
      } else {
        final cachedArticles = await _cacheService.getCachedArticles(category);
        
        if (cachedArticles.isEmpty) {
          state = const ApiError(
            'No internet connection and no cached articles available.',
            ApiErrorType.network,
          );
        } else {
          state = ApiSuccess(cachedArticles);
        }
      }
    } on AppException catch (e) {
      final cachedArticles = await _cacheService.getCachedArticles(category);
      
      if (cachedArticles.isNotEmpty) {
        state = ApiSuccess(cachedArticles);
      } else {
        state = ApiError.fromException(e);
      }
    } catch (e) {
      state = ApiError(
        'An unexpected error occurred: $e',
        ApiErrorType.unknown,
      );
    }
  }

  Future<void> refresh() async {
    await loadArticles(forceRefresh: true);
  }
}
