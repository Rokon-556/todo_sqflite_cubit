import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_sqflite_bloc/repository/todo_repo.dart';

import '../../models/todo_model.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final _todoRepo = TodoRepository();
  final Database database;
  TodoCubit({required this.database}) : super(TodoInitialState(0));
  int counter = 1;
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  Future<void> getTodos() async {
    try {
      _todos = await _todoRepo.getTodo(database: database);
      emit(TodoInitialState(counter++));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addTodo(String text) async {
    try {
      await _todoRepo.addTodo(database: database, text: text);
      emit(TodoAddState());
      getTodos();
    } catch (e) {
      log(e.toString());
    }
  }
  Future<void> removeTodo(int id) async {
    try {
      await _todoRepo.removeTodo(database: database, id: id);
      emit(TodoAddState());
      getTodos();
    } catch (e) {
      log(e.toString());
    }
  }
}
