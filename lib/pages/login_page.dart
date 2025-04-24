import 'package:flutter/material.dart';
import 'package:news_app/api/db_api.dart';
import 'package:news_app/page_route_builder.dart';
import 'package:news_app/pages/interests_page.dart';
import 'package:news_app/pages/landing_page.dart';
import 'package:news_app/pages/register_page.dart';
import 'package:news_app/user_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  final void Function(dynamic)? callback;

  const LoginPage({super.key, this.callback});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await UserAccount.set(SupabaseAccount());
      await UserAccount.instance!.signIn(email: email, password: password);

      if (!context.mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        INPageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LandingPage()),
        (Route<dynamic> route) => false,
      );
    } on AuthException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed")),
      );
    }
  }

  Future<void> _useLocally(BuildContext context) async {
    final account = LocalAccount();
    await UserAccount.set(account);
    await UserAccount.instance!.signIn();

    final interests = await DBApi.instance!.getInterests();
    if (!context.mounted) return;

    void openLandingPage(BuildContext context) =>
        Navigator.of(context).pushAndRemoveUntil(
          INPageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LandingPage()),
          (Route<dynamic> route) => false,
        );

    if (interests == null) {
      Navigator.of(context).push(INPageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              InterestsPage(
                interests: null,
                onClose: openLandingPage,
              )));
    } else {
      openLandingPage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 32.0,
            ),
            const Text('Email'),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: false,
              enableSuggestions: true,
              autocorrect: false,
              decoration: const InputDecoration(hintText: 'xyz@email.com'),
              controller: _emailController,
            ),
            const SizedBox(
              height: 16.0,
            ),
            const Text('Password'),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(hintText: 'xxxxxxxx'),
              controller: _passwordController,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50.0)),
              child: const Text('Sign in'),
              onPressed: () {
                _signIn(context);
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 26.0, vertical: 18.0),
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.black,
                    foregroundColor:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black54
                                    : Colors.white60))),
                onPressed: () {
                  Navigator.of(context).push(INPageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const RegisterPage()));
                },
                child: const Text('Register')),
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t wanna sign up? '),
                InkWell(
                  child: const Text('Use locally',
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                          decorationStyle: TextDecorationStyle.solid)),
                  onTap: () {
                    _useLocally(context);
                  },
                )
              ],
            ),
            const SizedBox(height: 64.0)
          ],
        ),
      ),
    );
  }
}
