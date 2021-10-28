import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_change_notifier/controller/auth_controller.dart';
import 'package:riverpod_todo_change_notifier/providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginPage> {
  bool _isLoading = false;
  set isLoading(bool value) => setState(() => _isLoading = value);

  String _user = 'bob';
  String _password = 'ross';

  // Get a reference to the authController that can be used to sign in
  AuthController get auth => ref.read(authController);

  // Use the authController.login action to complete login, it will show a new page if login was successful.
  void _handleLoginPressed() async {
    if (_user.isEmpty || _password.isEmpty) return;
    isLoading = true;
    bool success = await auth.loginAndShowInitialPage(user: _user, password: _password);
    if (!success) isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const Text("Please wait...")
            : SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(initialValue: _user, onChanged: (v) => _user = v.trim()),
                    TextFormField(initialValue: _password, onChanged: (v) => _password = v.trim(), obscureText: true),
                    CupertinoButton(onPressed: _handleLoginPressed, child: const Text("Login")),
                  ],
                ),
              ),
      ),
    );
  }
}
