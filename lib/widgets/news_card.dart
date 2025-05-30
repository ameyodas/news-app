import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/db_api.dart';
import 'package:news_app/event_bus.dart';
import 'package:news_app/news.dart';
import 'package:news_app/page_route_builder.dart';
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
  late bool _isSaved;
  var _imageUnloadable = false;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.isSavedInitially;
  }

  void _saveDeleteAction() async {
    if (!_isSaved) {
      await DBApi.instance!.storeArticle(widget.news);
      debugPrint("fire save");
      eventBus.fire(NewsSavedEvent());
    } else {
      await DBApi.instance!.deleteArticle(widget.news.newsId);
      debugPrint("fire delete");
      eventBus.fire(NewsDeleteEvent());
    }
    setState(() {
      _isSaved = !_isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context)
            .push(INPageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    ReadingPage(
                      news: widget.news,
                      isSavedInitially: _isSaved,
                    )))
            .then((result) {
          //debugPrint("result: $result");
          if (result != null) {
            if (result is Map<String, dynamic> &&
                (result['saved'] ?? _isSaved) != _isSaved) {
              setState(() {
                _isSaved = !_isSaved;
              });
            }
            widget.callback?.call(result);
          }
        });
      },
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            if (widget.news.imageUrl != null && !_imageUnloadable)
              CachedNetworkImage(
                imageUrl: widget.news.imageUrl!,
                placeholder: (context, url) => CardLoading(
                  height: 90.0,
                  cardLoadingTheme: CardLoadingTheme(
                      colorOne: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colors.black,
                      colorTwo: Theme.of(context).brightness == Brightness.light
                          ? Colors.black12
                          : Colors.white10),
                ),
                errorWidget: (context, url, error) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && !_imageUnloadable) {
                      setState(() => _imageUnloadable = true);
                    }
                  });
                  return Container();
                },
                fit: BoxFit.cover,
                height: 90.0,
                width: double.infinity,
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
                          fontSize: 17.0,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Raleway',
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
                                icon: Icon(_isSaved
                                    ? FluentIcons.bookmark_16_filled
                                    : FluentIcons.bookmark_16_regular),
                                onPressed: _saveDeleteAction),
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

  const INSavedNewsCard({super.key, required this.news, this.callback});

  @override
  State<INSavedNewsCard> createState() => INSavedNewsCardState();
}

class INSavedNewsCardState extends State<INSavedNewsCard> {
  var _imageUnloadable = false;

  @override
  void initState() {
    super.initState();
  }

  void _saveDeleteAction() async {
    await DBApi.instance!.deleteArticle(widget.news.newsId);
    //widget.callback?.call('delete ${widget.news.newsId}');
    eventBus.fire(NewsDeleteEvent());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context)
            .push(INPageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    ReadingPage(
                      news: widget.news,
                      isSavedInitially: true,
                    )))
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
                            icon: const Icon(FluentIcons.share_16_regular),
                            onPressed: () {
                              // Share action
                            },
                          ),
                        ),
                        IgnorePointer(
                          ignoring: false,
                          child: IconButton(
                              visualDensity: VisualDensity.compact,
                              splashRadius: 18.0,
                              iconSize: 18.0,
                              icon: const Icon(FluentIcons.delete_12_regular,
                                  color: Colors.red),
                              onPressed: _saveDeleteAction),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (widget.news.imageUrl != null && !_imageUnloadable)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                  child: CachedNetworkImage(
                    imageUrl: widget.news.imageUrl!,
                    placeholder: (context, url) => CardLoading(
                      height: 90.0,
                      cardLoadingTheme: CardLoadingTheme(
                          colorOne:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.black,
                          colorTwo:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black12
                                  : Colors.white10),
                    ),
                    errorListener: (_) =>
                        setState(() => _imageUnloadable = true),
                    errorWidget: (context, url, error) => Container(),
                    fit: BoxFit.cover,
                    height: 136.0,
                    width: 116.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
