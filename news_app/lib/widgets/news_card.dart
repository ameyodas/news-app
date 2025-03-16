import 'package:flutter/material.dart';
import 'package:news_app/news.dart';
import 'package:news_app/widgets/chips.dart';

class INNewsCard extends StatelessWidget {
  final INNews news;
  final double imgWidth;
  final double imgHeight;

  const INNewsCard(
      {super.key,
      required this.news,
      this.imgWidth = 256.0,
      this.imgHeight = 90.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (news.imageUrl != null)
          SizedBox(
            height: imgHeight,
            width: double.infinity,
            child: Image.network(
              news.imageUrl!,
              fit: BoxFit.cover,
            ),
          )
        else
          const SizedBox(
            height: 4.0,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.headline,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (news.tags != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: news.tags!
                            .map((e) => Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: INChip(
                                    text: e,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  const SizedBox(height: 8.0),
                  Text(
                    news.content,
                    style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
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
    );
  }
}
