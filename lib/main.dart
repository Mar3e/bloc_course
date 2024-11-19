import 'package:bloc_course/apis/login_api.dart';
import 'package:bloc_course/apis/notes_api.dart';
import 'package:bloc_course/bloc/actions.dart';
import 'package:bloc_course/bloc/app_bloc.dart';
import 'package:bloc_course/bloc/app_state.dart';
import 'package:bloc_course/dialogs/generic_dialog.dart';
import 'package:bloc_course/dialogs/loading_screen.dart';
import 'package:bloc_course/models.dart';
import 'package:bloc_course/strings.dart';
import 'package:bloc_course/views/iterable_list_view.dart';
import 'package:bloc_course/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Bloc course',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: const LoginApi(),
        notesApi: const NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bloc course - $homePage'),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            // loading state
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }
            // display  errors
            if (appState.loginErrors != null) {
              showGenericDialog<bool>(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {ok: true},
              );
            }

            // If we logged in successfully,but we have no notes, fetch them
            if (appState.isLoading == false &&
                appState.loginErrors == null &&
                appState.loginHandle == const LoginHandle.fooBar() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(const LoadNoteAction());
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginView(
                (email, password) {
                  context
                      .read<AppBloc>()
                      .add(LoginAction(email: email, password: password));
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
