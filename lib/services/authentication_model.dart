class AuthenticationModel {
  static final instance = AuthenticationModel();

  var username = '';
  var password = '';

  void login({required String username, required String password}) {
    this.username = username;
    this.password = password;
  }

  void logout() {
    username = '';
    password = '';
  }
}
