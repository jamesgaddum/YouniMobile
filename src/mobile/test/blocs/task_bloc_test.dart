import 'package:flutter_test/flutter_test.dart';
import 'package:youni/models/entities/task.dart';
import 'package:youni/blocs/task_bloc.dart';
import 'package:youni/models/values/task_weight.dart';
import 'package:youni/util/datetime_helper.dart';
import 'dart:math';

void main() {

  var taskBloc = TaskBloc();

  test('Task is added to weights', () {
    // Arrange
    var weight = 20.0;
    var task = Task(weight, DateTimeHelper.oneWeekFromNow());
    var weights = List<TaskWeight>();

    // Act
    taskBloc.addTaskToWeights(task, weights);
    
    // Assert
    assert(weights.last.weight == weight);
    assert(weights[3].weight == weight / 4);
    assert(weights.first.weight == weight / task.daysTillDue());
  });

  test('Tasks are added to weights', () {
    // Arrange
    var weight1 = 20.0;
    var task1 = Task(weight1, DateTimeHelper.oneWeekFromNow());
    var weight2 = 10.0;
    var task2 = Task(weight2, DateTimeHelper.oneWeekFromNow());
    var weights = List<TaskWeight>();

    // Act
    taskBloc.addTaskToWeights(task1, weights);
    taskBloc.addTaskToWeights(task2, weights);
    
    // Assert
    assert(weights.last.weight == weight1 + weight2);
    assert(weights[3].weight == (weight1 / 4) + (weight2 / 4));
    assert(weights.first.weight == (weight1 + weight2) / max(task1.daysTillDue(), task2.daysTillDue()));
  });

  test('Task weights have correct length', () {
    // Arrange
    var tasks = [
      Task(20, DateTimeHelper.oneWeekFromNow()),
      Task(30, DateTimeHelper.twoWeeksFromNow())
    ];

    // Act
    var taskWeights = taskBloc.getTaskWeights(tasks);

    // Assert
    assert(tasks[1].daysTillDue() == taskWeights.length);
  });
}