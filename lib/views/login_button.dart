import 'package:bloc_course/dialogs/generic_dialog.dart';
import 'package:bloc_course/strings.dart';
import 'package:flutter/material.dart';

typedef OnLoginTapped = void Function(
  String email,
  String password,
);

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTapped,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final OnLoginTapped onLoginTapped;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          final email = emailController.text;
          final password = passwordController.text;
          if (email.isEmpty || password.isEmpty) {
            showGenericDialog(
              context: context,
              title: emailOrPasswordEmptyDialogTitle,
              content: emailOrPasswordEmptyDescription,
              optionBuilder: () => {ok: true},
            );
          } else {
            onLoginTapped(email, password);
          }
        },
        child: const Text(
          login,
        ));
  }
}
