import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/landing_page.dart';

class SettingsPage extends StatefulWidget {
  final void Function(dynamic)? callback;

  const SettingsPage({super.key, this.callback});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        icon: IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          style: IconButton.styleFrom(
              backgroundColor: Colors.white, foregroundColor: Colors.black),
          icon: const Icon(FluentIcons.arrow_right_12_filled),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LandingPage()));
          },
        ),
        onPressed: () {},
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Settings',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 32.0),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text('Theme'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text('News Provider'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text('Interests'),
            ),
          ],
        ),
      ),
    );
  }
}
