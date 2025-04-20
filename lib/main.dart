import 'package:flutter/material.dart';
import 'package:news_app/pages/login_page.dart';
import 'package:news_app/pages/landing_page.dart';
import 'package:news_app/theme.dart';
import 'package:news_app/user_account.dart';
import 'package:news_app/widgets/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserAccount.initialize();
  runApp(const NewsApp());
}

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() => NewsAppState();
}

class NewsAppState extends State<NewsApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'InstaNews',
        theme: INTheme.light(),
        darkTheme: INTheme.dark(),
        themeMode: INTheme.mode,
        home: AuthGate(
            authWidgetBuilder: (context) => const LoginPage(),
            landingWidgetBuilder: (context) => const LandingPage()));
  }
}
