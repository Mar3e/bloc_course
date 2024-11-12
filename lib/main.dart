import 'dart:convert';
import 'dart:io';

import 'package:bloc_course/bloc/bloc_actions.dart';
import 'package:bloc_course/bloc/person_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/person.dart';

const person1Url = "10.0.2.2:8000/p1";
const person2Url = "10.0.2.2:8000/p2";

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
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
                    context.read<PersonBloc>().add(
                          const LoadPersonsAction(
                            url: person1Url,
                            loader: getPersons,
                          ),
                        );
                  },
                  child: const Text("Load person 1")),
              ElevatedButton(
                  onPressed: () {
                    context.read<PersonBloc>().add(
                          const LoadPersonsAction(
                            url: person2Url,
                            loader: getPersons,
                          ),
                        );
                  },
                  child: const Text("Load person 2")),
            ],
          )
        ],
      ),
    );
  }
}
