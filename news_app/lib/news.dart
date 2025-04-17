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

  INNews(
      {dynamic newsId,
      required this.headline,
      required this.content,
      required this.sourceUrl,
      required this.sourceName,
      this.imageUrl,
      this.tags}) {
    this.newsId = _uuid.v5(Namespace.url.value, newsId.toString());
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
    return INNews(
        newsId: map['news_id']!,
        headline: map['headline']!,
        content: map['content']!,
        imageUrl: map['image_url'],
        tags: map['tags']?.split(','),
        sourceUrl: map['source_url']!,
        sourceName: map['source_name']!);
  }
}
