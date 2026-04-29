import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

part 'article.g.dart';

@HiveType(typeId: 0)
class Article extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? sourceName;

  @HiveField(2)
  final String? author;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final String url;

  @HiveField(6)
  final String? imageUrl;

  @HiveField(7)
  final DateTime publishedAt;

  @HiveField(8)
  final String? content;

  @HiveField(9)
  final String category;

  @HiveField(10)
  bool isBookmarked;

  @HiveField(11)
  final DateTime cachedAt;

  Article({
    required this.id,
    this.sourceName,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
    this.content,
    required this.category,
    this.isBookmarked = false,
    required this.cachedAt,
  });

  factory Article.fromJson(
    Map<String, dynamic> json, {
    String category = 'general',
  }) {
    final url = json['url'] as String? ?? '';
    final id = _generateId(url);

    return Article(
      id: id,
      sourceName: json['source']?['name'] as String?,
      author: json['author'] as String?,
      title: json['title'] as String? ?? 'Untitled',
      description: json['description'] as String?,
      url: url,
      imageUrl: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'] as String)
          : DateTime.now(),
      content: json['content'] as String?,
      category: category,
      isBookmarked: false,
      cachedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': {'name': sourceName},
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': imageUrl,
      'publishedAt': publishedAt.toIso8601String(),
      'content': content,
      'category': category,
      'isBookmarked': isBookmarked,
      'cachedAt': cachedAt.toIso8601String(),
    };
  }

  static String _generateId(String url) {
    final bytes = utf8.encode(url);
    final digest = sha1.convert(bytes);
    return digest.toString();
  }

  Article copyWith({
    String? id,
    String? sourceName,
    String? author,
    String? title,
    String? description,
    String? url,
    String? imageUrl,
    DateTime? publishedAt,
    String? content,
    String? category,
    bool? isBookmarked,
    DateTime? cachedAt,
  }) {
    return Article(
      id: id ?? this.id,
      sourceName: sourceName ?? this.sourceName,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
      category: category ?? this.category,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }
}
