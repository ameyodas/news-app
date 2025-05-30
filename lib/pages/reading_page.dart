import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:news_app/api/db_api.dart';
import 'package:news_app/event_bus.dart';
import 'package:news_app/news.dart';
import 'package:news_app/theme.dart';
import 'package:news_app/widgets/action_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadingPage extends StatefulWidget {
  final INNews news;
  final double imageHeight;
  final bool isSavedInitially;

  const ReadingPage(
      {super.key,
      required this.news,
      required this.isSavedInitially,
      this.imageHeight = 180.0});

  @override
  State<ReadingPage> createState() => ReadingPageState();
}

class ReadingPageState extends State<ReadingPage> {
  late NewsData _newsData;

  late bool _isSaved;
  late bool _isLiked;
  var _imageUnloadable = false;

  late ScrollController _scrollController;
  bool _showActionsBar = true;

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showActionsBar) setState(() => _showActionsBar = false);
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_showActionsBar) setState(() => _showActionsBar = true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    _newsData = NewsData.fromNews(widget.news);
    _isSaved = widget.isSavedInitially;
    _isLiked = false;
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 20.0),
              onPressed: () {
                Navigator.of(context).pop({'saved': _isSaved});
              },
            )),
        title: Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: () async {
                  final Uri url = Uri.parse(widget.news.sourceUrl);
                  if (!await launchUrl(url) && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Couldn\'t open url!')),
                    );
                  }
                },
                onLongPress: () async {
                  await Clipboard.setData(
                      ClipboardData(text: widget.news.sourceUrl));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('URL copied')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: const Color.fromARGB(80, 128, 128, 128),
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.black54
                          : Colors.white54,
                ),
                child: Text(
                  widget.news.sourceName,
                  style: const TextStyle(fontFamily: 'Raleway'),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          )
        ]),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  INTheme.toggleMode();
                });
              },
              icon: Icon(Theme.of(context).brightness == Brightness.light
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final readingTime = _newsData.estimateReadingTime();

    return Scaffold(
      extendBody: true,
      appBar: buildAppBar(context),
      bottomNavigationBar: ActionBar(
        news: widget.news,
        onAction: (result) => setState(() => _newsData = result),
        isVisible: _showActionsBar,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        clipBehavior: Clip.none,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.news.imageUrl != null && !_imageUnloadable)
              CachedNetworkImage(
                imageUrl: widget.news.imageUrl!,
                placeholder: (context, url) => CardLoading(
                  width: double.infinity,
                  height: widget.imageHeight,
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
                width: double.infinity,
                height: widget.imageHeight,
              )
            else
              const SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 24.0,
                  ),
                  Text(
                    _newsData.headline,
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Raleway',
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    'Published 32 mins ago • $readingTime ${readingTime > 1 ? "mins" : "min"} to read',
                    style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Montserrat',
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    children: [
                      IconButton.filled(
                          isSelected: _isSaved,
                          onPressed: () async {
                            if (!_isSaved) {
                              await DBApi.instance!.storeArticle(widget.news);
                              eventBus.fire(NewsSavedEvent());
                            } else {
                              await DBApi.instance!
                                  .deleteArticle(widget.news.newsId);
                              eventBus.fire(NewsDeleteEvent());
                            }
                            setState(() => _isSaved = !_isSaved);
                          },
                          icon: const Icon(FluentIcons.bookmark_16_regular),
                          selectedIcon:
                              const Icon(FluentIcons.bookmark_16_filled)),
                      IconButton.filled(
                        isSelected: _isLiked,
                        onPressed: () {
                          setState(() => _isLiked = !_isLiked);
                        },
                        icon: const Icon(
                          FluentIcons.heart_12_regular,
                          color: Colors.red,
                        ),
                        selectedIcon: const Icon(FluentIcons.heart_12_filled,
                            color: Colors.red),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  GptMarkdown(
                    _newsData.content,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(
                    height: 36.0,
                  ),
                  Center(
                    child: InkWell(
                      child: const Text('Show more like this',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                              decorationStyle: TextDecorationStyle.solid)),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(
                    height: 90.0,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
