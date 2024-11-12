import 'package:bloc_course/bloc/person.dart';
import 'package:flutter/foundation.dart' show immutable;

typedef PersonLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonLoader loader;
  const LoadPersonsAction({
    required this.url,
    required this.loader,
  }) : super();
}
