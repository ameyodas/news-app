import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
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
        SnackBar(
            content: Text(
              "Email and password cannot be empty",
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black),
            ),
            backgroundColor: Colors.red),
      );
      return;
    }

    try {
      //await UserAccount.set(SupabaseAccount());
      var account = SupabaseAccount();
      await account.init();
      await account.signUp(email: email, password: password);
      //await UserAccount.instance!.signIn(email: email, password: password);

      //debugPrint("context mounted: ${context.mounted}");

      if (!context.mounted) return;

      //debugPrint("Pop to login lage");

      //Navigator.of(context).pop();

      final color = Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black;
      final snackBar = SnackBar(
          content: Row(
            children: [
              Icon(FluentIcons.mail_inbox_16_filled, color: color),
              const SizedBox(width: 16.0),
              Text(
                "Confirm using the email sent to you",
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    color: color),
              ),
            ],
          ),
          backgroundColor: Colors.green);

      // Show the snackbar and wait for it to close
      ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((_) {
        if (context.mounted) {
          debugPrint("pop");
          Navigator.of(context).pop();
        }
      });
    } on AuthException catch (e) {
      debugPrint("Hello");
      if (context.mounted) {
        final color = Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                Icon(FluentIcons.dismiss_12_filled, color: color),
                const SizedBox(width: 16.0),
                Text(
                  e.message,
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                      color: color),
                ),
              ],
            ),
            backgroundColor: Colors.red));
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
