import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/news_provider_api.dart';
import 'package:news_app/interests.dart';
import 'package:news_app/news.dart';
import 'package:news_app/widgets/animated_expansion_tile.dart';
import 'package:news_app/widgets/chips.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/section.dart';

class SearchTab extends StatefulWidget {
  final void Function(dynamic)? callback;

  const SearchTab({super.key, this.callback});

  @override
  State<SearchTab> createState() => SearchTabState();
}

class SearchTabState extends State<SearchTab> {
  String? _sectionTitle;

  String? _keywords;
  List<String>? _tags;
  DateTime? _startDate;
  DateTime? _endDate;

  List<INNews>? _news;

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null &&
        (picked.start != _startDate || picked.end != _endDate)) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  String _formatDate(DateTime date, bool includeYear) {
    const months = <String>[
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

    return '${months[date.month - 1]} ${date.day}${includeYear ? ', ${date.year}' : ''}';
  }

  Future<void> _beginFetchNews() async {
    final news = await NewsProviderApi.instance!.search(
        keywords: _keywords,
        tags: _tags,
        startDate: _startDate,
        endDate: _endDate);

    setState(() {
      _news = news;
    });
  }

  @override
  void initState() {
    super.initState();
    _beginFetchNews();
  }

  Widget _buildSearchOptionWidgets(BuildContext context) {
    return AnimatedExpansionTile(
      children: [
        Wrap(
          spacing: 8.0,
          children: INTags.all.map((tag) {
            if (tag.isEmpty) {
              throw const FormatException('Tag is empty!');
            }
            tag = '${tag[0].toUpperCase()}${tag.toLowerCase().substring(1)}';
            return INFilterChip(
              text: tag,
              textStyle: TextStyle(
                  fontSize: 14.0,
                  color: (Theme.of(context).brightness == Brightness.light &&
                              (_tags?.contains(tag) ?? false) ||
                          (Theme.of(context).brightness == Brightness.dark &&
                              (_tags?.contains(tag) ?? false))
                      ? Colors.black87
                      : Colors.white)),
              selected: _tags?.contains(tag) ?? false,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromARGB(255, 32, 32, 32)
                  : const Color.fromARGB(255, 236, 236, 236),
              selectedColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color.fromARGB(255, 64, 64, 64),
              onSelected: (bool selected) {
                if (selected) {
                  _tags ??= <String>[];
                  _tags!.add(tag);
                } else {
                  _tags?.remove(tag);
                  if (_tags?.isEmpty ?? false) {
                    _tags = null;
                  }
                }
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
            ElevatedButton.icon(
              onPressed: _selectDateRange,
              icon: const Icon(FluentIcons.calendar_12_regular),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_startDate != null && _endDate != null)
                    Text(
                      _formatDate(
                          _startDate!, _startDate!.year != _endDate!.year),
                      style: const TextStyle(
                          fontFamily: 'Inter', fontWeight: FontWeight.bold),
                    ),
                  Text(
                    _startDate == null || _endDate == null ? 'Today' : ' to ',
                    style: const TextStyle(fontFamily: 'Inter'),
                  ),
                  if (_startDate != null && _endDate != null)
                    Text(
                      _formatDate(
                          _startDate!, _startDate!.year != _endDate!.year),
                      style: const TextStyle(
                          fontFamily: 'Inter', fontWeight: FontWeight.bold),
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
            const Text(
              'Region',
            ),
            const SizedBox(width: 24.0),
            ElevatedButton.icon(
              label: const Text('Home', style: TextStyle(fontFamily: 'Inter')),
              onPressed: () {},
              icon: const Icon(
                FluentIcons.location_12_regular,
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      clipBehavior: Clip.none,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32.0),
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
                  onChanged: (input) {
                    _keywords = input;
                  },
                  style: const TextStyle(fontFamily: 'Inter'),
                  decoration: const InputDecoration(
                    hintText: 'Type...',
                  ),
                ),
                const SizedBox(
                  height: 14.0,
                ),
                _buildSearchOptionWidgets(context),
                const SizedBox(height: 14.0),
                Center(
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 26.0, vertical: 18.0),
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.black,
                          foregroundColor:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black54
                                      : Colors.white60))),
                      onPressed: () {
                        _sectionTitle = 'Search Results';
                        _beginFetchNews();
                      },
                      label: const Text('Search',
                          style: TextStyle(fontFamily: 'Montserrat')),
                      icon: const Icon(Icons.search)),
                )
              ],
            ),
          ),
          if (_news?.isNotEmpty ?? false) const SizedBox(height: 70.0),
          if (_news?.isNotEmpty ?? false)
            Section(
              name: 'search_results',
              title: _sectionTitle,
              news: _news ?? const <INNews>[],
              cardBuilder: (context, news) =>
                  INNewsCard(news: news, callback: widget.callback),
              callback: widget.callback,
            )
        ],
      ),
    );
  }
}
