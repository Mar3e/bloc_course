import 'package:bloc_course/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({required String email, required String password});
}

@immutable
class LoginApi implements LoginApiProtocol {
  const LoginApi();
  @override
  Future<LoginHandle?> login(
          {required String email, required String password}) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => email == "foo@bar.com" && password == "foobar",
      ).then(
        (isLoggedIn) => isLoggedIn ? const LoginHandle.fooBar() : null,
      );
}
