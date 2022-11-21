import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hider/router/routes.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/services/firestore/firestore_item_service.dart';
import 'package:hider/services/firestore/firestore_user_service.dart';
import 'package:hider/services/user.dart';
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
                  GoRouter.of(context).go(const LoginRoute().location);
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
  var _hidePassword = true;
  var _error = '';
  final _passwordFocusNode1 = FocusNode();
  final _passwordFocusNode2 = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode1.dispose();
    _passwordFocusNode2.dispose();
    super.dispose();
  }

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
    final router = GoRouter.of(context);

    final confirm = (await showDialog<bool>(
          context: context,
          builder: (_) => const _ConfirmationDialog(),
        )) ??
        false;
    if (!confirm) return;

    final existingUser = await FirestoreUserService.getByUsername(_username);

    if (existingUser != null) {
      setState(() {
        _error = 'Username already exists';
      });
      return;
    }

    final user = await FirestoreUserService.save(
      username: _username,
      password: _password1,
    );

    await FirestoreItemService.collection.doc(user.id).set(const {});

    AuthenticationModel.instance.login(User(
      id: user.id,
      username: _username,
      password: _password1,
    ));

    router.go(const HomeRoute().location);
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
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            _passwordFocusNode1.requestFocus();
          },
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
          obscureText: _hidePassword,
          initialValue: _username,
          onChanged: (value) {
            setState(() {
              _password1 = value;
            });
          },
          focusNode: _passwordFocusNode1,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            _passwordFocusNode2.requestFocus();
          },
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Confirm password',
            errorText:
                _password1 != _password2 ? 'Passwords do not match' : null,
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
          obscureText: _hidePassword,
          initialValue: _username,
          onChanged: (value) {
            setState(() {
              _password2 = value;
            });
          },
          onEditingComplete: () {
            if (_canSignUp) {
              _onSignUp();
            }
          },
          focusNode: _passwordFocusNode2,
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

class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure about your password?'),
      content: const Text(
        'This password will be used to encrypt your data. You won\'t be able to change it later. If you forget your password, you won\'t be able to access your data.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Continue'),
        ),
      ],
    );
  }
}
