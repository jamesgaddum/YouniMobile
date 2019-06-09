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
    var task = Task('Task', weight, DateTimeHelper.oneWeekFromNow());
    var weights = List<TaskWeight>();

    // Act
    taskBloc.addTaskToWeights(task, weights);
    
    // Assert
    assert(weights.last.weight == weight);
    assert(weights[3].weight == weight / 4);
    assert(weights.first.weight == weight / task.datesTillDue());
  });

  test('Tasks are added to weights', () {
    // Arrange
    var weight1 = 20.0;
    var task1 = Task('Task', weight1, DateTimeHelper.oneWeekFromNow());
    var weight2 = 10.0;
    var task2 = Task('Task', weight2, DateTimeHelper.oneWeekFromNow());
    var weights = List<TaskWeight>();

    // Act
    taskBloc.addTaskToWeights(task1, weights);
    taskBloc.addTaskToWeights(task2, weights);
    
    // Assert
    assert(weights.last.weight == weight1 + weight2);
    assert(weights[3].weight == (weight1 / 4) + (weight2 / 4));
    assert(weights.first.weight == (weight1 + weight2) / max(task1.datesTillDue(), task2.datesTillDue()));
  });

  test('Task weights have correct length', () {
    // Arrange
    var tasks = [
      Task('Task', 20, DateTimeHelper.oneWeekFromNow()),
      Task('Task', 30, DateTimeHelper.twoWeeksFromNow())
    ];

    // Act
    var taskWeights = taskBloc.getTaskWeights(tasks);

    // Assert
    assert(tasks[1].datesTillDue() == taskWeights.length - 1);
  });

  test('Task due today is added correctly', () {
    // Arrange
    var tasks = [
      Task('Task', 20, DateTimeHelper.eleven59Today())
    ];

    // Act
    var taskWeights = taskBloc.getTaskWeights(tasks);

    // Assert
    assert(1 == taskWeights.length);
    assert(tasks[0].adjustedWeight == taskWeights[0].weight);
  });

  test('Task due tomorrow is added correctly', () {
    // Arrange
    var tasks = [
      Task('Task', 20, DateTimeHelper.middayTomorrow())
    ];

    // Act
    var taskWeights = taskBloc.getTaskWeights(tasks);

    // Assert
    assert(2 == taskWeights.length);
    assert(tasks[0].adjustedWeight == taskWeights[1].weight);
  });

  test('Task due the next day is added correctly', () {
    // Arrange
    var tasks = [
      Task('Task', 20, DateTimeHelper.middayDayAfterTomorrow())
    ];

    // Act
    var taskWeights = taskBloc.getTaskWeights(tasks);

    // Assert
    assert(3 == taskWeights.length);
    assert(tasks[0].adjustedWeight / 3 == taskWeights.first.weight);
    assert(tasks[0].adjustedWeight / 2 == taskWeights[1].weight);
    assert(tasks[0].adjustedWeight == taskWeights.last.weight);
  });
}