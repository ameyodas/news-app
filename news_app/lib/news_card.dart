import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String headline;
  final String description;
  final String imageUrl;
  final double imgWidth;
  final double imgHeight;
  final double roundness;

  const NewsCard(
      {Key? key,
      required this.headline,
      required this.description,
      required this.imageUrl,
      this.imgWidth = 256.0,
      this.imgHeight = 90.0,
      this.roundness = 24.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(this.roundness),
        side:
            BorderSide(width: 1, color: Theme.of(context).colorScheme.outline),
      ),
      clipBehavior: Clip.none,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              width: this.imgWidth,
              height: this.imgHeight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(this.roundness - 8.0)),
              child: Image.network(
                this.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            SizedBox(
              width: this.imgWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        headline,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        description,
                        style:
                            const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            splashRadius: 18.0,
                            iconSize: 18.0,
                            icon: const Icon(Icons.bookmark_border),
                            onPressed: () {
                              // Save action
                            },
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            splashRadius: 18.0,
                            iconSize: 18.0,
                            icon: const Icon(Icons.share_outlined),
                            onPressed: () {
                              // Share action
                            },
                          ),
                        ],
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        splashRadius: 18.0,
                        iconSize: 18.0,
                        icon: const Icon(Icons.thumb_up_alt_outlined,
                            color: Colors.red),
                        onPressed: () {
                          // Like action
                        },
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
