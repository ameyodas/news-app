class InterestsData {
  final List<String> keywords;
  final List<String> tags;

  const InterestsData({this.keywords = const [], this.tags = const []});

  Map<String, String> toMap() {
    return {'keywords': keywords.join(','), 'tags': tags.join(',')};
  }

  static InterestsData fromMap(Map<String, String> map) {
    return InterestsData(
        keywords: map['keywords'] == null ? [] : map['keywords']!.split(','),
        tags: map['tags'] == null ? [] : map['tags']!.split(','));
  }
}
