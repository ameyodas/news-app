import 'package:flutter/material.dart';
import 'package:news_app/api/db_api.dart';
import 'package:news_app/news.dart';
import 'package:news_app/widgets/news_card.dart';

class SavedTab extends StatefulWidget {
  final void Function(dynamic)? callback;

  const SavedTab({super.key, this.callback});

  @override
  State<SavedTab> createState() => SavedTabState();
}

class SavedTabState extends State<SavedTab> {
  List<INNews>? news;

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
        result.add(INSavedNewsCard(
          news: n,
          callback: _callback,
        ));
        result.add(const Divider(
          height: 1.0,
        ));
      }
    }
    return result;
  }

  Future<void> _beginFetchNews() async {
    final news = await DBApi.instance!.loadArticles(count: 25);
    setState(() {
      this.news = news;
    });
  }

  void _callback(dynamic msg) {
    if (msg == 'unsave' || msg == 'save') {
      _beginFetchNews();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (news == null) {
      _beginFetchNews();
    }

    return RefreshIndicator(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black54
            : Colors.white54,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        strokeWidth: 2,
        displacement: 60,
        onRefresh: _beginFetchNews,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          clipBehavior: Clip.none,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12.0,
              ),
              const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text('Saved Articles',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                      ))),
              const SizedBox(
                height: 12.0,
              ),
              Column(children: _getCardsWithDividers())
            ],
          ),
        ));
  }
}
