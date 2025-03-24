import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api.dart';
import 'package:news_app/news.dart';
import 'package:news_app/theme.dart';

class ReadPage extends StatefulWidget {
  final INNews news;
  final double imgHeight;

  const ReadPage({super.key, required this.news, this.imgHeight = 128.0});

  @override
  State<ReadPage> createState() => ReadPageState();
}

class Action {
  final Icon activeIcon;
  final Icon inactiveIcon;
  final void Function(bool, BuildContext?) onToggle;
  final String? label;

  Action(
      {required this.activeIcon,
      required this.inactiveIcon,
      required this.onToggle,
      this.label});
}

class ReadPageState extends State<ReadPage> {
  String? _summary;

  late List<Action> _actions;
  late List<bool> _actionsState;

  @override
  void initState() {
    super.initState();
    _actions = <Action>[
      Action(
        inactiveIcon: const Icon(FluentIcons.filter_12_regular),
        activeIcon: const Icon(FluentIcons.filter_12_filled),
        label: 'Summarize',
        onToggle: summarize,
      ),
      Action(
        inactiveIcon: const Icon(FluentIcons.translate_16_regular),
        activeIcon: const Icon(FluentIcons.translate_16_filled),
        label: 'Translate',
        onToggle: (isOn, context) {},
      ),
      Action(
        inactiveIcon: const Icon(Icons.search_rounded),
        activeIcon: const Icon(Icons.search_rounded),
        label: 'Search',
        onToggle: (isOn, context) {
          Navigator.of(context!).pop('search');
        },
      ),
      Action(
        inactiveIcon: const Icon(FluentIcons.play_circle_20_regular),
        activeIcon: const Icon(FluentIcons.play_circle_20_filled),
        label: 'Stream',
        onToggle: (isOn, context) {},
      ),
      Action(
        inactiveIcon: const Icon(FluentIcons.bookmark_16_regular),
        activeIcon: const Icon(FluentIcons.bookmark_16_filled),
        label: 'Save',
        onToggle: (isOn, context) {},
      ),
    ];

    _actionsState = List<bool>.generate(_actions.length, (_) => false);
  }

  void summarize(bool isOn, BuildContext? context) async {
    if (isOn) {
      _summary ??= await INLLMApi.summarize(
          headline: widget.news.headline,
          content: widget.news.content,
          srcLink: widget.news.source);
    }
    setState(() {});
  }

  Widget buildActionsBar(BuildContext context) {
    final barBgCol = Theme.of(context).brightness == Brightness.light
        ? const Color.fromARGB(255, 240, 240, 240)
        : const Color.fromARGB(255, 16, 16, 16);

    return BottomAppBar(
      height: 58.0,
      color: barBgCol,
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_actions.length, (index) {
          final action = _actions[index];
          Color btnBgCol = barBgCol;
          if (_actionsState[index]) {
            btnBgCol = Theme.of(context).brightness == Brightness.light
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
                _actionsState[index] = !_actionsState[index];
                action.onToggle(_actionsState[index], context);
              },
            ),
          );
        }),
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: const Color.fromARGB(96, 128, 128, 128),
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.black54
                          : Colors.white54,
                ),
                child: Text(
                  widget.news.sourceTitle,
                  style: const TextStyle(fontFamily: 'Raleway'),
                  overflow: TextOverflow.fade,
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
                  // if (widget.news.tags != null)
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: Row(
                  //       children: widget.news.tags!
                  //           .map((e) => Padding(
                  //                 padding: const EdgeInsets.only(right: 8.0),
                  //                 child: INChip(
                  //                   text: e,
                  //                   backgroundColor:
                  //                       Theme.of(context).brightness ==
                  //                               Brightness.dark
                  //                           ? Colors.black
                  //                           : Colors.white,
                  //                   side: BorderSide(
                  //                     color: Theme.of(context).brightness ==
                  //                             Brightness.dark
                  //                         ? Colors.white24
                  //                         : Colors.black26,
                  //                   ),
                  //                 ),
                  //               ))
                  //           .toList(),
                  //     ),
                  //   ),

                  // Row(
                  //   children: [
                  //     ElevatedButton.icon(
                  //       onPressed: () {},
                  //       icon: const Icon(
                  //         FluentIcons.filter_12_regular,
                  //       ),
                  //       label: const Text('Summarize'),
                  //     )
                  //   ],
                  // ),

                  const SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    _actionsState[0] ? _summary! : widget.news.content,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16.0, fontFamily: 'Inter'),
                  ),
                  const SizedBox(
                    height: 32.0,
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
