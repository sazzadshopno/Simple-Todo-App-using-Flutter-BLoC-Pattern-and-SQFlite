import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:bloc/bloc.dart';
import 'package:demo_sqlite/model/todo.dart';
import 'package:demo_sqlite/util/DBProvider.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  @override
  DatabaseState get initialState => DatabaseInitial();

  void onCreate(ToDo todo) {
    add(
      CreateToDo(todo: todo),
    );
  }

  void onFetch() {
    add(
      FetchToDo(),
    );
  }

  void onUpdate(ToDo todo) {
    add(
      UpdateToDo(todo: todo),
    );
  }

  void onDelete(ToDo todo) {
    add(
      DeleteToDo(todo: todo),
    );
  }

  void onClear() {
    add(
      ClearToDo(),
    );
  }

  @override
  Stream<DatabaseState> mapEventToState(
    DatabaseEvent event,
  ) async* {
    if (event is CreateToDo) {
      DBProvider.db.createToDo(event.todo);
      add(
        FetchToDo(),
      );
    } else if (event is FetchToDo) {
      yield DatabaseLoaded(
        todos: await DBProvider.db.fetchAllToDo(),
      );
    } else if (event is UpdateToDo) {
      DBProvider.db.updateToDoStatus(event.todo);
      add(
        FetchToDo(),
      );
    } else if (event is DeleteToDo) {
      DBProvider.db.deleteSingleToDo(event.todo);
      add(
        FetchToDo(),
      );
    } else if (event is ClearToDo) {
      DBProvider.db.clearTodoTable();
      add(
        FetchToDo(),
      );
    }
  }
}
