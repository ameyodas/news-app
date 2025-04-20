import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/news_provider_api.dart';
import 'package:news_app/news_stream.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/section.dart';

class HomeTab extends StatefulWidget {
  final void Function(dynamic)? callback;

  const HomeTab({super.key, this.callback});

  @override
  State<HomeTab> createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  static const _newsBatchMaxCount = 10;
  late NewsStream _newsStream;
  final _sectionsData = <SectionData>[];

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _newsStream = NewsStream(sectionsData: [
      SectionData(
          name: 'highlights',
          title: 'Highlights of the Day',
          fetcher: NewsProviderApi.instance!.fetchHighlights,
          prob: 0.6),
      SectionData(
          name: 'for_you',
          title: 'For You',
          fetcher: NewsProviderApi.instance!.fetchForYou,
          prob: 0.4)
    ]);
    _beginFetchNews();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _beginFetchNews() async {
    final (title, news) =
        await _newsStream.fetch(_newsBatchMaxCount, (sectionData) {
      if (_sectionsData.isEmpty ||
          sectionData.name != _sectionsData.last.name) {
        _sectionsData.add(sectionData);
      }
      setState(() => _sectionsData.last.fillWithLoading(_newsBatchMaxCount));
    });

    setState(() => _sectionsData.last.hydrate(news));
  }

  void _handleScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _beginFetchNews();
      }
    }
  }

  Widget _buildSections(BuildContext context) {
    if (_sectionsData.isEmpty || _sectionsData.last.news.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(FluentIcons.error_circle_12_filled, size: 90.0),
            SizedBox(height: 16.0),
            Text('Server Error',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal))
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: _sectionsData.length,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      itemBuilder: (context, idx) {
        final section = _sectionsData[idx];
        return Section(
          name: section.name,
          title: section.title,
          news: section.news,
          cardBuilder: (context, news) => INNewsCard(news: news),
          callback: widget.callback,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.black54
          : Colors.white54,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      strokeWidth: 2,
      displacement: 60,
      onRefresh: _beginFetchNews,
      child: _buildSections(context),
    );
  }
}
