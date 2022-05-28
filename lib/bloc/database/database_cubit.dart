import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'database_state.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  DatabaseCubit() : super(DatabaseInitialState());

  Database? database;
  Future<void>initDatabase()async{
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath,'todo.db');
    if(await Directory(dirname(path)).exists()){
      //
      database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
            await db.execute(
                'CREATE TABLE todo (id INTEGER PRIMARY KEY, name TEXT)');
          });
      emit(DatabaseLoadedState());
    }else{
      try{
        await Directory(dirname(path)).create(recursive: true);
        database = await openDatabase(path, version: 1,
            onCreate: (Database db, int version) async {
              await db.execute(
                  'CREATE TABLE todo (id INTEGER PRIMARY KEY, name TEXT)');
            });
        emit(DatabaseLoadedState());
      }catch(e){
        log(e.toString());
      }
    }
  }
}
