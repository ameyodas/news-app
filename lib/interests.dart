abstract class INTags {
  static const all = [
    'general',
    'politics',
    'sports',
    'business',
    'technology',
    'entertainment',
    'health',
    'science',
    'lifestyle',
    'travel',
    'culture',
    'education',
    'environment',
    'nation',
    'world',
  ];
}

class InterestsData {
  final List<String> keywords;
  final List<String> tags;

  const InterestsData({this.keywords = const [], this.tags = const []});

  Map<String, dynamic> toMap() {
    return {'keywords': keywords.join(','), 'tags': tags.join(',')};
  }

  static InterestsData fromMap(Map<String, dynamic> map) {
    List<String> parse(String? str) {
      if (str == null) return const <String>[];
      var tokens = str.split(',');
      tokens.removeWhere((token) => token.isEmpty);
      return tokens;
    }

    return InterestsData(
        keywords: parse(map['keywords']), tags: parse(map['tags']));
  }
}
