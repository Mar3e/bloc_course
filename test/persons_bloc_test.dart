import 'package:bloc_course/bloc/person.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_course/bloc/person_bloc.dart';
import 'package:bloc_course/bloc/bloc_actions.dart';

const mockPersons1 = [
  Person(name: "Mareai", age: 25),
  Person(name: "Ali", age: 26),
];

const mockPersons2 = [
  Person(name: "Ahmed", age: 21),
  Person(name: "Salem", age: 23),
  Person(name: "John", age: 27),
];

Future<Iterable<Person>> mockGetPerson1(String _) => Future.value(mockPersons1);

Future<Iterable<Person>> mockGetPerson2(String _) => Future.value(mockPersons2);

void main() {
  group(
    "Testing bloc",
    () {
      late PersonBloc bloc;

      setUp(
        () {
          bloc = PersonBloc();
        },
      );

      blocTest<PersonBloc, FetchResults?>(
        "Testing initial state",
        build: () => bloc,
        verify: (bloc) => expect(bloc.state, null),
      );

      blocTest<PersonBloc, FetchResults?>(
        "fetching person1 data and comparing it with fetchResult",
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonsAction(
              url: "dummy_url1",
              loader: mockGetPerson1,
            ),
          );
          bloc.add(
            const LoadPersonsAction(
              url: "dummy_url1",
              loader: mockGetPerson1,
            ),
          );
        },
        expect: () => [
          const FetchResults(persons: mockPersons1, isCached: false),
          const FetchResults(persons: mockPersons1, isCached: true),
        ],
      );

      blocTest<PersonBloc, FetchResults?>(
        "fetching person2 data and comparing it with fetchResult",
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonsAction(
              url: "dummy_url2",
              loader: mockGetPerson2,
            ),
          );
          bloc.add(
            const LoadPersonsAction(
              url: "dummy_url2",
              loader: mockGetPerson2,
            ),
          );
        },
        expect: () => [
          const FetchResults(persons: mockPersons2, isCached: false),
          const FetchResults(persons: mockPersons2, isCached: true),
        ],
      );
    },
  );
}
