import 'dart:typed_data' show Uint8List;
import 'package:bloc_course/bloc/app_bloc.dart';
import 'package:bloc_course/bloc/app_state.dart';
import 'package:bloc_course/bloc/bloc_events.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

final textData1 = "foo".toUint8List();
final textData2 = "bar".toUint8List();

void main() {
  blocTest<AppBloc, AppState>(
    'Initial state of the bloc should be empty',
    build: () => AppBloc(allUrls: []),
    verify: (bloc) => expect(bloc.state, const AppState.empty()),
  );

  blocTest<AppBloc, AppState>(
    'When loading a data, it should be correct',
    build: () => AppBloc(
      allUrls: [],
      urlPicker: (_) => "",
      urlLoader: (_) => Future.value(textData1),
    ),
    act: (bloc) => bloc.add(const LoadNextUrl()),
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: textData1,
        error: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'When a url loader throw an error, the state should catch it',
    build: () => AppBloc(
      allUrls: [],
      urlPicker: (_) => "",
      urlLoader: (_) => Future.error("error"),
    ),
    act: (bloc) => bloc.add(const LoadNextUrl()),
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      const AppState(
        isLoading: false,
        data: null,
        error: "error",
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'When loading a data multiple times, the bloc should be able to handle it',
    build: () => AppBloc(
      allUrls: [],
      urlPicker: (_) => "",
      urlLoader: (_) => Future.value(textData2),
    ),
    act: (bloc) {
      bloc.add(const LoadNextUrl());
      bloc.add(const LoadNextUrl());
    },
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: textData2,
        error: null,
      ),
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: textData2,
        error: null,
      ),
    ],
  );
}
