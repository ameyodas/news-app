import 'package:flutter/material.dart';
import 'package:news_app/api/news_provider_api.dart';
import 'package:news_app/news.dart';
import 'package:news_app/widgets/news_card.dart';

class Section extends StatelessWidget {
  final String name;
  final List<INNews>? news;
  final void Function(dynamic)? callback;

  const Section({required this.name, this.news, this.callback, super.key});

  List<Widget> _getCardsWithDividers() {
    List<Widget> result = [];
    if (news == null) {
      for (int i = 0; i < 5; i++) {
        result.add(const INLoadingNewsCard());
        result.add(const Divider(
          height: 1.0,
        ));
      }
    } else {
      for (final n in news!) {
        result.add(INNewsCard(
          news: n,
          callback: callback,
        ));
        result.add(const Divider(
          height: 1.0,
        ));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 12.0,
        ),
        Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(name,
                style: const TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ))),
        const SizedBox(
          height: 12.0,
        ),
        Column(children: _getCardsWithDividers())
      ],
    );
  }
}

class HomeTab extends StatefulWidget {
  final void Function(dynamic)? callback;

  const HomeTab({super.key, this.callback});

  @override
  State<HomeTab> createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  List<INNews>? highlightNews;
  List<INNews>? forYouNews;

  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};
  String _currentSection = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _updateNews();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _updateNews() async {
    final highlights = await NewsProviderApi.instance!.fetchHighlights();
    final forYous = await NewsProviderApi.instance!.fetchForYou(numTries: 3);
    setState(() {
      highlightNews = highlights;
      forYouNews = forYous;
    });
  }

  void _handleScroll() {
    for (var entry in _sectionKeys.entries) {
      final context = entry.value.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        final pos = box.localToGlobal(Offset.zero).dy;
        if (pos < kToolbarHeight + 50) {
          if (_currentSection != entry.key) {
            _currentSection = entry.key;
            widget.callback!('set_title $_currentSection');
          }
        }
      }
    }
  }

  Widget _buildSection(String name, List<INNews>? news) {
    _sectionKeys.putIfAbsent(name, () => GlobalKey());

    return Section(
      key: _sectionKeys[name],
      name: name,
      news: news,
      callback: widget.callback,
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
        onRefresh: _updateNews,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          clipBehavior: Clip.none,
          child: Column(
            children: [
              _buildSection('Highlights of the Day', highlightNews),
              _buildSection('For You', forYouNews),
            ],
          ),
        ));
  }
}
