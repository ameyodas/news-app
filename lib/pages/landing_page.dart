import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/db_api.dart';
import 'package:news_app/pages/interests_page.dart';
import 'package:news_app/pages/login_page.dart';
import 'package:news_app/pages/settings_page.dart';
import 'package:news_app/pages/tabs/home_tab.dart';
import 'package:news_app/pages/tabs/inbox_tab.dart';
import 'package:news_app/pages/tabs/saved_tab.dart';
import 'package:news_app/pages/tabs/search_tab.dart';
import 'package:news_app/pages/tabs/stream_tab.dart';
import 'package:news_app/user_account.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => LandingPageState();
}

class TabData {
  IconData normal;
  IconData active;
  String? label;
  Widget Function(BuildContext) builder;

  TabData(
      {required this.normal,
      required this.active,
      required this.builder,
      this.label});
}

class AccountSwitcherDialog extends StatelessWidget {
  const AccountSwitcherDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(FluentIcons.person_12_regular),
            title: Text(
                UserAccount.instance!.name() ?? UserAccount.instance!.type()),
            subtitle: const Text('Manage your Account'),
            trailing: IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(FluentIcons.arrow_exit_20_filled,
                  color: Colors.red),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
                UserAccount.set(null);
              },
            ),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
              leading: const Icon(FluentIcons.reading_list_16_filled),
              title: const Text('22 articles'),
              subtitle: const Text('38 mins • this week'),
              onTap: () {}),
          const Divider(),
          ListTile(
            leading: const Icon(FluentIcons.money_16_filled),
            title: const Text('Free'),
            subtitle: const Text('Plan'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(FluentIcons.heart_12_regular),
            title: const Text('Interests'),
            onTap: () async {
              final interests = await DBApi.instance!.getInterests();
              if (!context.mounted) return;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => InterestsPage(
                        interests: interests,
                      )));
            },
          ),
          ListTile(
            leading: const Icon(FluentIcons.settings_16_regular),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsPage()));
            },
          ),
        ],
      ),
    );
  }
}

class LandingPageState extends State<LandingPage> {
  int _currentTabIndex = 0;
  late List<TabData> _tabData;
  late List<String?> _appBarTitles;

  @override
  void initState() {
    super.initState();
    _tabData = [
      TabData(
          normal: FluentIcons.home_empty_20_regular,
          active: FluentIcons.home_empty_20_filled,
          label: 'Home',
          builder: (context) => HomeTab(callback: callback)),
      TabData(
          normal: FluentIcons.play_circle_20_regular,
          active: FluentIcons.play_circle_20_filled,
          label: 'Stream',
          builder: (context) => StreamTab(callback: callback)),
      TabData(
          normal: Icons.search_rounded,
          active: Icons.search_rounded,
          label: 'Search',
          builder: (context) => SearchTab(callback: callback)),
      TabData(
          normal: FluentIcons.bookmark_16_regular,
          active: FluentIcons.bookmark_16_filled,
          label: 'Saved',
          builder: (context) => SavedTab(callback: callback)),
      TabData(
          normal: FluentIcons.mail_inbox_16_regular,
          active: FluentIcons.mail_inbox_16_filled,
          label: 'Inbox',
          builder: (context) => InboxTab(callback: callback))
    ];
    _appBarTitles = _tabData.map((tab) => tab.label).toList();
  }

  void callback(dynamic message) {
    message = message as String;

    if (message == 'search') {
      setState(() {
        _currentTabIndex = 2;
      });
    } else if (message.startsWith('set_title')) {
      final title = message.substring('set_title'.length).trim();
      setState(() {
        _appBarTitles[_currentTabIndex] = title.isNotEmpty ? title : null;
        debugPrint(message);
      });
    }
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
        // title: _appBarTitles[_currentTabIndex] == null
        //     ? null
        //     : Text(_appBarTitles[_currentTabIndex]!,
        //         style: const TextStyle(
        //             color: Colors.grey,
        //             fontFamily: 'Raleway',
        //             fontSize: 12.0,
        //             fontWeight: FontWeight.w500)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showAccountSwitcher(context);
              },
              icon: const Icon(FluentIcons.person_12_regular))
        ]);
  }

  void showAccountSwitcher(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AccountSwitcherDialog(),
    );
  }

  BottomNavigationBar buildNavBar(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _currentTabIndex,
      onTap: (index) {
        setState(() {
          _currentTabIndex = index;
          //_currentAppBarTitle =
        });
      },
      items: _tabData
          .map((tabData) => BottomNavigationBarItem(
                icon: Icon(tabData.normal),
                activeIcon: Icon(tabData.active),
                label: tabData.label ?? '',
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        bottomNavigationBar: buildNavBar(context),
        body: IndexedStack(
          index: _currentTabIndex,
          children: _tabData
              .map((tabData) => Builder(builder: tabData.builder))
              .toList(),
        ));
  }
}
