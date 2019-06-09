import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:youni/models/entities/task.dart';
import 'package:youni/models/values/task_weight.dart';
import 'package:youni/util/datetime_helper.dart';
import 'dart:math';

class TaskBarChart extends StatelessWidget {
  final List<Task> tasks;

  TaskBarChart(this.tasks);

  @override
  Widget build(BuildContext context) {

    var data = _extractChartData();
    var maxWeight = 0;
    tasks.forEach((task) {
      maxWeight = max(maxWeight, (task.unadjustedWeight * 1.5).ceil());
    });

    return charts.TimeSeriesChart(
      data,
      defaultRenderer: charts.BarRendererConfig<DateTime>(),
      defaultInteractions: false,
      behaviors: [charts.SelectNearest(), charts.DomainHighlighter()],
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.StaticNumericTickProviderSpec(
          new List<charts.TickSpec<num>>.of([
            new charts.TickSpec(0),
            new charts.TickSpec(maxWeight),
          ])
        )
      ),
    );
  }
 
  List<charts.Series<TaskWeight, DateTime>> _extractChartData() {
    return [
      charts.Series<TaskWeight, DateTime>(
        id: 'Weights',
        colorFn: (_, __) => charts.Color.fromHex(code: '#0A2463'),
        domainFn: (TaskWeight weight, _) => weight.date,
        measureFn: (TaskWeight weight, _) => weight.weight,
        data: getTaskWeights(tasks),
      )
    ];
  }

  List<TaskWeight> getTaskWeights(List<Task> tasks) {
    var weights = List<TaskWeight>();
    tasks.forEach((task) {
      addTaskToWeights(task, weights);
    });
    return weights;
  }

  void addTaskToWeights(Task task, List<TaskWeight> weights) {
    var days = task.datesTillDue();
    for (var day = 0; day <= days; day++) {
      if (weights.length == day) {
        weights.add(TaskWeight(DateTimeHelper.middayToday().add(Duration(days: day)), task.dayWeight(day)));
      } else {
        weights[day].weight += task.dayWeight(day);
      }
    }
  }
}
