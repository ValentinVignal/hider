import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hider/services/user.dart';

class AuthenticationModel {
  static final instance = AuthenticationModel();

  User? _user;

  User get user => _user!;

  void login(User user) {
    _user = user;
  }

  void logout() {
    _user = null;
  }

  /// Returned the hashed value from the given [value].
  static List<int> hash(String value) =>
      sha256.convert(utf8.encode(value)).bytes;
}
