// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticleAdapter extends TypeAdapter<Article> {
  @override
  final int typeId = 0;

  @override
  Article read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Article(
      id: fields[0] as String,
      sourceName: fields[1] as String?,
      author: fields[2] as String?,
      title: fields[3] as String,
      description: fields[4] as String?,
      url: fields[5] as String,
      imageUrl: fields[6] as String?,
      publishedAt: fields[7] as DateTime,
      content: fields[8] as String?,
      category: fields[9] as String,
      isBookmarked: fields[10] as bool,
      cachedAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Article obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sourceName)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.url)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.publishedAt)
      ..writeByte(8)
      ..write(obj.content)
      ..writeByte(9)
      ..write(obj.category)
      ..writeByte(10)
      ..write(obj.isBookmarked)
      ..writeByte(11)
      ..write(obj.cachedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
