import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hider/screens/home/home_screen.dart';
import 'package:hider/screens/login/login_screen.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/widgets/animated_visibility.dart';

/// The sign up screen.
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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
              child: _SignUpForm(),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                      (route) => false);
                },
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The form displayed in the login screen.
class _SignUpForm extends StatefulWidget {
  const _SignUpForm({Key? key}) : super(key: key);

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  var _username = '';
  var _password1 = '';
  var _password2 = '';
  var _error = '';

  bool get _canSignUp {
    return _username.isNotEmpty &&
        _password1.isNotEmpty &&
        _password2.isNotEmpty &&
        _password1 == _password2;
  }

  Future<void> _onSignUp() async {
    setState(() {
      _error = '';
    });
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(_username)
        .get();
    if (user.exists) {
      setState(() {
        _error = 'Username already exists';
      });
      return;
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_username)
        .set({'password': _password1}, SetOptions(merge: true));

    AuthenticationModel.instance.login(
      username: _username,
      password: _password1,
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
    return Column(
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
          obscureText: true,
          initialValue: _username,
          onChanged: (value) {
            setState(() {
              _password1 = value;
            });
          },
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Confirm password',
            errorText:
                _password1 != _password2 ? 'Passwords do not match' : null,
          ),
          obscureText: true,
          initialValue: _username,
          onChanged: (value) {
            setState(() {
              _password2 = value;
            });
          },
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _canSignUp ? _onSignUp : null,
          child: const Text('Sign up'),
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
    );
  }
}
