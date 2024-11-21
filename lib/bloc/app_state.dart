import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart' show immutable;

extension Comparsion<E> on List<E> {
  bool isEqualTo(List<E> other) {
    if (identical(this, other)) return true;

    if (length != other.length) return false;

    for (int i = 0; i < length; i++) {
      if (this[i] != other[i]) return false;
    }

    return true;
  }
}

@immutable
class AppState {
  final bool isLoading;
  final Uint8List? data;
  final Object? error;

  const AppState({
    required this.isLoading,
    required this.data,
    required this.error,
  });

  const AppState.empty()
      : this(
          isLoading: false,
          data: null,
          error: null,
        );

  @override
  String toString() => {
        'isLoading': isLoading,
        'data': data != null,
        'error': error,
      }.toString();

  @override
  bool operator ==(covariant AppState other) =>
      isLoading == other.isLoading &&
      (data ?? []).isEqualTo(other.data ?? []) &&
      error == other.error;

  @override
  int get hashCode => Object.hash(isLoading, data, error);
}
