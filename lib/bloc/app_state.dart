import 'package:bloc_course/auth/auth_errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;
  const AppState({
    required this.isLoading,
    this.authError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;
  const AppStateLoggedIn({
    required super.isLoading,
    super.authError,
    required this.user,
    required this.images,
  });

  @override
  bool operator ==(Object other) {
    final otherClass = other;
    if (otherClass is AppStateLoggedIn) {
      return isLoading == otherClass.isLoading &&
          user.uid == otherClass.user.uid &&
          images.length == otherClass.images.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(user.uid, images);

  @override
  String toString() => 'AppStateLoggedIn{user: $user, images: $images}';
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    required super.isLoading,
    super.authError,
  });

  @override
  String toString() =>
      'AppStateLoggedOut("authError" $authError, "isLoading" $isLoading)';
}

@immutable
class AppStateIsInRegistrationView extends AppState {
  const AppStateIsInRegistrationView({
    required super.isLoading,
    super.authError,
  });
}

extension GetUser on AppState {
  User? get user {
    final shadow = this;
    if (shadow is AppStateLoggedIn) {
      return shadow.user;
    } else {
      return null;
    }
  }
}

extension GetImages on AppState {
  Iterable<Reference>? get images {
    final shadow = this;
    if (shadow is AppStateLoggedIn) {
      return shadow.images;
    } else {
      return null;
    }
  }
}
