import 'package:youni/repositories/task_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youni/models/entities/task.dart';
import 'package:youni/models/values/task_weight.dart';
import 'package:youni/util/datetime_helper.dart';
import 'dart:math';

class TaskBloc {

  int dateRange = 14;

  TaskRepository _taskRepository;
  BehaviorSubject<List<Task>> _tasksSubject;

  Observable<List<Task>> allTasks;
  Observable<List<Task>> selectedTasks;

  Observable<List<TaskWeight>> allTaskWeights;
  Observable<List<TaskWeight>> selectedTaskWeights;
  Observable<double> maxTaskWeight; 

  TaskBloc() {
    _taskRepository = TaskRepository();
    var tasks = fetchAllTasks();
    tasks.sort((a, b) => b.dayWeight(0).compareTo(a.dayWeight(0)));
    _tasksSubject = BehaviorSubject.seeded(tasks);
    _tasksSubject.debounce(Duration(milliseconds: 200));

    allTasks = _tasksSubject.stream;
    selectedTasks = allTasks.map((tasks) {
      var selected = tasks.where((task) => task.isSelected);
      return selected.length > 0 ? selected.toList() : tasks;
    });

    allTaskWeights = allTasks.map((tasks) => getTaskWeights(tasks));
    selectedTaskWeights = selectedTasks.map((tasks) => getTaskWeights(tasks));
    maxTaskWeight = selectedTasks.map((tasks) => getMaxTaskWeight(tasks));
  }

  List<Task> fetchAllTasks() {
    var tasks = _taskRepository.getTasks();
    return tasks;
  }

  List<TaskWeight> getTaskWeights(List<Task> tasks) {
    var weights = List<TaskWeight>();
    tasks.forEach((task) {
      addTaskToWeights(task, weights);
    });
    return weights;
  }

  double getMaxTaskWeight(List<Task> tasks) {
    var maximum = 0;
    tasks.forEach((task) => maximum = max(maximum, task.adjustedWeight.toInt()));
    return maximum.toDouble();
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

  void selectTasks(List<Task> tasks) {
    tasks.forEach((task) => task.isSelected = true);
    _taskRepository.updateTasks(tasks);
    _tasksSubject.sink.add(fetchAllTasks());
  }

  void deselectTasks(List<Task> tasks) {
    tasks.forEach((task) => task.isSelected = false);
    _taskRepository.updateTasks(tasks);
    _tasksSubject.sink.add(fetchAllTasks());
  }

  refreshAll() {
    var tasks = fetchAllTasks();
    tasks.sort((a, b) => b.dayWeight(0).compareTo(a.dayWeight(0)));
    _tasksSubject.sink.add(tasks);
  }

  refreshGraph() {
    var tasks = fetchAllTasks();
    _tasksSubject.sink.add(tasks);
  }

  dispose() {
    _tasksSubject.close();
  }
}