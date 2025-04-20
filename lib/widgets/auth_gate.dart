import 'package:flutter/material.dart';
import 'package:news_app/user_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  final Widget Function(BuildContext) authWidgetBuilder;
  final Widget Function(BuildContext) landingWidgetBuilder;

  const AuthGate(
      {super.key,
      required this.authWidgetBuilder,
      required this.landingWidgetBuilder});

  @override
  State<AuthGate> createState() => AuthGateState();
}

class AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();

    if (UserAccount.instance is SupabaseAccount) {
      Supabase.instance.client.auth.onAuthStateChange.listen((data) {
        final session = data.session;
        if (session != null) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserAccount.instance != null
        ? widget.landingWidgetBuilder(context)
        : widget.authWidgetBuilder(context);
  }
}
