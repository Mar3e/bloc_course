import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;

const names = [
  'John',
  'Jane',
  'Jack',
  'Jill',
  'Jerry',
  'June',
  'Jim',
  'Jenny',
  'Joe',
  'Joan',
];

extension RandomElement<T> on Iterable<T> {
  T get randomElement => elementAt(math.Random().nextInt(length));
}

class NameCubit extends Cubit<String?> {
  NameCubit() : super(null);

  void getRandomName() => emit(names.randomElement);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Bloc course',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NameCubit _nameCubit;

  @override
  void initState() {
    super.initState();
    _nameCubit = NameCubit();
  }

  @override
  void dispose() {
    _nameCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: _nameCubit.stream,
          builder: (context, snapshot) {
            final button = ElevatedButton(
              onPressed: _nameCubit.getRandomName,
              child: const Text('Get random name'),
            );
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return button;
              case ConnectionState.waiting:
                return button;
              case ConnectionState.active:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data.toString()),
                    button,
                  ],
                );
              case ConnectionState.done:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
