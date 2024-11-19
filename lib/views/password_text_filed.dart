import 'package:bloc_course/strings.dart' show enterYourPasswordHere;
import 'package:flutter/material.dart';

class PasswordTextFiled extends StatelessWidget {
  const PasswordTextFiled({
    super.key,
    required this.passwordController,
  });
  final TextEditingController passwordController;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(hintText: enterYourPasswordHere),
    );
  }
}
