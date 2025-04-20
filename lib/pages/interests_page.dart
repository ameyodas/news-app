import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/db_api.dart';
import 'package:news_app/interests.dart';
import 'package:news_app/widgets/chips.dart';

class InterestsPage extends StatefulWidget {
  final InterestsData? interests;
  final void Function(BuildContext)? onClose;
  final void Function(dynamic)? callback;

  const InterestsPage({super.key, this.interests, this.onClose, this.callback});

  @override
  State<InterestsPage> createState() => InterestsPageState();
}

class InterestsPageState extends State<InterestsPage> {
  late List<String> _selectedTags = [];
  late List<String> _customKeywords = [];

  final _keywordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.interests != null) {
      _selectedTags = widget.interests!.tags;
      _customKeywords = widget.interests!.keywords;
    }
  }

  void _toggleCategory(String level) {
    setState(() {
      if (_selectedTags.contains(level)) {
        _selectedTags.remove(level);
      } else {
        _selectedTags.add(level);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        icon: IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            style: IconButton.styleFrom(
                backgroundColor: Colors.white, foregroundColor: Colors.black),
            icon: const Icon(FluentIcons.checkmark_12_regular),
            onPressed: () async {
              await DBApi.instance!.setInterests(InterestsData(
                  keywords: _customKeywords, tags: _selectedTags));

              if (!context.mounted) return;

              if (widget.onClose != null) {
                widget.onClose!(context);
              } else {
                Navigator.of(context).pop();
              }
            }),
        onPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Interests',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 32.0),
            Wrap(
              spacing: 8.0,
              children: INTags.all.map((tag) {
                return INFilterChip(
                  text: (String tag) {
                    if (tag.isEmpty) {
                      throw const FormatException('Tag is empty!');
                    }
                    return '${tag[0].toUpperCase()}${tag.toLowerCase().substring(1)}';
                  }(tag),
                  textStyle: TextStyle(
                      fontSize: 14.0,
                      color:
                          (Theme.of(context).brightness == Brightness.light &&
                                      !_selectedTags.contains(tag)) ||
                                  (Theme.of(context).brightness ==
                                          Brightness.dark &&
                                      _selectedTags.contains(tag))
                              ? Colors.black87
                              : Colors.white),
                  selected: _selectedTags.contains(tag),
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(255, 32, 32, 32)
                          : const Color.fromARGB(255, 236, 236, 236),
                  selectedColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color.fromARGB(255, 64, 64, 64),
                  onSelected: (bool selected) {
                    _toggleCategory(tag);
                  },
                );
              }).toList(),
            ),
            const SizedBox(
              height: 32.0,
            ),
            const Text('Custom interests'),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                      decoration: const InputDecoration(hintText: 'keyword'),
                      controller: _keywordController),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                IconButton(
                  style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  icon: const Icon(FluentIcons.add_12_filled),
                  onPressed: () {
                    if (_keywordController.text.isNotEmpty) {
                      setState(() {
                        if (!_customKeywords
                            .contains(_keywordController.text)) {
                          _customKeywords.add(_keywordController.text);
                        }
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Wrap(
                spacing: 8.0,
                children: _customKeywords
                    .map((keyword) => INDeletableChip(
                          text: keyword,
                          textStyle: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black87
                                  : Colors.white),
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : const Color.fromARGB(255, 64, 64, 64),
                          onDeleted: () {
                            setState(() => _customKeywords.remove(keyword));
                          },
                        ))
                    .toList()),
            const SizedBox(height: 128.0)
          ],
        ),
      ),
    );
  }
}
