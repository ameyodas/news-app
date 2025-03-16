import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/widgets/chips.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
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
                    border: OutlineInputBorder(), hintText: 'Keywords'),
              ),
              Wrap(
                spacing: 8.0,
                children: ['Tech', 'Sci', 'Sports', 'Political'].map((tag) {
                  return INFilterChip(
                    text: tag,
                    onSelected: (bool selected) {
                      _toggleMoodSelection(tag);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // Region Chooser
        const Text(
          'Select Region:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          isExpanded: true,
          hint: const Text('Choose a Region'),
          value: selectedRegion,
          items: regions.map((region) {
            return DropdownMenuItem<String>(
              value: region,
              child: Text(region),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedRegion = value;
            });
          },
        ),
        const SizedBox(height: 20),

        // Date Chooser
        const Text(
          'Select Date Range:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: _selectDateRange,
          child: Text(selectedDateRange == null
              ? 'Choose Date Range'
              : '${selectedDateRange!.start.toString().split(' ')[0]} - ${selectedDateRange!.end.toString().split(' ')[0]}'),
        ),
      ],
    );
  }
}
