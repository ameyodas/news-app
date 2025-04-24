import 'dart:math';
import 'package:flutter/material.dart';
import 'package:news_app/news.dart';
import 'package:news_app/widgets/section.dart';

class NewsStream {
  final List<SectionData> sectionsData;

  late List<int> _sectionIdxs;

  static final _rndm = Random();
  static const _maxFetches = 5;
  static const _maxNewsCards = 30;
  var _fetchCount = 0;
  var _newsCount = 0;
  var _fetching = false;

  NewsStream({required this.sectionsData}) {
    _sectionIdxs = sectionsData.map((_) => 0).toList();
  }

  int _pickNextSection() {
    final roll = _rndm.nextDouble();
    double cumulative = 0.0;

    for (int idx = 0; idx < sectionsData.length; ++idx) {
      cumulative += sectionsData[idx].prob;
      if (roll < cumulative) {
        return idx;
      }
    }

    return sectionsData.length - 1;
  }

  Future<(String?, List<INNews?>)> fetch(int maxCount,
      [void Function(SectionData)? loadingBuilder]) async {
    if (_fetching == true ||
        _fetchCount >= _maxFetches ||
        _newsCount >= _maxNewsCards) {
      return Future.value((null, <INNews>[]));
    }

    _fetching = true;
    final fetchCount = _rndm.nextInt(maxCount - 3) + 3;

    final sampleIdx = _pickNextSection();
    loadingBuilder?.call(sectionsData[sampleIdx].clone());

    if (_sectionIdxs[sampleIdx] + fetchCount >=
        sectionsData[sampleIdx].news.length) {
      final newNews = await sectionsData[sampleIdx].fetcher();
      sectionsData[sampleIdx].news.addAll(newNews);
      //_sectionIdxs[sampleIdx] += newNews.length;
      _newsCount += newNews.length;
      ++_fetchCount;
    }

    final newIdx = min(_sectionIdxs[sampleIdx] + fetchCount,
        sectionsData[sampleIdx].news.length);
    debugPrint('range: ${_sectionIdxs[sampleIdx]} - $newIdx');
    final result =
        sectionsData[sampleIdx].news.sublist(_sectionIdxs[sampleIdx], newIdx);
    _sectionIdxs[sampleIdx] = newIdx;
    _fetching = false;
    return Future.value((sectionsData[sampleIdx].title, result));
  }
}
