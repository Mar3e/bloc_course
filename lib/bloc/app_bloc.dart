import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_course/auth/auth_errors.dart';
import 'package:bloc_course/bloc/app_event.dart';
import 'package:bloc_course/bloc/app_state.dart';
import 'package:bloc_course/utils/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    // handling app initialization event
    on<AppEventInitialize>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        // if we don't have a valid user, then make the state as logged out
        if (user == null) {
          emit(const AppStateLoggedOut(
            isLoading: false,
          ));
        } else {
          final images = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: images,
            ),
          );
        }
      },
    );

    //handling registration event
    on<AppEventRegister>(
      (event, emit) async {
        emit(const AppStateIsInRegistrationView(
          isLoading: true,
        ));
        final email = event.email;
        final password = event.password;
        try {
          final credentials =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: credentials.user!,
              images: [],
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateIsInRegistrationView(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    // handling go to login event
    on<AppEventGoToLogin>(
      (event, emit) async {
        emit(const AppStateLoggedOut(
          isLoading: false,
        ));
      },
    );

    // handling login event
    on<AppEventLogIn>(
      (event, emit) async {
        emit(const AppStateLoggedOut(isLoading: true));
        // login the user
        try {
          final email = event.email;
          final password = event.password;
          final credentials =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final user = credentials.user!;
          final images = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: images,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedOut(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    // handling go to registration event
    on<AppEventGoToRegistration>(
      (event, emit) async {
        emit(const AppStateIsInRegistrationView(
          isLoading: false,
        ));
      },
    );

    // handling logging out event
    on<AppEventLogOut>(
      (event, emit) async {
        emit(const AppStateLoggedOut(
          isLoading: true,
        ));
        await FirebaseAuth.instance.signOut();
        emit(const AppStateLoggedOut(
          isLoading: false,
        ));
      },
    );

    // handling account deletion event
    on<AppEventDeleteAccount>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        // if we don't have a valid user, then make the state as logged out
        if (user == null) {
          emit(const AppStateLoggedOut(
            isLoading: false,
          ));
          return;
        }
// start loading
        emit(
          AppStateLoggedIn(
            isLoading: true,
            user: user,
            images: state.images ?? [],
          ),
        );

        try {
          final folder = await FirebaseStorage.instance.ref(user.uid).listAll();
          for (final image in folder.items) {
            await image.delete();
            // usually we would like to handle the error here, but for learning propose we are not
          }
          // delete the folder itself
          await FirebaseStorage.instance.ref(user.uid).delete();
          // delete the user
          await user.delete();
          // make the state as logged out
          await FirebaseAuth.instance.signOut();
          emit(const AppStateLoggedOut(
            isLoading: false,
          ));
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: state.images ?? [],
              authError: AuthError.from(e),
            ),
          );
        } on FirebaseException {
          // for learning propose, we are not handling the error just logging user out
          emit(const AppStateLoggedOut(
            isLoading: false,
          ));
        }
      },
    );

    // handling upload image event
    on<AppEventUploadImage>(
      (event, emit) async {
        final user = state.user;
        // if we don't have a valid user, then make the state as logged out
        if (user == null) {
          emit(const AppStateLoggedOut(
            isLoading: false,
          ));

          return;
        }
// get ready to upload the image
        emit(
          AppStateLoggedIn(
            isLoading: true,
            user: user,
            images: state.images ?? [],
          ),
        );
        // upload the image
        final file = File(event.imagePathToUpload);
        await uploadImage(image: file, userId: user.uid);

        // refresh the images reference
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
          ),
        );
      },
    );
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance.ref(userId).list().then(
            (listResults) => listResults.items,
          );
}
