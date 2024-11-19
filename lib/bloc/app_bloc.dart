import 'package:bloc/bloc.dart';
import 'package:bloc_course/apis/login_api.dart';
import 'package:bloc_course/apis/notes_api.dart';
import 'package:bloc_course/bloc/actions.dart';
import 'package:bloc_course/bloc/app_state.dart';
import 'package:bloc_course/models.dart';
import 'package:bloc_course/strings.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) async {
        // Start loading
        emit(const AppState(
            isLoading: true,
            loginErrors: null,
            loginHandle: null,
            fetchedNotes: null));

        //Start login
        final loginHandel = await loginApi.login(
          email: event.email,
          password: event.password,
        );

        emit(
          AppState(
            isLoading: false,
            loginErrors: loginHandel == null ? LoginErrors.invalidHandle : null,
            loginHandle: loginHandel,
            fetchedNotes: null,
          ),
        );
      },
    );
    // load notes
    on<LoadNoteAction>(
      (event, emit) async {
        final loginHandel = state.loginHandle;
        emit(
          AppState(
            isLoading: true,
            loginErrors: null,
            loginHandle: loginHandel,
            fetchedNotes: null,
          ),
        );

        if (loginHandel != const LoginHandle.fooBar()) {
          //If we don't have a valid loginHandel
          emit(
            AppState(
              isLoading: false,
              loginErrors: LoginErrors.invalidHandle,
              loginHandle: loginHandel,
              fetchedNotes: null,
            ),
          );
          return;
        }
        //We have a valid loginHandel
        final notes = await notesApi.getNotes(loginHandle: loginHandel!);
        emit(
          AppState(
            isLoading: false,
            loginErrors: null,
            loginHandle: loginHandel,
            fetchedNotes: notes,
          ),
        );
      },
    );
  }
}
