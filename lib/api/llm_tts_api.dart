import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';

class LLMApi {
  static LLMApi? instance;
  static void initialize(LLMApi api) => instance = api;

  Future<String?> summarize(
      {required String headline,
      required String content,
      required String srcLink,
      int numTries = 1,
      bool forceFetch = false}) async {
    throw UnimplementedError();
  }

  Future<Map<String, String>?> translate(
      {required String headline,
      required String content,
      required String targetLang,
      int numTries = 1,
      bool forceFetch = false}) async {
    throw UnimplementedError();
  }
}

class LLMAWSApi extends LLMApi {
  static final _dio = Dio(BaseOptions(
      baseUrl:
          'https://b7ln7iwhsdek2lkvarroebe64y0juyax.lambda-url.ap-south-1.on.aws/'));

  static final Map<Map<String, String>, String> _summarizationCache = {};
  static final Map<Map<String, String>, Map<String, String>> _translationCache =
      {};

  String _jsonToMarkdown(dynamic summaryData) {
    final buffer = StringBuffer();
    buffer.writeln('${summaryData["summary"]}\n');
    buffer.writeln('\n##### **Key Points:**\n');
    for (final point in summaryData["key_points"]) {
      buffer.writeln('- $point');
    }
    return buffer.toString();
  }

  @override
  Future<String?> summarize(
      {required String headline,
      required String content,
      required String srcLink,
      int numTries = 1,
      bool forceFetch = false}) async {
    final data = {'title': headline, 'body': content, 'link': srcLink};

    for (int tryNo = 0; tryNo < numTries; ++tryNo) {
      if (_summarizationCache.containsKey(data) && !forceFetch) {
        return Future.value(_summarizationCache[data]);
      }
      try {
        final response = (await _dio.post('summarize', data: data)).data;
        try {
          final summaryData = jsonDecode(response['summary']);
          final summaryMd = _jsonToMarkdown(summaryData);
          _summarizationCache[data] = summaryMd;
          return Future.value(summaryMd);
        } on FormatException catch (_) {
          break;
        }
      } on DioException catch (_) {
        if (tryNo + 1 < numTries) {
          await Future.delayed(Duration(seconds: 1 << tryNo));
        }
      }
    }
    return Future.value(null);
  }

  @override
  Future<Map<String, String>?> translate(
      {required String headline,
      required String content,
      required String targetLang,
      int numTries = 1,
      bool forceFetch = false}) async {
    final data = {
      'headline': headline,
      'text': content,
      'target_lang': targetLang
    };

    for (int tryNo = 0; tryNo < numTries; ++tryNo) {
      if (_translationCache.containsKey(data) && !forceFetch) {
        return Future.value(_translationCache[data]);
      }
      try {
        var response = await _dio.post('translate', data: data);
        var translation = response.data;

        translation = <String, String>{
          'headline': translation['translated_heading']!,
          'content': translation['translated_text']!
        };
        _translationCache[data] = translation;
        return translation;
      } on DioException catch (_) {
        await Future.delayed(Duration(seconds: pow(2, tryNo) as int));
      }
    }
    return Future.value(null);
  }
}
