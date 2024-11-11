import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final PersonsUrl url;

  const LoadPersonsAction(this.url) : super();
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
}

class PersonBloc extends Bloc<LoadAction, FetchResults?> {
  final Map<PersonsUrl, Iterable<Person>> _cache = {};
  PersonBloc() : super(null) {
    on<LoadPersonsAction>(
      (event, emit) async {
        final personUrl = event.url;
        if (_cache.containsKey(personUrl)) {
          final cachedPersons = _cache[personUrl]!;
          final result = FetchResults(persons: cachedPersons, isCached: true);
          emit(result);
        } else {
          final persons = await getPersons(personUrl.url);
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

@immutable
class Person {
  final String name;
  final int age;

  const Person({required this.name, required this.age});

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;

  @override
  String toString() => 'Person{name: $name, age: $age}';
}

// These url are served through a separate server not included in this project
// The server is a simple server that returns a json response with a person's name and age
enum PersonsUrl {
  person1("http://10.0.2.2:8000/p1"),
  person2("http://10.0.2.2:8000/p2");

  const PersonsUrl(this.url);
  final String url;
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((res) => res.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((ele) => Person.fromJson(ele)));

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => index < length ? elementAt(index) : null;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc course',
      home: BlocProvider(
        create: (_) => PersonBloc(),
        child: const HomePage(),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc course - first bloc'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<PersonBloc, FetchResults?>(
            buildWhen: (previous, current) {
              return previous?.persons != current?.persons;
            },
            builder: (context, fetchResults) {
              print(fetchResults);
              final persons = fetchResults?.persons;

              if (persons == null) {
                return const SizedBox();
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final person = persons[index]!;
                    return ListTile(
                      title: Text(person.name),
                      subtitle: Text(person.age.toString()),
                    );
                  },
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    context
                        .read<PersonBloc>()
                        .add(const LoadPersonsAction(PersonsUrl.person1));
                  },
                  child: const Text("Load person 1")),
              ElevatedButton(
                  onPressed: () {
                    context
                        .read<PersonBloc>()
                        .add(const LoadPersonsAction(PersonsUrl.person2));
                  },
                  child: const Text("Load person 2")),
            ],
          )
        ],
      ),
    );
  }
}
