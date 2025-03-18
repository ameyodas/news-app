import 'package:flutter/material.dart';
import 'package:news_app/api.dart';
import 'package:news_app/widgets/chips.dart';
import 'package:news_app/widgets/news_card.dart';

class SearchPage extends StatefulWidget {
  final void Function(String)? onMessage;

  const SearchPage({super.key, this.onMessage});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<String> levels = ['Local', 'Regional', 'National', 'Global'];
  List<String> selectedLevels = [];
  DateTimeRange? selectedDateRange;
  List<String> regions = [
    'North America',
    'Europe',
    'Asia',
    'Africa',
    'Oceania'
  ];
  String? selectedRegion;

  void _toggleMoodSelection(String level) {
    setState(() {
      if (selectedLevels.contains(level)) {
        selectedLevels.remove(level);
      } else {
        selectedLevels.add(level);
      }
    });
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  String dateToStr(DateTime date, bool includeYear) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    toStr(date, includeYear) =>
        '${months[date.month - 1]} ${date.day}${includeYear ? ', ${date.year}' : ''}';

    return toStr(date, includeYear);

    // return '${toStr(range.start, range.start.year != range.end.year)} to ${toStr(range.end, range.start.year != range.end.year)}';
  }

  static List<Widget> addDividers(List<Widget> widgets) {
    List<Widget> result = [];
    for (int i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      result.add(const Divider(
        height: 1.0,
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Get the news\nyou want',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w600,
                    fontSize: 24.0,
                  )),
              const SizedBox(
                height: 24.0,
              ),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withAlpha(16)
                      : Colors.white.withAlpha(16),
                  hintText: 'Type...',
                  hintStyle: TextStyle(
                    fontFamily: 'Raleway',
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withAlpha(128)
                        : Colors.white.withAlpha(128),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withAlpha(16)
                            : Colors.white.withAlpha(16),
                        width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withAlpha(16)
                            : Colors.white.withAlpha(16),
                        width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withAlpha(16)
                            : Colors.white.withAlpha(16),
                        width: 1),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              ExpansionTile(
                title: const Icon(Icons.keyboard_arrow_down_rounded),
                showTrailingIcon: false,
                shape: Border.all(color: Colors.transparent),
                children: [
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
                            color: (Theme.of(context).brightness ==
                                            Brightness.light &&
                                        !selectedLevels.contains(tag)) ||
                                    (Theme.of(context).brightness ==
                                            Brightness.dark &&
                                        selectedLevels.contains(tag))
                                ? Colors.black87
                                : Colors.white),
                        selected: selectedLevels.contains(tag),
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? const Color.fromARGB(255, 32, 32, 32)
                                : const Color.fromARGB(255, 236, 236, 236),
                        selectedColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : const Color.fromARGB(255, 64, 64, 64),
                        onSelected: (bool selected) {
                          _toggleMoodSelection(tag);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Date'),
                      const SizedBox(width: 24.0),
                      ElevatedButton(
                        onPressed: _selectDateRange,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (selectedDateRange != null)
                              Text(
                                dateToStr(
                                    selectedDateRange!.start,
                                    selectedDateRange!.start.year !=
                                        selectedDateRange!.end.year),
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold),
                              ),
                            Text(
                              selectedDateRange == null
                                  ? 'Choose Date Range'
                                  : ' to ',
                              style: const TextStyle(fontFamily: 'Montserrat'),
                            ),
                            if (selectedDateRange != null)
                              Text(
                                dateToStr(
                                    selectedDateRange!.end,
                                    selectedDateRange!.start.year !=
                                        selectedDateRange!.end.year),
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Region'),
                      const SizedBox(width: 24.0),
                      ElevatedButton.icon(
                        label: const Text('Home'),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.location_on_rounded,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 96.0),
        Column(
            children: addDividers(INApi.getNews()
                .map((e) => INNewsCard(news: e, onNavPop: widget.onMessage))
                .toList())),
      ],
    );
  }
}
