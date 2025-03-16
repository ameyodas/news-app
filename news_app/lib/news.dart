class INNews {
  final String headline;
  final String content;
  final String? imageUrl;
  final List<String>? tags;

  const INNews(
      {required this.headline,
      required this.content,
      this.imageUrl,
      this.tags});
}
