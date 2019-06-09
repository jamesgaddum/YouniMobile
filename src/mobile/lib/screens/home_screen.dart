import 'package:flutter/widgets.dart';
import 'package:youni/blocs/task_bloc.dart';
import 'package:youni/models/entities/task.dart';
import 'package:youni/widgets/task_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:youni/widgets/task_line_chart.dart';
import 'package:youni/widgets/task_list.dart';
import 'package:youni/widgets/task_list_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TaskBloc _taskBloc;
  double height = 200;

  @override
  void initState() {
    super.initState();
    _taskBloc = TaskBloc();
  }

  @override
  Widget build(BuildContext context) {

    var lineChartBox = Expanded(
      flex: 6,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: TaskLineChart(),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      ),
    );

    var chartBox = Expanded(
      flex: 6,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 10, 20),
        child: StreamBuilder(
          stream: _taskBloc.allTasks,
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
      flex: 10,
      child: Container(
        child: StreamBuilder(
          stream: _taskBloc.allTasks,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return  _buildTaskList(snapshot.data);
            } else if (snapshot.hasError) {
              return Text('An error occurred');
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      )
    );

    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.only(top: 30),
          ),
        ),
        //lineChartBox,
        //Divider(height: 1,),
        //chartBox,
        Divider(height: 1,),
        taskList,
        StreamBuilder(
          stream: _taskBloc.allTasks,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return TaskList(snapshot.data);
            } else {
              return Text('An error has occured');
            }
          }
        )
      ],
    );
  }

  _buildTaskList(List<Task> tasks) {
    return AnimatedList(
      padding: EdgeInsets.all(0),
      initialItemCount: tasks.length * 2,
      itemBuilder: (context, i, animation) {
        if (i.isOdd) {
          return Divider(height: 1,);
        }
        var index = i ~/ 2;
        if (index < tasks.length) {
          var task = tasks[index];
          return TaskListItem(task, _selectTask, _deselectTask, _updateList, _updateGraph, task.isSelected, key: ObjectKey(task));
        }
      }
    );
  }

  _selectTask(Task task) {
    _taskBloc.selectTasks([task]);
  }

  _deselectTask(Task task) {
    _taskBloc.deselectTasks([task]);
  }

  _updateList() {
    _taskBloc.refreshAll();
  }

  _updateGraph() {
    _taskBloc.refreshGraph();
  }
}