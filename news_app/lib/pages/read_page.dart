import 'package:flutter/material.dart';
import 'package:news_app/news.dart';
import 'package:news_app/widgets/chips.dart';

class ReadPage extends StatefulWidget {
  final INNews news;
  final double imgHeight;

  const ReadPage({super.key, required this.news, this.imgHeight = 128.0});

  @override
  State<ReadPage> createState() => ReadPageState();
}

class MyIconData {
  IconData normal;
  IconData active;

  MyIconData({required this.normal, required this.active});
}

class ReadPageState extends State<ReadPage> {
  final List<MyIconData> _pageIconData = [
    MyIconData(
        normal: Icons.filter_alt_rounded, active: Icons.filter_alt_rounded),
    MyIconData(
        normal: Icons.translate_rounded, active: Icons.translate_rounded),
    MyIconData(normal: Icons.search, active: Icons.search_sharp),
    MyIconData(
        normal: Icons.play_circle_outline_rounded,
        active: Icons.play_circle_filled_rounded),
    MyIconData(normal: Icons.bookmark_outline, active: Icons.bookmark),
  ];

  BottomNavigationBar buildNavBar(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 2) {
          Navigator.of(context).pop('search');
        }
      },
      items: _pageIconData
          .map((iconData) => BottomNavigationBarItem(
                icon: Icon(iconData.normal),
                activeIcon: Icon(iconData.active),
                label: '',
              ))
          .toList(),
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
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Theme.of(context).brightness == Brightness.light
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      bottomNavigationBar: buildNavBar(context),
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
                  if (widget.news.tags != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: widget.news.tags!
                            .map((e) => Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: INChip(
                                    text: e,
                                    backgroundColor:
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.black
                                            : Colors.white,
                                    side: BorderSide(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white24
                                          : Colors.black26,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    widget.news.content,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16.0, fontFamily: 'Inter'),
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
