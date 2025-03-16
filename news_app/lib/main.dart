import 'package:flutter/material.dart';
import 'package:news_app/pages/home_page.dart';
import 'package:news_app/pages/search_page.dart';

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

  MyIconData({required this.normal, required this.active});
}

class NewsAppState extends State<NewsApp> {
  int _currentPageIndex = 0;
  final List<Widget> _pages = const [
    HomePage(),
    SearchPage(),
    SearchPage(),
    SearchPage(),
    SearchPage()
  ];
  final List<MyIconData> _pageIconData = [
    MyIconData(normal: Icons.home, active: Icons.home_filled),
    MyIconData(normal: Icons.play_arrow_rounded, active: Icons.play_circle),
    MyIconData(normal: Icons.search, active: Icons.search_sharp),
    MyIconData(normal: Icons.bookmark_outline, active: Icons.bookmark),
    MyIconData(normal: Icons.email_outlined, active: Icons.email)
  ];

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
                label: '',
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
              onPressed: () {},
              icon: const Icon(Icons.supervised_user_circle_outlined))
        ]);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NewsApp',
        theme: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.black45),
            appBarTheme: const AppBarTheme(color: Colors.white)),
        darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.blueGrey,
            scaffoldBackgroundColor: Colors.black,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white54),
            appBarTheme: const AppBarTheme(color: Colors.black)),
        themeMode: ThemeMode.light,
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
