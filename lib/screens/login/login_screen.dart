import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hider/screens/home/home_screen.dart';
import 'package:hider/screens/sign_up/sign_up_screen.dart';
import 'package:hider/services/authentication_model.dart';
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
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const SignUpScreen(),
                      ),
                      (route) => false);
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

  bool get _canLogin {
    return _username.isNotEmpty && _password.isNotEmpty;
  }

  Future<void> _onLogin() async {
    setState(() {
      _error = '';
    });
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(_username)
        .get();
    if (!user.exists) {
      setState(() {
        _error = 'Username does not exist';
      });
      return;
    }

    AuthenticationModel.instance.login(
      username: _username,
      password: _password,
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
      (route) => false,
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
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            initialValue: _password,
            onChanged: (value) {
              setState(() {
                _password = value;
              });
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _canLogin ? _onLogin : null,
            child: const Text('Login'),
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
