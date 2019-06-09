import 'package:youni/models/entities/task.dart';
import 'dart:math';

class TaskRepository {

  List<Task> _tasks;

  TaskRepository() {
    _tasks = List<Task>.generate(7, (_) {
      return Task(_getRandomTitle(), _getRandomWeight(), _getRandomDay());
    }, growable: true);
  }

  static DateTime _getRandomDay([int within = 50]) {
    return DateTime.now().add(Duration(days: Random().nextInt(within)));
  }

  static double _getRandomWeight([int within = 6]) {
    return max(5, Random().nextInt(within) * 5) / 1;
  }

  static String _getRandomCourseNumber([int within = 30]) {
    return (max(10, Random().nextInt(within)) * 10).toString();
  }

  static String _getRandomTitle() {
    var subjects = ['Computer Science', 'Business', 'Statistics', 'Art History'];
    var types = ['Assignment', 'Test', 'Exam', 'Lab'];
    
    var subject = subjects[Random().nextInt(subjects.length)];
    var courseNumber = _getRandomCourseNumber();
    var type = types[Random().nextInt(types.length)];

    return '$subject $courseNumber: $type';
  }

  List<Task> getTasks() {
    return _tasks;
  }

  updateTask(Task newTask) {
    var index = _tasks.indexWhere((task) => task.taskId == newTask.taskId);
    _tasks[index] = newTask;
  }

  updateTasks(List<Task> tasks) {
    tasks.forEach((task) => updateTask(task));
  } 
}