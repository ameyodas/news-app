import 'package:dio/dio.dart';
import 'package:news_app/env.dart';
import 'package:news_app/news.dart';

class NewsProviderApi {
  static NewsProviderApi? instance;
  static void initialize(NewsProviderApi api) => instance = api;

  final Dio _dio;

  NewsProviderApi({String? baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl ?? ''));

  Future<List<INNews>> search(
      {int numTries = 1,
      String? keywords,
      DateTime? startDate,
      DateTime? endDate,
      List<String>? tags,
      String? region}) async {
    throw UnimplementedError(
        'Search function not implemented for this NewsProviderApi!');
  }

  Future<List<INNews>> fetchHighlights({int numTries = 1}) async {
    return await search(
        numTries: numTries,
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now());
  }

  Future<List<INNews>> fetchForYou({int numTries = 1}) async {
    //final interests = await DBApi.instance!.getInterests();
    final startDate = DateTime.now().subtract(const Duration(days: 1));
    final endDate = DateTime.now();
    return await search(
        //keywords: interests?.keywords.join(', '),
        startDate: startDate,
        endDate: endDate,
        //tags: interests?.tags,
        numTries: numTries);
  }

  Future<List<INNews>> fetchMissed({int numTries = 1}) async {
    //final interests = await DBApi.instance!.getInterests();
    final startDate = DateTime.now().subtract(const Duration(days: 7));
    final endDate = DateTime.now().subtract(const Duration(days: 1));
    return await search(
        //keywords: interests?.keywords.join(', '),
        startDate: startDate,
        endDate: endDate,
        //tags: interests?.tags,
        numTries: numTries);
  }

  List<String> _filterTags(List<String> given, List<String> allowed) {
    final filtered = <String>[];
    for (final tag in given) {
      if (allowed.contains(tag)) {
        filtered.add(tag);
      }
    }
    return filtered;
  }

  String _extractNewsProvider(String url) {
    try {
      final uri = Uri.parse(url);
      final tokens = uri.host.split('.');
      return tokens.length <= 2 ? tokens[0] : tokens[1];
    } catch (_) {
      return url;
    }
  }

  Future<Map<String, dynamic>> _request(
      String endPoint, Map<String, dynamic> queryParameters,
      {Options? options, int numTries = 3}) async {
    DioException? exception;
    for (int tryNo = 0; tryNo < numTries; ++tryNo) {
      try {
        final response = await _dio.get(
          endPoint,
          queryParameters: queryParameters,
          options: options,
        );

        return response.data as Map<String, dynamic>;
      } on DioException catch (e) {
        if (e.type == DioExceptionType.badCertificate
            // || e.type == DioExceptionType.badResponse
            ) {
          rethrow;
        }
        exception = e;
        if (tryNo + 1 < numTries) {
          await Future.delayed(Duration(seconds: 1 << tryNo));
        }
      }
    }

    throw exception!;
  }
}

class WorldNewsApi extends NewsProviderApi {
  static const List<String> _allowedTags = [
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
    'other'
  ];

  WorldNewsApi() : super(baseUrl: 'https://api.worldnewsapi.com/');

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Future<List<INNews>> fetchHighlights({int numTries = 1}) async {
    final queryParameters = <String, String>{
      'source-country': 'in',
      'language': 'en'
    };

    try {
      final data = await _request('top-news', queryParameters,
          options: Options(headers: {'x-api-key': Env.worldNewsApiKey}));

      final processedNews = <INNews>[];
      for (final newsCluster in data['top_news']) {
        for (final news in newsCluster['news']) {
          processedNews.add(INNews(
              newsId: news['id']!,
              headline: news['title']!,
              content: news['text']!,
              imageUrl: news['image'],
              tags: [],
              sourceUrl: news['url']!,
              sourceName: _extractNewsProvider(news['url'])));
          break;
        }
      }
      return processedNews;
    } catch (_) {
      return Future.value(<INNews>[]);
    }
  }

