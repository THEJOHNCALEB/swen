import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/cache_service.dart';
import '../core/models/article.dart';
import '../core/models/api_response.dart';
import '../core/errors/app_exceptions.dart';
import 'news_provider.dart';

final bookmarksProvider = StateNotifierProvider<
    BookmarksNotifier,
    ApiResponse<List<Article>>>((ref) {
  return BookmarksNotifier(ref.watch(cacheServiceProvider));
});

class BookmarksNotifier extends StateNotifier<ApiResponse<List<Article>>> {
  final CacheService _cacheService;

  BookmarksNotifier(this._cacheService) : super(const ApiLoading()) {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    state = const ApiLoading();

    try {
      final bookmarks = await _cacheService.getBookmarks();
      state = ApiSuccess(bookmarks);
    } on AppException catch (e) {
      state = ApiError.fromException(e);
    } catch (e) {
      state = ApiError(
        'Failed to load bookmarks: $e',
        ApiErrorType.unknown,
      );
    }
  }

  Future<void> toggleBookmark(Article article) async {
    try {
      final isBookmarked = await _cacheService.isBookmarked(article.id);

      if (isBookmarked) {
        await _cacheService.removeBookmark(article.id);
      } else {
        await _cacheService.addBookmark(article);
      }

      await loadBookmarks();
    } on AppException catch (e) {
      state = ApiError.fromException(e);
    } catch (e) {
      state = ApiError(
        'Failed to toggle bookmark: $e',
        ApiErrorType.unknown,
      );
    }
  }

  Future<bool> isBookmarked(String articleId) async {
    return await _cacheService.isBookmarked(articleId);
  }
}
