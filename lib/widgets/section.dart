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
      children: [
        const SizedBox(
          height: 12.0,
        ),
        Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(title,
                style: const TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ))),
        const SizedBox(
          height: 12.0,
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
          separatorBuilder: (context, index) => const Divider(height: 1.0),
        ),
        const SizedBox(
          height: 32.0,
        )
      ],
    );
  }
}
