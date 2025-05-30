import 'dart:math';
import 'package:flutter/material.dart';
import 'package:news_app/news.dart';
import 'package:news_app/widgets/section.dart';

class NewsStream {
  final List<SectionData> sectionsData;

  late List<int> _sectionReadIdx;

  static final _rndm = Random();
  static const _maxFetches = 5;
  static const _maxNewsCards = 30;
  var _fetchCount = 0;
  var _newsCount = 0;
  var _fetching = false;

  NewsStream({required this.sectionsData}) {
    _sectionReadIdx = sectionsData.map((_) => 0).toList();
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

  List<INNews?> _readNewsFromStore(int sectionIdx, int count) {
    final start = _sectionReadIdx[sectionIdx];
    final end = min(start + count, sectionsData[sectionIdx].news.length);
    final result = sectionsData[sectionIdx].news.sublist(start, end);
    _sectionReadIdx[sectionIdx] = end;
    return result;
  }

  int _newsLeftInStore(int sectionIdx) {
    return sectionsData[sectionIdx].news.length - _sectionReadIdx[sectionIdx];
  }

  bool _canFetchMore() {
    return _fetchCount < _maxFetches && _newsCount < _maxNewsCards;
  }

  Future<void> _fetchMore(int sectionIdx) async {
    debugPrint("fetching more news!");
    final newNews = await sectionsData[sectionIdx].fetcher();
    sectionsData[sectionIdx].news.addAll(newNews);
    _newsCount += newNews.length;
    ++_fetchCount;
    debugPrint("fetched ${newNews.length} more news!");
  }

  Future<(String?, List<INNews?>)> fetch(int maxCount,
      [void Function(SectionData)? loadingBuilder]) async {
    if (_fetching) {
      debugPrint("already fetching news!");
      return Future.value((null, <INNews>[]));
    }

    _fetching = true;
    final fetchCount = _rndm.nextInt(maxCount - 3) + 3;

    var sampleSectionIdx = _pickNextSection();
    loadingBuilder?.call(sectionsData[sampleSectionIdx].clone());

    final newsLeft = _newsLeftInStore(sampleSectionIdx);
    if (newsLeft < fetchCount) {
      if (_canFetchMore()) {
        await _fetchMore(sampleSectionIdx);
      } else if (newsLeft == 0) {
        for (int idx = 0; idx < sectionsData.length; ++idx) {
          if (_newsLeftInStore(idx) > 0) {
            sampleSectionIdx = idx;
            break;
          }
        }
      }
    }
    final result = _readNewsFromStore(sampleSectionIdx, fetchCount);
    _fetching = false;
    return Future.value((sectionsData[sampleSectionIdx].title, result));
  }
}
