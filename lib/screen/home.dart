import 'package:demo_sqlite/bloc/database_bloc.dart';
import 'package:demo_sqlite/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseBloc databaseBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String title = '', description = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    databaseBloc.close();
  }

  void createATodo(String title, String description) {
    ToDo todo = ToDo(title: title, description: description);
    databaseBloc.onCreate(todo);
  }

  void deleteATodo(ToDo todo) {
    databaseBloc.onDelete(todo);
  }

  void showDeleteDialog(ToDo todo) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext _) {
        return AlertDialog(
          title: Text('Are you sure?'),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Delete'),
              color: Colors.red,
              onPressed: () {
                deleteATodo(todo);
                FlutterToast.showToast(msg: 'Todo is deleted!');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showInputDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext _) {
        double customHeight = MediaQuery.of(context).size.height * .3;
        double customWidth = MediaQuery.of(context).size.width * .5;
        int maxTitleLength = 128, maxDescriptionLength = 256;

        return AlertDialog(
          title: Text('Add a new todo'),
          content: Container(
            height: customHeight,
            width: customWidth,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    maxLength: maxTitleLength,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      labelText: 'Title',
                    ),
                    validator: (String value) {
                      if (value.trim() == '') {
                        return 'Title should not be empty!';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      print(value);
                      title = value;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    maxLength: maxDescriptionLength,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      labelText: 'Description',
                    ),
                    validator: (String value) {
                      return null;
                    },
                    onSaved: (String value) {
                      print(value);
                      description = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                }
                _formKey.currentState.save();
                createATodo(title, description);
                Navigator.pop(context);
                FlutterToast.showToast(msg: 'Todo is added successfully!');
              },
            ),
          ],
        );
      },
    );
  }

  void updateToDoStatus(ToDo todo) {
    databaseBloc.onUpdate(todo);

    FlutterToast.showToast(
        msg: todo.status == 0 ? 'Marked as Completed!' : 'Undone todo!');
  }

  @override
  Widget build(BuildContext context) {
    databaseBloc = BlocProvider.of<DatabaseBloc>(context);
    databaseBloc.onFetch();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todos',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: showInputDialog,
          ),
        ],
      ),
      body: Container(
        child: BlocBuilder(
          bloc: databaseBloc,
          builder: (BuildContext _, DatabaseState state) {
            return state.todos.length == 0
                ? Center(
                    child: Text('Empty todo list.'),
                  )
                : ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (_, idx) {
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actions: [
                          state.todos[idx].status == 0
                              ? Card(
                                  child: IconSlideAction(
                                    caption: 'Mark as Done',
                                    icon: Icons.done,
                                    color: Colors.green,
                                    onTap: () =>
                                        updateToDoStatus(state.todos[idx]),
                                  ),
                                )
                              : Card(
                                  child: IconSlideAction(
                                    caption: 'Cancel',
                                    icon: Icons.cancel,
                                    color: Colors.red,
                                    onTap: () =>
                                        updateToDoStatus(state.todos[idx]),
                                  ),
                                ),
                        ],
                        secondaryActions: [
                          Card(
                            child: IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () => showDeleteDialog(
                                state.todos[idx],
                              ),
                            ),
                          ),
                        ],
                        child: Card(
                          child: ListTile(
                            title: Text(
                              state.todos[idx].title,
                              style: TextStyle(
                                decoration: state.todos[idx].status == 0
                                    ? TextDecoration.none
                                    : TextDecoration.lineThrough,
                              ),
                            ),
                            subtitle: Text(
                              state.todos[idx].description,
                              style: TextStyle(
                                decoration: state.todos[idx].status == 0
                                    ? TextDecoration.none
                                    : TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
