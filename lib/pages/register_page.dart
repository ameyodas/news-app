import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:news_app/page_route_builder.dart';
import 'package:news_app/pages/interests_page.dart';
import 'package:news_app/pages/landing_page.dart';
import 'package:news_app/user_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  final void Function(dynamic)? callback;

  const RegisterPage({super.key, this.callback});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateState() => setState(() {});
    _emailController.addListener(updateState);
    _passwordController.addListener(updateState);
    _confirmPasswordController.addListener(updateState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  static bool _validateEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  static bool _validatePassword(String password) {
    final regex = RegExp(r'^[a-zA-Z0-9]{8,}$');
    return regex.hasMatch(password);
  }

  Icon _getMatchIcon(bool matched) {
    return matched
        ? const Icon(
            FluentIcons.checkmark_12_regular,
            color: Colors.green,
            size: 20.0,
          )
        : const Icon(
            FluentIcons.dismiss_12_regular,
            color: Colors.red,
            size: 16.0,
          );
  }

  Future<void> _register(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and password cannot be empty")),
      );
      return;
    }

    try {
      await UserAccount.set(SupabaseAccount());
      await UserAccount.instance!.signUp(email: email, password: password);
      await UserAccount.instance!.signIn(email: email, password: password);

      if (!context.mounted) return;

      Navigator.of(context).push(
        INPageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                InterestsPage(
                  onClose: (context) =>
                      Navigator.of(context).pushAndRemoveUntil(
                    INPageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const LandingPage()),
                    (Route<dynamic> route) => false,
                  ),
                )),
      );
    } on AuthException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration failed")),
        );
      }
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
            const Text('Getting Started',
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
              decoration: InputDecoration(
                  hintText: 'xyz@email.com',
                  suffixIcon: _emailController.text.isEmpty
                      ? null
                      : _getMatchIcon(_validateEmail(_emailController.text))),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
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
                decoration: InputDecoration(
                    hintText: 'xxxxxxxx',
                    suffixIcon: _passwordController.text.isEmpty
                        ? null
                        : _getMatchIcon(
                            _validatePassword(_passwordController.text))),
                controller: _passwordController),
            const SizedBox(
              height: 16.0,
            ),
            const Text('Confirm password'),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                    hintText: 'xxxxxxxx',
                    suffixIcon: _confirmPasswordController.text.isEmpty ||
                            _passwordController.text.isEmpty
                        ? null
                        : _getMatchIcon(_confirmPasswordController.text ==
                            _confirmPasswordController.text)),
                controller: _confirmPasswordController),
            const SizedBox(height: 48.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50.0)),
              child: const Text('Register'),
              onPressed: () {
                if (_validateEmail(_emailController.text) &&
                    _validatePassword(_passwordController.text) &&
                    _confirmPasswordController.text ==
                        _passwordController.text) {
                  _register(context);
                }
              },
            ),
            const SizedBox(height: 64.0)
          ],
        ),
      ),
    );
  }
}
