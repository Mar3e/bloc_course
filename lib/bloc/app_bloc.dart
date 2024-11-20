import 'package:bloc_course/bloc/app_state.dart';
import 'package:bloc_course/bloc/bloc_events.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math show Random;

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _randomUrlPicker(Iterable<String> allUrls) =>
      allUrls.getRandomElement();
  AppBloc({
    required Iterable<String> allUrls,
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? urlPicker,
  }) : super(const AppState.empty()) {
    on<LoadNextUrl>(
      (event, emit) async {
        // Loading state
        emit(
          const AppState(
            isLoading: true,
            data: null,
            error: null,
          ),
        );
        final url = (urlPicker ?? _randomUrlPicker)(allUrls);
        try {
          if (waitBeforeLoading != null) {
            await Future.delayed(waitBeforeLoading);
          }
          // Success state
          final bundle = NetworkAssetBundle(Uri.parse(url));
          final data = (await bundle.load(url)).buffer.asUint8List();

          emit(
            AppState(
              isLoading: false,
              data: data,
              error: null,
            ),
          );
        } catch (error) {
          emit(
            AppState(
              isLoading: false,
              data: null,
              error: error,
            ),
          );
        }
      },
    );
  }
}
