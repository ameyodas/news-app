import 'package:flutter/material.dart';
import 'package:news_app/news.dart';
import 'package:news_app/widgets/news_card.dart';

class SectionData {
  final String name;
  final String title;
  final Future<List<INNews>> Function() fetcher;
  final double prob;

  var news = <INNews?>[];

  SectionData(
      {required this.name,
      required this.fetcher,
      required this.prob,
      required this.title});

  SectionData clone() =>
      SectionData(name: name, title: title, fetcher: fetcher, prob: prob);

  void fillWithLoading(int count) {
    for (int idx = 0; idx < count; ++idx) {
      news.add(null);
    }
  }

  void hydrate(List<INNews?> newNews) {
    news.removeWhere((thisNews) => thisNews == null);
    newNews.removeWhere((thisNews) => thisNews == null);
    news.addAll(newNews);
  }
}

class Section extends StatelessWidget {
  final String name;
  final String title;
  final List<INNews?> news;
  final Widget Function(BuildContext, INNews) cardBuilder;
  final void Function(dynamic)? callback;

  const Section(
      {required this.name,
      required this.title,
      this.news = const <INNews?>[],
      required this.cardBuilder,
      this.callback,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
            child: Text(title,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ))),
        const Divider(
          height: 1.0,
          thickness: 0.35,
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: news.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, idx) {
            final thisNews = news[idx];
            if (thisNews == null) {
              return const INLoadingNewsCard();
            } else {
              return cardBuilder(context, thisNews);
            }
          },
          separatorBuilder: (context, index) => const Divider(
            height: 1.0,
            thickness: 0.35,
          ),
        ),
        const Divider(
          height: 1.0,
          thickness: 0.35,
        ),
      ],
    );
  }
}
