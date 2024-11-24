import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String headline;
  final String description;
  final String imageUrl;
  final double width;
  final double height;
  final double roundness;

  const NewsCard(
      {Key? key,
      required this.headline,
      required this.description,
      required this.imageUrl,
      this.width = 256.0,
      this.height = 188.0,
      this.roundness = 24.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(this.roundness),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 5,
      child: Column(
        children: [
          // Image Section
          Stack(
            children: [
              // Background Image
              ColorFiltered(
                colorFilter:
                    ColorFilter.mode(Colors.black38, BlendMode.saturation),
                child: Container(
                  height: this.height,
                  width: this.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Gradient Overlay
              Container(
                height: this.height,
                width: this.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.25)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              // Text Content over Image
              Container(
                padding: const EdgeInsets.all(16.0),
                width: this.width,
                height: this.height,
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
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            shadows: [
                              Shadow(
                                  blurRadius: 4,
                                  color: Colors.black45,
                                  offset: Offset(1, 1)),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          description,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontFamily: 'Inter'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.thumb_up_alt_outlined,
                              color: Colors.red),
                          onPressed: () {
                            // Like action
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark_border,
                              color: Colors.white),
                          onPressed: () {
                            // Save action
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share_outlined,
                              color: Colors.white),
                          onPressed: () {
                            // Share action
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
