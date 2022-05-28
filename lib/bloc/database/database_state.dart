part of 'database_cubit.dart';

@immutable
abstract class DatabaseState {}

class DatabaseInitialState extends DatabaseState {}
class DatabaseLoadedState extends DatabaseState {}
