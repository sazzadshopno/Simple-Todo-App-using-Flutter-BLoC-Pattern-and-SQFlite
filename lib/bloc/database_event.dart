part of 'database_bloc.dart';

class DatabaseEvent {}

class CreateToDo extends DatabaseEvent {
  ToDo todo;
  CreateToDo({@required this.todo});
}

class FetchToDo extends DatabaseEvent {}

class UpdateToDo extends DatabaseEvent {
  ToDo todo;
  UpdateToDo({@required this.todo});
}

class DeleteToDo extends DatabaseEvent {
  ToDo todo;
  DeleteToDo({@required this.todo});
}

class ClearToDo extends DatabaseEvent {}
