import 'package:uuid/uuid.dart';

class INNews {
  late String newsId;
  final String headline;
  final String content;
  final String? imageUrl;
  final List<String>? tags;
  final String sourceUrl;
  final String sourceName;

  static const Uuid _uuid = Uuid();

  INNews.withUuid(
      {required this.newsId,
      required this.headline,
      required this.content,
      required this.sourceUrl,
      required this.sourceName,
      this.imageUrl,
      this.tags});

  INNews(
      {required dynamic idSeed,
      required String headline,
      required String content,
      required String sourceUrl,
      required String sourceName,
      String? imageUrl,
      List<String>? tags})
      : this.withUuid(
            newsId: _uuid.v5(Namespace.url.value, idSeed.toString()),
            headline: headline,
            content: content,
            sourceUrl: sourceUrl,
            sourceName: sourceName,
            imageUrl: imageUrl,
            tags: tags);

  INNews cloneWith(
      {String? headline,
      String? content,
      String? sourceUrl,
      String? sourceName,
      String? imageUrl,
      List<String>? tags}) {
    return INNews.withUuid(
        newsId: newsId,
        headline: headline ?? this.headline,
        content: content ?? this.content,
        sourceUrl: sourceUrl ?? this.sourceUrl,
        sourceName: sourceName ?? this.sourceName,
        imageUrl: imageUrl ?? this.imageUrl,
        tags: tags ?? this.tags);
  }

  Map<String, String> toMap() {
    return {
      'news_id': newsId,
      'headline': headline,
      'content': content,
      'image_url': imageUrl ?? '',
      'tags': tags != null ? tags!.join(',') : '',
      'source_url': sourceUrl,
      'source_name': sourceName
    };
  }

  static INNews fromMap(Map<String, String> map) {
    return INNews.withUuid(
        newsId: map['news_id']!,
        headline: map['headline']!,
        content: map['content']!,
        imageUrl: map['image_url'],
        tags: map['tags']?.split(','),
        sourceUrl: map['source_url']!,
        sourceName: map['source_name']!);
  }
}
