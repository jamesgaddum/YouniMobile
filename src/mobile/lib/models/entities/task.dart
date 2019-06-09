import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:youni/models/values/task_weight.dart';
import 'package:youni/util/datetime_helper.dart';

class Task {
  Uuid taskId;
  String title;
  double unadjustedWeight;
  double get adjustedWeight => unadjustedWeight * (1 - progress);
  double progress;
  DateTime dueDate;
  bool isSelected = false;

  Task(this.title, this.unadjustedWeight, this.dueDate, {this.progress = 0}) {
    taskId = Uuid();
    updateProgress(progress);
  }

  String dueDateString() => 'Due at ${DateFormat('HH:mm on MMM d').format(dueDate)}';

  String weightString() {
    var fractionalPart = adjustedWeight - adjustedWeight.truncate();
    return '${adjustedWeight.toStringAsFixed(fractionalPart > 0 ? 1 : 0)}%';
  }

  int datesTillDue() {
    var middayToday = DateTimeHelper.middayToday();
    var middayOfDueDate = DateTimeHelper.middayOf(dueDate);
    return middayOfDueDate.difference(middayToday).inDays;
  }

  bool isOverdue() => dueDate.difference(DateTime.now()).isNegative;

  bool isDueLaterToday() {
    return !isOverdue() && dueDate.day == DateTime.now().day;
  }

  double dayWeight(int day) {
    var days = datesTillDue();
    if (day > days) {
      return 0;
    }
    if (days < 1 || day == days) {
      return adjustedWeight;
    }
    if (day == 0) {
      return adjustedWeight / (days + 1);
    }
    return adjustedWeight / (days - day + 1);
  }

  List<TaskWeight> dayWeights() {
    var now = DateTimeHelper.middayToday();
    var days = datesTillDue();
    return List<TaskWeight>.generate(days, (day) {
      var date = now.add(Duration(days: day));
      return TaskWeight(date, dayWeight(day));
    });
  }

  void updateProgress(newProgress) {
    progress = newProgress;
  }
}