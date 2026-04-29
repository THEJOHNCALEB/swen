import 'package:hive_flutter/hive_flutter.dart';
import '../models/article.dart';
import '../errors/app_exceptions.dart';

class CacheService {
  static const String _articlesBoxName = 'articles';
  static const String _bookmarksBoxName = 'bookmarks';
  static const int _cacheExpiryHours = 24;

  Box<Article>? _articlesBox;
  Box<Article>? _bookmarksBox;

  Future<void> init() async {
    try {
      await Hive.initFlutter();

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(ArticleAdapter());
      }

      _articlesBox = await Hive.openBox<Article>(_articlesBoxName);
      _bookmarksBox = await Hive.openBox<Article>(_bookmarksBoxName);
    } catch (e) {
      throw CacheException('Failed to initialize cache: $e');
    }
  }

  Future<void> cacheArticles(List<Article> articles, String category) async {
    try {
      final box = _articlesBox;
      if (box == null) throw const CacheException('Cache not initialized');

      final validArticles = articles.where((a) => a.url.isNotEmpty).toList();

      for (final article in validArticles) {
        final key = '${category}_${article.id}';
        await box.put(key, article);
      }

      await _cleanExpiredCache();
    } catch (e) {
      throw CacheException('Failed to cache articles: $e');
    }
  }

  Future<List<Article>> getCachedArticles(String category) async {
    try {
      final box = _articlesBox;
      if (box == null) throw const CacheException('Cache not initialized');

      final now = DateTime.now();
      final articles = <Article>[];

      for (final key in box.keys) {
        if (key.toString().startsWith('${category}_')) {
          final article = box.get(key);
          if (article != null) {
            final age = now.difference(article.cachedAt);
            if (age.inHours < _cacheExpiryHours) {
              articles.add(article);
            }
          }
        }
      }

      articles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      return articles;
    } catch (e) {
      throw CacheException('Failed to get cached articles: $e');
    }
  }

  Future<void> addBookmark(Article article) async {
    try {
      final box = _bookmarksBox;
      if (box == null) throw const CacheException('Cache not initialized');

      final updatedArticle = article.copyWith(isBookmarked: true);
      await box.put(article.id, updatedArticle);

      await _updateArticleBookmarkStatus(article.id, true);
    } catch (e) {
      throw CacheException('Failed to add bookmark: $e');
    }
  }

  Future<void> removeBookmark(String articleId) async {
    try {
      final box = _bookmarksBox;
      if (box == null) throw const CacheException('Cache not initialized');

      await box.delete(articleId);

      await _updateArticleBookmarkStatus(articleId, false);
    } catch (e) {
      throw CacheException('Failed to remove bookmark: $e');
    }
  }

  Future<List<Article>> getBookmarks() async {
    try {
      final box = _bookmarksBox;
      if (box == null) throw const CacheException('Cache not initialized');

      final bookmarks = box.values.toList();
      bookmarks.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      return bookmarks;
    } catch (e) {
      throw CacheException('Failed to get bookmarks: $e');
    }
  }

  Future<bool> isBookmarked(String articleId) async {
    try {
      final box = _bookmarksBox;
      if (box == null) return false;

      return box.containsKey(articleId);
    } catch (e) {
      return false;
    }
  }

  Future<void> _updateArticleBookmarkStatus(
    String articleId,
    bool isBookmarked,
  ) async {
    final box = _articlesBox;
    if (box == null) return;

    for (final key in box.keys) {
      final article = box.get(key);
      if (article?.id == articleId) {
        final updated = article!.copyWith(isBookmarked: isBookmarked);
        await box.put(key, updated);
      }
    }
  }

  Future<void> _cleanExpiredCache() async {
    final box = _articlesBox;
    if (box == null) return;

    final now = DateTime.now();
    final keysToDelete = <dynamic>[];

    for (final key in box.keys) {
      final article = box.get(key);
      if (article != null) {
        final age = now.difference(article.cachedAt);
        if (age.inHours >= _cacheExpiryHours) {
          keysToDelete.add(key);
        }
      }
    }

    for (final key in keysToDelete) {
      await box.delete(key);
    }
  }

  Future<void> clearAllCache() async {
    await _articlesBox?.clear();
  }

  Future<void> clearAllBookmarks() async {
    await _bookmarksBox?.clear();
  }

  Future<void> close() async {
    await _articlesBox?.close();
    await _bookmarksBox?.close();
  }
}