  @override
  Future<List<INNews>> search(
      {int numTries = 1,
      String? keywords,
      DateTime? startDate,
      DateTime? endDate,
      List<String>? tags,
      String? region}) async {
    final queryParameters = <String, String>{
      if (keywords != null && keywords.isNotEmpty) 'text': keywords,
      'language': 'en',
      if (startDate != null) 'earliest-publish-date': _formatDate(startDate),
      if (endDate != null) 'latest-publish-date': _formatDate(endDate),
      if (tags != null && tags.isNotEmpty)
        'categories': _filterTags(tags, _allowedTags).join(',')
    };

    try {
      final data = await _request('search-news', queryParameters,
          options: Options(headers: {'x-api-key': Env.worldNewsApiKey}));

      final processedNews = <INNews>[];
      for (final news in data['news']) {
        processedNews.add(INNews(
            newsId: news['id']!,
            headline: news['title']!,
            content: news['text']!,
            imageUrl: news['image'],
            tags: [],
            sourceUrl: news['url']!,
            sourceName: _extractNewsProvider(news['url'])));
      }
      return processedNews;
    } catch (_) {
      return Future.value(<INNews>[]);
    }
  }
}

class GNewsApi extends NewsProviderApi {
  // ignore: unused_field
  static const List<String> _allowedTags = [
    'general',
    'world',
    'nation',
    'business',
    'technology',
    'entertainment',
    'sports',
    'science',
    'health'
  ];

  GNewsApi() : super(baseUrl: 'https://gnews.io/api/v4/');

  String _formatDate(DateTime dateTime) {
    final utc = dateTime.toUtc();
    final formatted = '${utc.toIso8601String().split('.').first}Z';
    return formatted;
  }

  @override
  Future<List<INNews>> fetchHighlights({int numTries = 1}) async {
    final startDate = DateTime.now().subtract(const Duration(days: 1));
    final endDate = DateTime.now();

    final queryParameters = <String, String>{
      'lang': 'en',
      //if (region != null && region.isNotEmpty) 'country': region,
      'from': _formatDate(startDate),
      'to': _formatDate(endDate),
      'max': '100',
      'apikey': Env.gnewsApiKey,
    };

    try {
      final data =
          await _request('top-headlines', queryParameters, numTries: numTries);

      final processedNews = <INNews>[];
      for (final news in data['articles']) {
        processedNews.add(INNews(
          newsId: news['url'],
          headline: news['title']!,
          content: news['description']!,
          imageUrl: news['image'],
          tags: [],
          sourceUrl: news['url']!,
          sourceName:
              news['source']['name'] ?? _extractNewsProvider(news['url']),
        ));
      }
      return processedNews;
    } catch (_) {
      return Future.value(<INNews>[]);
    }
  }

  @override
  Future<List<INNews>> fetchForYou({int numTries = 1}) async {
    //final interests = await DBApi.instance!.getInterests();

    final startDate = DateTime.now().subtract(const Duration(days: 1));
    final endDate = DateTime.now();

    final queryParameters = <String, String>{
      'lang': 'en',
      //if (region != null && region.isNotEmpty) 'country': region,
      'from': _formatDate(startDate),
      'to': _formatDate(endDate),
      'max': '100',
      'apikey': Env.gnewsApiKey,
    };

    try {
      final data =
          await _request('top-headlines', queryParameters, numTries: numTries);

      final processedNews = <INNews>[];
      for (final news in data['articles']) {
        processedNews.add(INNews(
          newsId: news['url'],
          headline: news['title']!,
          content: news['description']!,
          imageUrl: news['image'],
          tags: [],
          sourceUrl: news['url']!,
          sourceName:
              news['source']['name'] ?? _extractNewsProvider(news['url']),
        ));
      }
      return processedNews;
    } catch (e) {
      return Future.value(<INNews>[]);
    }
  }

  @override
  Future<List<INNews>> search({
    int numTries = 1,
    String? keywords,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? tags,
    String? region,
  }) async {
    final queryParameters = <String, String>{
      if (keywords != null && keywords.isNotEmpty) 'q': keywords,
      'lang': 'en',
      if (region != null && region.isNotEmpty) 'country': region,
      if (startDate != null) 'from': _formatDate(startDate),
      if (endDate != null) 'to': _formatDate(endDate),
      'max': '100',
      'apikey': Env.gnewsApiKey,
    };

    try {
      final data = await _request('search', queryParameters);

      final processedNews = <INNews>[];
      for (final news in data['articles']) {
        processedNews.add(INNews(
          newsId: news['url'],
          headline: news['title']!,
          content: news['description']!,
          imageUrl: news['image'],
          tags: [],
          sourceUrl: news['url']!,
          sourceName:
              news['source']['name'] ?? _extractNewsProvider(news['url']),
        ));
      }
      return processedNews;
    } catch (_) {
      return Future.value(<INNews>[]);
    }
  }
}
