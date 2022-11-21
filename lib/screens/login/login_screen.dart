import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hider/router/routes.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/services/firestore/firestore_user_service.dart';
import 'package:hider/services/user.dart';
import 'package:hider/widgets/animated_visibility.dart';

/// The login screen.
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                'Hider',
                style: theme.textTheme.displayLarge,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: _LoginForm(),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  GoRouter.of(context).go(const SignUpRoute().location);
                },
                child: const Text('Sign up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The form displayed in the login screen.
class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  var _username = '';
  var _password = '';
  var _error = '';
  var _hidePassword = true;

  bool get _canLogin {
    return _username.isNotEmpty && _password.isNotEmpty;
  }

  Future<void> _onLogin() async {
    setState(() {
      _error = '';
    });
    final user = await FirestoreUserService.getByUsername(_username);
    if (user == null) {
      setState(() {
        _error = 'Incorrect username or password';
      });
      return;
    }
    final hash = sha256.convert(utf8.encode(_password)).bytes;
    if (!listEquals(user.password, hash)) {
      setState(() {
        _error = 'Incorrect username or password';
      });
      return;
    }

    AuthenticationModel.instance.login(
      User(id: user.id, username: _username, password: _password),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
            initialValue: _username,
            onChanged: (value) {
              setState(() {
                _username = value;
              });
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  _hidePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _hidePassword = !_hidePassword;
                  });
                },
              ),
            ),
            initialValue: _password,
            onChanged: (value) {
              setState(() {
                _password = value;
              });
            },
            onEditingComplete: () {
              if (_canLogin) {
                _onLogin();
              }
            },
            obscureText: _hidePassword,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _canLogin ? _onLogin : null,
            child: const Text('Log in'),
          ),
          AnimatedVisibility(
            visible: _error.isNotEmpty,
            child: Center(
              child: Text(
                _error,
                style: TextStyle(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
