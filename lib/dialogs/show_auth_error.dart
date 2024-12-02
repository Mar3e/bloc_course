import 'package:bloc_course/auth/auth_errors.dart';
import 'package:bloc_course/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.title,
    content: authError.message,
    optionsBuilder: () => {
      'OK': true,
    },
  );
}
