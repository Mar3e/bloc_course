import 'package:bloc_course/bloc/app_state.dart';
import 'package:bloc_course/bloc/bloc_events.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math show Random;

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);
typedef AppBlocUrlLoader = Future<Uint8List> Function(String url);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _randomUrlPicker(Iterable<String> allUrls) =>
      allUrls.getRandomElement();
  Future<Uint8List> _urlLoader(String url) => NetworkAssetBundle(Uri.parse(url))
      .load(url)
      .then((byteData) => byteData.buffer.asUint8List());
  AppBloc({
    required Iterable<String> allUrls,
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? urlPicker,
    AppBlocUrlLoader? urlLoader,
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
          final data = await (urlLoader ?? _urlLoader)(url);
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
