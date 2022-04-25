import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
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

  String _pN(int n) {
    final _pN = user.password.substring(0, min(user.password.length, n));
    return ' ' * (n - _pN.length) + _pN;
  }

  Encrypter get _encrypter {
    final key = Key.fromUtf8(_pN(32));
    return Encrypter(AES(key, mode: AESMode.cbc));
  }

  String encrypt(String input) {
    final iv = IV.fromUtf8(_pN(16));
    print('input $input');
    final encrypted = _encrypter.encrypt(input, iv: iv);
    return encrypted.base64;
  }

  String decrypt(String input) {
    if (input.isEmpty) return '';
    final iv = IV.fromUtf8(_pN(16));
    final encrypted = Encrypted.fromBase64(input);
    return _encrypter.decrypt(encrypted, iv: iv);
  }
}
