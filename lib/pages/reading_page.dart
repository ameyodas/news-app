import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:news_app/api/llm_tts_api.dart';
import 'package:news_app/news.dart';
import 'package:news_app/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadingPage extends StatefulWidget {
  final INNews news;
  final double imgHeight;

  const ReadingPage({super.key, required this.news, this.imgHeight = 128.0});

  @override
  State<ReadingPage> createState() => ReadingPageState();
}

class Action {
  final Icon activeIcon;
  final Icon inactiveIcon;
  final Future<void> Function(bool, BuildContext?) onToggle;
  final String? label;

  Action(
      {required this.activeIcon,
      required this.inactiveIcon,
      required this.onToggle,
      this.label});
}

class ReadingPageState extends State<ReadingPage> {
  String? _summary;
  String? _translation;
  late String _contentText;

  late List<Action> _actions;
  late List<bool> _actionsState;

  @override
  void initState() {
    super.initState();
    _contentText = widget.news.content;
    _actions = <Action>[
      Action(
        inactiveIcon: const Icon(FluentIcons.filter_12_regular),
        activeIcon: const Icon(FluentIcons.filter_12_filled),
        label: 'Summarize',
        onToggle: _summarize,
      ),
      Action(
        inactiveIcon: const Icon(FluentIcons.translate_16_regular),
        activeIcon: const Icon(FluentIcons.translate_16_filled),
        label: 'Translate',
        onToggle: _translate,
      ),
      Action(
        inactiveIcon: const Icon(Icons.search_rounded),
        activeIcon: const Icon(Icons.search_rounded),
        label: 'Search',
        onToggle: (isOn, context) async {
          Navigator.of(context!).pop('search');
        },
      ),
      Action(
        inactiveIcon: const Icon(FluentIcons.play_circle_20_regular),
        activeIcon: const Icon(FluentIcons.play_circle_20_filled),
        label: 'Stream',
        onToggle: (isOn, context) async {},
      ),
      Action(
        inactiveIcon: const Icon(FluentIcons.bookmark_16_regular),
        activeIcon: const Icon(FluentIcons.bookmark_16_filled),
        label: 'Save',
        onToggle: (isOn, context) async {},
      ),
    ];

    _actionsState = List<bool>.generate(_actions.length, (_) => false);
  }

  Future<void> _summarize(bool isOn, BuildContext? context) async {
    if (isOn) {
      _summary ??= await LLMApi.instance!.summarize(
          headline: widget.news.headline,
          content: widget.news.content,
          srcLink: widget.news.sourceUrl);

      setState(() {
        _contentText = _summary!;
      });
    } else {
      setState(() {
        _contentText = widget.news.content;
      });
    }
  }

  Future<void> _translate(bool isOn, BuildContext? context) async {
    if (isOn) {
      _translation ??= await LLMApi.instance!
          .translate(content: widget.news.content, targetLang: 'bengali');

      setState(() {
        _contentText = _translation!;
      });
    } else {
      setState(() {
        _contentText = widget.news.content;
      });
    }
  }

  Widget buildActionsBar(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final barBgCol = isLight
        ? const Color.fromARGB(255, 240, 240, 240)
        : const Color.fromARGB(255, 16, 16, 16);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Material(
        clipBehavior: Clip.antiAlias,
        elevation: 24.0,
        borderRadius: BorderRadius.circular(16.0),
        shadowColor: isLight ? Colors.white : Colors.black,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: barBgCol,
            borderRadius: BorderRadius.circular(24),
          ),
          height: 58.0,
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_actions.length, (index) {
              final action = _actions[index];
              Color btnBgCol = barBgCol;
              if (_actionsState[index]) {
                btnBgCol = isLight
                    ? const Color.fromARGB(255, 210, 210, 210)
                    : const Color.fromARGB(255, 48, 48, 48);
              }

              return Container(
                width: 60,
                height: 36,
                decoration: BoxDecoration(
                  color: btnBgCol,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: _actionsState[index]
                      ? action.activeIcon
                      : action.inactiveIcon,
                  onPressed: () {
                    setState(() async {
                      _actionsState[index] = !_actionsState[index];
                      await action.onToggle(_actionsState[index], context);
                    });
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 20.0),
              onPressed: () {
                Navigator.of(context).pop();
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
                  backgroundColor: const Color.fromARGB(96, 128, 128, 128),
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
    return Scaffold(
      extendBody: true,
      appBar: buildAppBar(context),
      bottomNavigationBar: buildActionsBar(context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        clipBehavior: Clip.none,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.news.imageUrl != null)
              SizedBox(
                height: widget.imgHeight,
                width: double.infinity,
                child: Image.network(
                  widget.news.imageUrl!,
                  fit: BoxFit.cover,
                ),
              )
            else
              const SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 24.0,
                  ),
                  Text(
                    widget.news.headline,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  GptMarkdown(
                    _contentText,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16.0, fontFamily: 'Inter'),
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
