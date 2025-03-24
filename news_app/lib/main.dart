import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/home_page.dart';
import 'package:news_app/pages/search_page.dart';
import 'package:news_app/theme.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() => NewsAppState();
}

class MyIconData {
  IconData normal;
  IconData active;
  String? label;

  MyIconData({required this.normal, required this.active, this.label});
}

class NewsAppState extends State<NewsApp> {
  int _currentPageIndex = 0;
  late List<Widget> _pages;

  NewsAppState() {
    _pages = [
      HomePage(onMessage: onMessage),
      SearchPage(onMessage: onMessage),
      SearchPage(onMessage: onMessage),
      SearchPage(onMessage: onMessage),
      SearchPage(onMessage: onMessage)
    ];
  }

  final List<MyIconData> _pageIconData = [
    MyIconData(
        normal: FluentIcons.home_empty_20_regular,
        active: FluentIcons.home_empty_20_filled,
        label: 'Home'),
    MyIconData(
        normal: FluentIcons.play_circle_20_regular,
        active: FluentIcons.play_circle_20_filled,
        label: 'Stream'),
    MyIconData(
        normal: Icons.search_rounded,
        active: Icons.search_rounded,
        label: 'Search'),
    MyIconData(
        normal: FluentIcons.bookmark_16_regular,
        active: FluentIcons.bookmark_16_filled,
        label: 'Saved'),
    MyIconData(
        normal: FluentIcons.mail_inbox_16_regular,
        active: FluentIcons.mail_inbox_16_filled,
        label: 'Newsletter')
  ];

  void onMessage(String message) {
    if (message == 'search') {
      setState(() {
        _currentPageIndex = 2;
      });
    }
  }

  BottomNavigationBar buildNavBar(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _currentPageIndex,
      onTap: (index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      items: _pageIconData
          .map((iconData) => BottomNavigationBarItem(
                icon: Icon(iconData.normal),
                activeIcon: Icon(iconData.active),
                label: iconData.label ?? '',
              ))
          .toList(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('In',
              style: TextStyle(
                fontFamily: 'UnifrakturMaguntia',
                fontWeight: FontWeight.normal,
                fontSize: 22.0,
              )),
        ),
        // title: const Text('InstaNews',
        //     style: TextStyle(
        //         fontFamily: 'Montserrat',
        //         fontSize: 16.0,
        //         fontWeight: FontWeight.w500)),
        // centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(FluentIcons.person_12_regular))
        ]);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NewsApp',
        theme: INTheme.light(),
        darkTheme: INTheme.dark(),
        themeMode: INTheme.mode,
        home: Scaffold(
            appBar: buildAppBar(context),
            bottomNavigationBar: buildNavBar(context),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              clipBehavior: Clip.none,
              child: IndexedStack(
                index: _currentPageIndex,
                children: _pages,
              ),
            )));
  }
}
