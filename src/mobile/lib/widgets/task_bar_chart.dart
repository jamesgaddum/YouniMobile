import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:youni/models/values/task_weight.dart';

class TaskBarChart extends StatelessWidget {
  final List<TaskWeight> taskWeights;

  TaskBarChart(this.taskWeights);

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      _extractChartData(),
      defaultRenderer: charts.BarRendererConfig<DateTime>(),
      defaultInteractions: false,
      behaviors: [charts.SelectNearest(), charts.DomainHighlighter()],
    );
  }
 
  List<charts.Series<TaskWeight, DateTime>> _extractChartData() {
    return [
      charts.Series<TaskWeight, DateTime>(
        id: 'Weights',
        domainFn: (TaskWeight weight, _) => weight.date,
        measureFn: (TaskWeight weight, _) => weight.weight,
        data: taskWeights,
      )
    ];
  }
}
