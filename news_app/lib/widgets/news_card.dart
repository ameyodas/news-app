import 'package:card_loading/card_loading.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/db_api.dart';
import 'package:news_app/news.dart';
import 'package:news_app/pages/reading_page.dart';
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
      CardLoading(
        height: 90,
        cardLoadingTheme: theme,
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

class INNewsCard extends StatefulWidget {
  final INNews news;
  final void Function(dynamic)? callback;
  final bool isSavedInitially;

  const INNewsCard(
      {super.key,
      required this.news,
      this.callback,
      this.isSavedInitially = false});

  @override
  State<INNewsCard> createState() => INNewsCardState();
}

class INNewsCardState extends State<INNewsCard> {
  late bool isSaved;

  @override
  void initState() {
    super.initState();
    isSaved = widget.isSavedInitially;
  }

  void saveAction() async {
    if (!isSaved) {
      await DBApi.instance!.storeArticle(widget.news);
    } else {
      await DBApi.instance!.deleteArticle(widget.news.newsId);
    }
    setState(() {
      isSaved = !isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReadingPage(news: widget.news)))
            .then((result) {
          if (result != null) {
            widget.callback?.call(result);
          }
        });
      },
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            if (widget.news.imageUrl != null)
              SizedBox(
                height: 90.0,
                width: double.infinity,
                child: Image.network(
                  widget.news.imageUrl!,
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
                        widget.news.headline,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.news.tags != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: widget.news.tags!
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
                        widget.news.content,
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
                                icon: Icon(isSaved
                                    ? FluentIcons.bookmark_16_filled
                                    : FluentIcons.bookmark_16_regular),
                                onPressed: saveAction),
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

class INSavedNewsCard extends StatefulWidget {
  final INNews news;
  final void Function(dynamic)? callback;
  final bool isSavedInitially;

  const INSavedNewsCard(
      {super.key,
      required this.news,
      this.callback,
      this.isSavedInitially = true});

  @override
  State<INSavedNewsCard> createState() => INSavedNewsCardState();
}

class INSavedNewsCardState extends State<INSavedNewsCard> {
  late bool isSaved;

  @override
  void initState() {
    super.initState();
    isSaved = widget.isSavedInitially;
  }

  void saveAction() async {
    if (!isSaved) {
      await DBApi.instance!.storeArticle(widget.news);
    } else {
      await DBApi.instance!.deleteArticle(widget.news.newsId);
    }
    setState(() {
      isSaved = !isSaved;
    });
    if (isSaved) {
      widget.callback?.call('save');
    } else {
      widget.callback?.call('unsave');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReadingPage(news: widget.news)))
            .then((result) {
          if (result != null) {
            widget.callback?.call(result);
          }
        });
      },
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.news.headline,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          widget.news.content,
                          style: const TextStyle(
                              fontSize: 14, fontFamily: 'Inter'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IgnorePointer(
                          ignoring: false,
                          child: IconButton(
                              visualDensity: VisualDensity.compact,
                              splashRadius: 18.0,
                              iconSize: 18.0,
                              icon: Icon(isSaved
                                  ? FluentIcons.bookmark_16_filled
                                  : FluentIcons.bookmark_16_regular),
                              onPressed: saveAction),
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
                  ],
                ),
              ),
            ),
            if (widget.news.imageUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  width: 116.0,
                  height: 136.0,
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                  child: Image.network(
                    widget.news.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
