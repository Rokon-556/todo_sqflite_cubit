import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sqflite_bloc/bloc/database/database_cubit.dart';
import 'package:todo_sqflite_bloc/bloc/todo/todo_cubit.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DatabaseCubit()..initDatabase(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _text = '';
  TodoCubit? _todoCubit;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocConsumer<DatabaseCubit, DatabaseState>(
        listener: (context, state) {
          if (state is DatabaseLoadedState) {
            _todoCubit =
                TodoCubit(database: context.read<DatabaseCubit>().database!);
          }
        },
        builder: (context, state) {
          if (state is DatabaseLoadedState) {
            return BlocProvider<TodoCubit>(
              create: (context) => _todoCubit!..getTodos(),
              child: BlocConsumer<TodoCubit, TodoState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is TodoInitialState) {
                    final todos = _todoCubit!.todos;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextField(
                            maxLines: 1,
                            onChanged: (newVal) {
                              setState(() {
                                _text = newVal;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          todos[index].text,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _todoCubit!
                                              .removeTodo(todos[index].id);
                                        },
                                        icon: const Icon(Icons.delete),
                                      )
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 10,
                                    ),
                                itemCount: todos.length),
                          )
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
            );
          } else {
            return const Center(
              child: Text('Database not found'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_todoCubit != null) {
            log(_text);
            _todoCubit!.addTodo(_text);
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
