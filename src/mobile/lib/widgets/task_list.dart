import 'package:flutter/widgets.dart';
import 'package:youni/models/entities/task.dart';

class TaskList extends StatefulWidget {

  final List<Task> tasks;

  TaskList(this.tasks);

  @override
  _TaskListState createState() => _TaskListState(tasks);
}

class _TaskListState extends State<TaskList> {

  List<Task> _tasks;

  _TaskListState(this._tasks);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}