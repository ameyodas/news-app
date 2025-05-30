import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/db_api.dart';
import 'package:news_app/event_bus.dart';
import 'package:news_app/news.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/section.dart';

class SavedTab extends StatefulWidget {
  final void Function(dynamic)? callback;

  const SavedTab({super.key, this.callback});

  @override
  State<SavedTab> createState() => SavedTabState();
}

class SavedTabState extends State<SavedTab> {
  var _news = <INNews?>[];

  Future<void> _beginFetchNews() async {
    final news = await DBApi.instance!.loadArticles(count: 25);
    setState(() {
      _news = news;
    });
  }

  void _callback(dynamic msg) {
    if (msg is! String) return;
    msg = msg.toString();
    debugPrint('callback: $msg');

    if (msg.startsWith('delete ')) {
      debugPrint(msg);
      final newsId = msg.substring('delete '.length);
      setState(() {
        _news.removeWhere((news) => news?.newsId == newsId);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    eventBus.on<NewsSavedEvent>().listen((event) {
      debugPrint("save");
      _beginFetchNews();
    });
    eventBus.on<NewsDeleteEvent>().listen((event) {
      debugPrint("delete");
      _beginFetchNews();
    });
    _beginFetchNews();
  }

  Widget _buildSection(BuildContext context) {
    if (_news.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(FluentIcons.library_16_filled, size: 90.0),
            SizedBox(height: 16.0),
            Text('Saved Articles',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text('No Articles Saved Yet',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal))
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Section(
        name: 'saved_articles',
        title: 'Saved Articles',
        news: _news,
        cardBuilder: (context, news) => INSavedNewsCard(
          news: news,
          callback: _callback,
        ),
        callback: _callback,
      ),
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
        child: _buildSection(context));
  }
}
