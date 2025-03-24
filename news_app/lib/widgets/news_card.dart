import 'package:card_loading/card_loading.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:news_app/news.dart';
import 'package:news_app/pages/read_page.dart';
import 'package:news_app/widgets/chips.dart';

class INLoadingNewsCard extends StatelessWidget {
  const INLoadingNewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CardLoadingTheme(
        colorOne: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        colorTwo: Theme.of(context).brightness == Brightness.light
            ? Colors.black12
            : Colors.white10);

    return Column(children: <Widget>[
      const CardLoading(
        height: 90,
      ),
      const SizedBox(
        height: 16.0,
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(children: <Widget>[
            CardLoading(
              height: 24.0,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              curve: Curves.decelerate,
              cardLoadingTheme: theme,
            ),
            const SizedBox(
              height: 16.0,
            ),
            CardLoading(
              height: 16.0,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              curve: Curves.easeInOutCirc,
              cardLoadingTheme: theme,
            ),
            const SizedBox(
              height: 8.0,
            ),
            CardLoading(
              height: 16.0,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              curve: Curves.easeInOutExpo,
              cardLoadingTheme: theme,
            ),
            // SizedBox(
            //   height: 8.0,
            // ),
            // CardLoading(
            //   height: 16.0,
            //   borderRadius: BorderRadius.all(Radius.circular(6)),
            //   curve: Curves.easeInOutExpo,
            // ),
            const SizedBox(
              height: 16.0,
            )
          ]))
    ]);
  }
}

class INNewsCard extends StatelessWidget {
  final INNews news;
  final double imgHeight;
  final void Function(String)? onNavPop;

  const INNewsCard(
      {super.key, required this.news, this.imgHeight = 90.0, this.onNavPop});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReadPage(news: news)))
            .then((result) {
          if (result != null) {
            onNavPop?.call(result);
          }
        });
      },
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            if (news.imageUrl != null)
              SizedBox(
                height: imgHeight,
                width: double.infinity,
                child: Image.network(
                  news.imageUrl!,
                  fit: BoxFit.cover,
                ),
              )
            else
              const SizedBox(height: 4.0),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.headline,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (news.tags != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: news.tags!
                                .map((e) => Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: INChip(
                                        text: e,
                                        backgroundColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.black
                                                : Colors.white,
                                        side: BorderSide(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white24
                                              : Colors.black26,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      const SizedBox(height: 8.0),
                      Text(
                        news.content,
                        style:
                            const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IgnorePointer(
                            ignoring: false,
                            child: IconButton(
                              visualDensity: VisualDensity.compact,
                              splashRadius: 18.0,
                              iconSize: 18.0,
                              icon: const Icon(FluentIcons.bookmark_16_regular),
                              onPressed: () {
                                // Save action
                              },
                            ),
                          ),
                          IgnorePointer(
                            ignoring: false,
                            child: IconButton(
                              visualDensity: VisualDensity.compact,
                              splashRadius: 18.0,
                              iconSize: 18.0,
                              icon: const Icon(FluentIcons.share_16_regular),
                              onPressed: () {
                                // Share action
                              },
                            ),
                          ),
                        ],
                      ),
                      IgnorePointer(
                        ignoring: false,
                        child: IconButton(
                          visualDensity: VisualDensity.compact,
                          splashRadius: 18.0,
                          iconSize: 18.0,
                          icon: const Icon(FluentIcons.heart_12_regular,
                              color: Colors.red),
                          onPressed: () {
                            // Like action
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
