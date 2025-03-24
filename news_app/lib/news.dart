class INNews {
  final String headline;
  final String content;
  final String? imageUrl;
  final List<String>? tags;
  final String source;
  final String sourceTitle;

  const INNews(
      {required this.headline,
      required this.content,
      required this.source,
      required this.sourceTitle,
      this.imageUrl,
      this.tags});
}
