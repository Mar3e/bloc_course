import 'package:bloc_course/bloc/app_bloc.dart';
import 'package:bloc_course/bloc/app_event.dart';
import 'package:bloc_course/extension/ifDebugging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends HookWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(
      text: 'bintaleb.mar@gmail.com'.ifDebugging,
    );
    final passwordController = useTextEditingController(
      text: "123456".ifDebugging,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
              decoration: const InputDecoration(
                labelText: 'Enter your email here...',
              ),
            ),
            TextField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              keyboardAppearance: Brightness.dark,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Enter your password here...',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                context.read<AppBloc>().add(
                      AppEventLogIn(
                        email: email,
                        password: password,
                      ),
                    );
              },
              child: const Text('Login'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(
                      const AppEventGoToRegistration(),
                    );
              },
              child: const Text('Not registered yet? Register now!'),
            )
          ],
        ),
      ),
    );
  }
}
