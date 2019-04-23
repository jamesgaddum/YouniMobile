import 'package:flutter/widgets.dart';
import 'package:youni/blocs/task_bloc.dart';
import 'package:youni/models/entities/task.dart';
import 'package:youni/widgets/task_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:youni/widgets/task_list_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TaskBloc _taskBloc;

  @override
  void initState() {
    super.initState();
    _taskBloc = TaskBloc();
  }

  @override
  Widget build(BuildContext context) {

    var chartBox = Expanded(
      flex: 3,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
        child: StreamBuilder(
          stream: _taskBloc.allTaskWeights,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return TaskBarChart(snapshot.data);
            } else {
              return Text('An error has occured');
            }
          }
        )
      )
    );

    var taskList = Expanded(
      flex: 5,
      child: StreamBuilder(
        stream: _taskBloc.allTasks,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: _buildTaskList(snapshot.data),
            );
          } else if (snapshot.hasError) {
            return Text('An error occurred');
          }
          return Center(child: CircularProgressIndicator());
        },
      )
    );

    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.amber
          )
        ),
        chartBox,
        taskList
      ],
    );
  }

  _buildTaskList(List<Task> tasks) {
    return ListView.builder(
      itemCount: tasks.length * 2,
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return Divider();
        }
        var index = i ~/ 2;
        if (index < tasks.length) {
          return TaskListItem(tasks[index]);
        }
      },
    );
  }
}