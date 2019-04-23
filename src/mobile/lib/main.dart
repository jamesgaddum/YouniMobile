import 'package:flutter/widgets.dart';
import 'widgets/task_bar_chart.dart';
import 'package:youni/blocs/task_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  TaskBloc _taskBloc;

  @override
  void initState() {
    super.initState();
    _taskBloc = TaskBloc();
    _taskBloc.fetchAllTasks();
  }

  @override
  Widget build(BuildContext context) {

    var taskWeights = _taskBloc.allTaskWeights;

    return Container(
      color: Color.fromRGBO(240, 240, 240, 1.0),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: FractionallySizedBox(
          heightFactor: 0.33,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: StreamBuilder(
              stream: taskWeights,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return TaskBarChart(snapshot.data);
                } else {
                  return Text('An error has occured');
                }
              }
            )
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _taskBloc.dispose();
    super.dispose();
  }
}
