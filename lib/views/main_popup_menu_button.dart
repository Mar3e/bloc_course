import 'package:bloc_course/bloc/app_bloc.dart';
import 'package:bloc_course/bloc/app_event.dart';
import 'package:bloc_course/dialogs/delete_account_dialog.dart';
import 'package:bloc_course/dialogs/logout_dialog.dart';
import 'package:bloc_course/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MenuAction {
  logout("Logout"),
  deleteAccount("Delete Account");

  final String title;

  const MenuAction(this.title);
}

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogout = await showLogOutDialog(context);
            if (shouldLogout && context.mounted) {
              context.read<AppBloc>().add(const AppEventLogOut());
            }
            break;
          case MenuAction.deleteAccount:
            final shouldDelete = await showDeleteAccountDialog(context);
            if (shouldDelete && context.mounted) {
              context.read<AppBloc>().add(const AppEventDeleteAccount());
            }
            break;
        }
      },
      itemBuilder: (context) {
        return [
          for (final action in MenuAction.values)
            PopupMenuItem(
              value: action,
              child: Text(action.title),
            )
        ];
      },
    );
  }
}
