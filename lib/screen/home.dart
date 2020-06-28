import 'package:demo_sqlite/bloc/database_bloc.dart';
import 'package:demo_sqlite/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseBloc databaseBloc;
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
        TextEditingController title = TextEditingController(),
            description = TextEditingController();
        return AlertDialog(
          title: Text('Add a new todo'),
          content: Container(
            height: customHeight,
            width: customWidth,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  maxLength: maxTitleLength,
                  controller: title,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    labelText: 'Title',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLength: maxDescriptionLength,
                  controller: description,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    labelText: 'Description',
                  ),
                ),
              ],
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
                createATodo(title.text, description.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void updateToDoStatus(ToDo todo) {
    print('Updating');
    databaseBloc.onUpdate(todo);
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
