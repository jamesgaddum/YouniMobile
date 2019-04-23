import 'package:uuid/uuid.dart';
import 'package:youni/models/values/task_weight.dart';
import 'package:youni/util/datetime_helper.dart';

class Task {
  Uuid taskId;
  double unadjustedWeight;
  double adjustedWeight;
  double progress;
  DateTime dueDate;

  Task(this.unadjustedWeight, this.dueDate, {this.progress = 0}) {
    taskId = Uuid();
    updateProgress(progress);
  }

  String dueDateString() => '${dueDate.day}/${dueDate.month}';

  int daysTillDue() {
    var days = dueDate.difference(DateTime.now()).inDays;
    if (days > 1) {
      return days + 1;
    }
    if (isOverdue() || isDueLaterToday()) {
      return 0;
    }
    return 1; // due tomorrow
  }

  bool isOverdue() => dueDate.difference(DateTime.now()).isNegative;

  bool isDueLaterToday() {
    return !isOverdue() && dueDate.day == DateTime.now().day;
  }

  double dayWeight(int day) {
    var days = daysTillDue();
    if (day > days) {
      throw ArgumentError('day $day cannot be outside of range daysTillDue $days');
    }
    if (days < 1 || day == days) {
      return adjustedWeight;
    }
    return adjustedWeight / (days - day);
  }

  List<TaskWeight> dayWeights() {
    var now = DateTimeHelper.middayToday();
    var days = daysTillDue();
    return List<TaskWeight>.generate(days, (day) {
      var date = now.add(Duration(days: day));
      return TaskWeight(date, dayWeight(day));
    });
  }

  void updateProgress(newProgress) {
    progress = newProgress;
    adjustedWeight = unadjustedWeight * (1 - progress);
  }
}