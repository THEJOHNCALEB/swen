import 'package:flutter_test/flutter_test.dart';
import 'package:swen/core/models/article.dart';

void main() {
  group('Article Model', () {
    test('should create Article from JSON', () {
      final json = {
        'source': {'name': 'Test Source'},
        'author': 'Test Author',
        'title': 'Test Title',
        'description': 'Test Description',
        'url': 'https://test.com/article',
        'urlToImage': 'https://test.com/image.jpg',
        'publishedAt': '2024-01-01T00:00:00Z',
        'content': 'Test Content',
      };

      final article = Article.fromJson(json, category: 'technology');

      expect(article.title, 'Test Title');
      expect(article.sourceName, 'Test Source');
      expect(article.author, 'Test Author');
      expect(article.description, 'Test Description');
      expect(article.url, 'https://test.com/article');
      expect(article.imageUrl, 'https://test.com/image.jpg');
      expect(article.content, 'Test Content');
      expect(article.category, 'technology');
      expect(article.isBookmarked, false);
    });

    test('should handle missing optional fields', () {
      final json = {
        'title': 'Test Title',
        'url': 'https://test.com/article',
        'publishedAt': '2024-01-01T00:00:00Z',
      };

      final article = Article.fromJson(json);

      expect(article.title, 'Test Title');
      expect(article.url, 'https://test.com/article');
      expect(article.sourceName, null);
      expect(article.author, null);
      expect(article.description, null);
      expect(article.imageUrl, null);
      expect(article.content, null);
    });

    test('should generate stable ID from URL', () {
      final json1 = {
        'title': 'Test 1',
        'url': 'https://test.com/article',
        'publishedAt': '2024-01-01T00:00:00Z',
      };

      final json2 = {
        'title': 'Test 2',
        'url': 'https://test.com/article',
        'publishedAt': '2024-01-02T00:00:00Z',
      };

      final article1 = Article.fromJson(json1);
      final article2 = Article.fromJson(json2);

      expect(article1.id, article2.id);
    });

    test('should create copy with updated fields', () {
      final article = Article(
        id: 'test-id',
        title: 'Original Title',
        url: 'https://test.com',
        publishedAt: DateTime.now(),
        category: 'general',
        isBookmarked: false,
        cachedAt: DateTime.now(),
      );

      final updated = article.copyWith(
        title: 'Updated Title',
        isBookmarked: true,
      );

      expect(updated.title, 'Updated Title');
      expect(updated.isBookmarked, true);
      expect(updated.url, article.url);
      expect(updated.id, article.id);
    });
  });
}
