import 'package:youni/repositories/task_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youni/models/entities/task.dart';
import 'package:youni/models/values/task_weight.dart';
import 'package:youni/util/datetime_helper.dart';

class TaskBloc {
  
  TaskRepository _taskRepository;
  BehaviorSubject<List<Task>> _taskSubject;
  
  Observable<List<Task>> allTasks;
  Observable<List<TaskWeight>> allTaskWeights;

  TaskBloc() {
    _taskRepository = TaskRepository();
    _taskSubject = BehaviorSubject.seeded(fetchAllTasks());

    allTasks = _taskSubject.stream;
    allTaskWeights = allTasks.map((tasks) => getTaskWeights(tasks));
  }

  List<Task> fetchAllTasks() {
    return _taskRepository.getTasks();
  }

  void refresh() {
    _taskSubject.sink.add(fetchAllTasks());
  }

  List<TaskWeight> getTaskWeights(List<Task> tasks) {
    var weights = List<TaskWeight>();
    tasks.forEach((task) {
      addTaskToWeights(task, weights);
    });
    return weights;
  }

  void addTaskToWeights(task, weights) {
    var days = task.daysTillDue();
      for (var day = 0; day < days; day++) {
        if (weights.length == day) {
          weights.add(TaskWeight(DateTimeHelper.middayToday().add(Duration(days: day + 1)), task.dayWeight(day)));
        } else {
          weights[day].weight += task.dayWeight(day);
        }
      }
  }

  dispose() {
    _taskSubject.close();
  }
}