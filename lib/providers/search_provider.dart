import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/news_api_service.dart';
import '../core/services/cache_service.dart';
import '../core/services/connectivity_service.dart';
import '../core/models/article.dart';
import '../core/models/api_response.dart';
import '../core/errors/app_exceptions.dart';
import 'news_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = StateNotifierProvider<
    SearchResultsNotifier,
    ApiResponse<List<Article>>>((ref) {
  return SearchResultsNotifier(
    ref.watch(newsApiServiceProvider),
    ref.watch(cacheServiceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class SearchResultsNotifier extends StateNotifier<ApiResponse<List<Article>>> {
  final NewsApiService _newsApiService;
  final CacheService _cacheService;
  final ConnectivityService _connectivityService;

  SearchResultsNotifier(
    this._newsApiService,
    this._cacheService,
    this._connectivityService,
  ) : super(const ApiSuccess([]));

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const ApiSuccess([]);
      return;
    }

    state = const ApiLoading();

    try {
      final isConnected = await _connectivityService.checkConnectivity();

      if (!isConnected) {
        state = const ApiError(
          'No internet connection. Search requires an active connection.',
          ApiErrorType.network,
        );
        return;
      }

      final articles = await _newsApiService.searchArticles(
        query: query,
        pageSize: 50,
      );

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
    } on AppException catch (e) {
      state = ApiError.fromException(e);
    } catch (e) {
      state = ApiError(
        'An unexpected error occurred: $e',
        ApiErrorType.unknown,
      );
    }
  }

  void clear() {
    state = const ApiSuccess([]);
  }
}
