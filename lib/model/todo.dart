import 'package:flutter/foundation.dart';

/*
  STATUS 1 : DONE
  STATUS 0 : YET TO BE DONE
*/

class ToDo {
  int id, status;
  String title, description;
  ToDo({
    this.id = 0,
    this.status = 0,
    @required this.title,
    @required this.description,
  });
  factory ToDo.fromMap(Map<String, dynamic> todo) {
    return ToDo(
      id: todo['id'],
      status: todo['status'],
      title: todo['title'],
      description: todo['description'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'status': this.status,
      'title': this.title,
      'description': this.description,
    };
  }
}
