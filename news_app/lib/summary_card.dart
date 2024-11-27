import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String summary;
  final double height;
  final double roundness;

  const SummaryCard(
      {Key? key,
      required this.summary,
      this.height = 178.0,
      this.roundness = 24.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(this.roundness), // Rounded corners
        side: BorderSide(
            width: 1,
            color: Theme.of(context)
                .colorScheme
                .outline), // Border color and width
      ),
      clipBehavior: Clip.none,
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(22.0),
        width: double.infinity,
        height: this.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Feed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),
              Text(
                summary,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
