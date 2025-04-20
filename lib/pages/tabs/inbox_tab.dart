import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class InboxTab extends StatefulWidget {
  final void Function(dynamic)? callback;

  const InboxTab({super.key, this.callback});

  @override
  State<InboxTab> createState() => InboxTabState();
}

class InboxTabState extends State<InboxTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(FluentIcons.mail_inbox_16_regular, size: 90.0),
          SizedBox(height: 16.0),
          Text('Inbox',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 8.0),
          Text('Coming soon!',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal))
        ],
      ),
    );
  }
}
