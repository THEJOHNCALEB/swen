import 'package:flutter_test/flutter_test.dart';
import 'package:swen/core/services/cache_service.dart';
import 'package:swen/core/models/article.dart';

void main() {
  group('CacheService', () {
    late CacheService cacheService;

    setUp(() {
      cacheService = CacheService();
    });

    test('should cache and retrieve articles', () async {
      final articles = [
        Article(
          id: 'test-1',
          title: 'Test Article 1',
          url: 'https://test.com/1',
          publishedAt: DateTime.now(),
          category: 'general',
          cachedAt: DateTime.now(),
        ),
        Article(
          id: 'test-2',
          title: 'Test Article 2',
          url: 'https://test.com/2',
          publishedAt: DateTime.now(),
          category: 'general',
          cachedAt: DateTime.now(),
        ),
      ];

      await cacheService.init();
      await cacheService.cacheArticles(articles, 'general');

      final cached = await cacheService.getCachedArticles('general');

      expect(cached.length, 2);
      expect(cached[0].title, 'Test Article 1');
      expect(cached[1].title, 'Test Article 2');

      await cacheService.close();
    });

    test('should add and remove bookmarks', () async {
      final article = Article(
        id: 'test-bookmark',
        title: 'Bookmarked Article',
        url: 'https://test.com/bookmark',
        publishedAt: DateTime.now(),
        category: 'general',
        cachedAt: DateTime.now(),
      );

      await cacheService.init();

      await cacheService.addBookmark(article);
      var isBookmarked = await cacheService.isBookmarked(article.id);
      expect(isBookmarked, true);

      var bookmarks = await cacheService.getBookmarks();
      expect(bookmarks.length, 1);
      expect(bookmarks[0].id, article.id);

      await cacheService.removeBookmark(article.id);
      isBookmarked = await cacheService.isBookmarked(article.id);
      expect(isBookmarked, false);

      bookmarks = await cacheService.getBookmarks();
      expect(bookmarks.length, 0);

      await cacheService.close();
    });
  });
}
