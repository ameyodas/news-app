import 'package:flutter/material.dart';
import 'package:news_app/api.dart';
import 'package:news_app/news.dart';
import 'package:news_app/widgets/news_card.dart';

class HomePage extends StatefulWidget {
  final void Function(String)? onMessage;

  const HomePage({super.key, this.onMessage});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static List<Widget> addDividers(List<Widget> widgets) {
    List<Widget> result = [];
    for (int i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      result.add(const Divider(
        height: 1.0,
      ));
    }
    return result;
  }

  List<INNews>? news;

  void beginFetchNews() {
    INFetchApi.getNews().then((news) {
      setState(() {
        this.news = news;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (news == null) {
      beginFetchNews();
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 12.0,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text('Highlights of the day',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ))),
          const SizedBox(
            height: 12.0,
          ),
          if (news != null)
            Column(
                children: addDividers(news!
                    .map((e) => INNewsCard(
                          news: e,
                          onNavPop: widget.onMessage,
                        ))
                    .toList()))
          else
            Column(
                children: addDividers(
                    List.generate(10, (_) => const INLoadingNewsCard()))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
                child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black12, // Gray background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Circular borders
                ),
                elevation: 0, // No shadow
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              ),
              child: const Text(
                'Search for more...',
                style: TextStyle(color: Colors.black), // Text color
              ),
            )),
          )
        ],
      ),
    );
  }
}
