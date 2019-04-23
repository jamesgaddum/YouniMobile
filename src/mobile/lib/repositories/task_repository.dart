import 'package:youni/models/entities/task.dart';
import 'dart:math';

class TaskRepository {

  static DateTime getRandomDay([int within = 30]) {
    return DateTime.now().add(Duration(days: Random().nextInt(within)));
  }

  static double getRandomWeight([int within = 40]) {
    return Random().nextInt(within) / 1;
  }

  var _tasks = new List<Task>.generate(7, (_) {
    return Task(getRandomWeight(), getRandomDay());
  });

  List<Task> getTasks() {
    return _tasks;
  }
}