import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LLMApi {
  static LLMApi? instance;
  static void initialize(LLMApi api) => instance = api;

  Future<String> summarize(
      {required String headline,
      required String content,
      required String srcLink,
      int numTries = 1,
      bool forceFetch = false}) async {
    throw UnimplementedError();
  }

  Future<String> translate(
      {required String content,
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

  static final Map<Map<String, String>, Map<String, String>>
      _summarizationCache = {};
  static final Map<Map<String, String>, String> _translationCache = {};

  @override
  Future<String> summarize(
      {required String headline,
      required String content,
      required String srcLink,
      int numTries = 1,
      bool forceFetch = false}) async {
    final data = {'title': headline, 'body': content, 'link': srcLink};

    for (int tryNo = 0; tryNo < numTries; ++tryNo) {
      if (_summarizationCache.containsKey(data) && !forceFetch) {
        return Future.value(_summarizationCache[data]!['summary']);
      }
      try {
        var response = await _dio.post('summarize', data: data);
        String summary = response.data['summary'];
        String cleanedSummary = response.data['cleaned_summary'];
        _summarizationCache[data] = {
          'summary': summary,
          'cleaned_summary': cleanedSummary
        };
        return summary;
      } on DioException catch (_) {
        await Future.delayed(Duration(seconds: pow(2, tryNo) as int));
      }
    }
    return Future<String>.value(content);
  }

  @override
  Future<String> translate(
      {required String content,
      required String targetLang,
      int numTries = 1,
      bool forceFetch = false}) async {
    final data = {'text': content, 'target_lang': targetLang};
    debugPrint(data.toString());

    for (int tryNo = 0; tryNo < numTries; ++tryNo) {
      if (_translationCache.containsKey(data) && !forceFetch) {
        return Future.value(_translationCache[data]);
      }
      try {
        var response = await _dio.post('translate', data: data);
        String translatedText = response.data['translated_text'];
        _translationCache[data] = translatedText;
        debugPrint(translatedText);
        return translatedText;
      } on DioException catch (_) {
        await Future.delayed(Duration(seconds: pow(2, tryNo) as int));
      }
    }
    return Future<String>.value(content);
  }
}
