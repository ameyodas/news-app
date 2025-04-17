import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/landing_page.dart';
import 'package:news_app/widgets/chips.dart';

class InterestsPage extends StatefulWidget {
  final void Function(dynamic)? callback;

  const InterestsPage({super.key, this.callback});

  @override
  State<InterestsPage> createState() => InterestsPageState();
}

class InterestsPageState extends State<InterestsPage> {
  final List<String> _selectedCategories = [];

  void _toggleCategory(String level) {
    setState(() {
      if (_selectedCategories.contains(level)) {
        _selectedCategories.remove(level);
      } else {
        _selectedCategories.add(level);
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
          icon: const Icon(FluentIcons.arrow_right_12_filled),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LandingPage()));
          },
        ),
        onPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Preferences',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 32.0),
            Wrap(
              spacing: 8.0,
              children: [
                'Tech',
                'Sci',
                'Sports',
                'Political',
                'World',
                'Social',
                'Eco'
              ].map((tag) {
                return INFilterChip(
                  text: tag,
                  textStyle: TextStyle(
                      fontSize: 14.0,
                      color:
                          (Theme.of(context).brightness == Brightness.light &&
                                      !_selectedCategories.contains(tag)) ||
                                  (Theme.of(context).brightness ==
                                          Brightness.dark &&
                                      _selectedCategories.contains(tag))
                              ? Colors.black87
                              : Colors.white),
                  selected: _selectedCategories.contains(tag),
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
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'keyword'),
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                IconButton(
                  style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  icon: const Icon(FluentIcons.add_12_filled),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 128.0)
          ],
        ),
      ),
    );
  }
}
