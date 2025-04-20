import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class StreamTab extends StatefulWidget {
  final void Function(dynamic)? callback;

  const StreamTab({super.key, this.callback});

  @override
  State<StreamTab> createState() => StreamTabState();
}

class StreamTabState extends State<StreamTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(FluentIcons.play_circle_20_regular, size: 90.0),
          SizedBox(height: 16.0),
          Text('Streaming',
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
