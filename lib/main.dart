import 'package:bloc_course/bloc/app_bloc.dart';
import 'package:bloc_course/bloc/app_event.dart';
import 'package:bloc_course/bloc/app_state.dart';
import 'package:bloc_course/dialogs/show_auth_error.dart';
import 'package:bloc_course/firebase_options.dart';
import 'package:bloc_course/loading/loading_screen.dart';
import 'package:bloc_course/views/login_view.dart';
import 'package:bloc_course/views/photo_gallery_view.dart';
import 'package:bloc_course/views/register_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        title: 'Bloc Photo Library',
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen.instance()
                  .show(context: context, text: 'Loading...');
            } else {
              LoadingScreen.instance().hide();
            }

            final authError = state.authError;
            if (authError != null) {
              showAuthError(
                authError: authError,
                context: context,
              );
            }
          },
          builder: (context, state) {
            if (state is AppStateLoggedOut) {
              return const LoginView();
            } else if (state is AppStateIsInRegistrationView) {
              return const RegisterView();
            } else if (state is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else {
              return const Scaffold(
                body: Center(
                  child: Text('Ops something went wrong'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
