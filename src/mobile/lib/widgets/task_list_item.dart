import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:youni/models/entities/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  TaskListItem(this.task);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.taskId.toString()),
    );
  }
}