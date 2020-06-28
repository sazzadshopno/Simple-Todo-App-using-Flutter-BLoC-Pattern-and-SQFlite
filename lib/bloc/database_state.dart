part of 'database_bloc.dart';

abstract class DatabaseState {
  List<ToDo> todos = [];
}

class DatabaseInitial implements DatabaseState {
  List<ToDo> todos = [];
}

class DatabaseLoaded implements DatabaseState {
  List<ToDo> todos;
  DatabaseLoaded({this.todos});
}
