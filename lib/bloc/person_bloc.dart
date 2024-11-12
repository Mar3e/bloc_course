import 'package:bloc_course/bloc/bloc_actions.dart';
import 'package:bloc_course/bloc/person.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';

extension IsEqualToIgnoringOrdering<T> on Iterable<T> {
  bool isEqualToIgnoringOrdering(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

@immutable
class FetchResults {
  final Iterable<Person> persons;
  final bool isCached;

  const FetchResults({
    required this.persons,
    required this.isCached,
  });

  @override
  String toString() => 'FetchResults{persons: $persons, isCached: $isCached}';

  @override
  bool operator ==(covariant FetchResults other) =>
      persons.isEqualToIgnoringOrdering(other.persons) &&
      isCached == other.isCached;

  @override
  int get hashCode => Object.hashAll([persons, isCached]);
}

class PersonBloc extends Bloc<LoadAction, FetchResults?> {
  final Map<String, Iterable<Person>> _cache = {};
  PersonBloc() : super(null) {
    on<LoadPersonsAction>(
      (event, emit) async {
        final personUrl = event.url;
        if (_cache.containsKey(personUrl)) {
          final cachedPersons = _cache[personUrl]!;
          final result = FetchResults(persons: cachedPersons, isCached: true);
          emit(result);
        } else {
          // using the dependency injection to get the loader function
          final loader = event.loader;
          final persons = await loader(personUrl);
          _cache[personUrl] = persons;
          final result = FetchResults(
            persons: persons,
            isCached: false,
          );
          emit(result);
        }
      },
    );
  }
}
