import 'package:flutter_test/flutter_test.dart';
import 'package:youni/models/entities/task.dart';
import 'package:youni/util/datetime_helper.dart';

void main() {
  test('Task is due in future', () {
    // Arrange
    var task = Task('Task', 20, DateTime.now().add(Duration(days: 10)));

    // Act
    // Assert
    assert(!task.isOverdue());
    assert(!task.isDueLaterToday());
    assert(task.datesTillDue() == 10);
  });

  test('Task is due today', () {
    // Arrange
    var task = Task('Task', 20, DateTimeHelper.eleven59Today());

    // Act
    // Assert
    assert(!task.isOverdue());
    assert(task.isDueLaterToday());
    assert(task.datesTillDue() == 0);
  });

  test('Task is due tomorrow', () {
    // Arrange
    var task = Task('Task', 20, DateTimeHelper.oneSecondPastMidnight());

    // Act
    // Assert
    assert(!task.isOverdue());
    assert(!task.isDueLaterToday());
    assert(task.datesTillDue() == 1);
  });

  test('Task is overdue today', () {
    // Arrange
    var task = Task('Task', 20, DateTime.now());

    // Act
    // Assert
    assert(task.isOverdue());
    assert(!task.isDueLaterToday());
    assert(task.datesTillDue() == 0);
  });

  test('Task was due yesterday', () {
    // Arrange
    var task = Task('Task', 20, DateTime.now().subtract(Duration(days: 1)));

    // Act
    // Assert
    assert(task.isOverdue());
    assert(task.datesTillDue() == -1);
  });

  test('Asking for day weight outside of due date throws error', () {
    // Arrange
    var now = DateTime.now();
    var dueDate = DateTimeHelper.oneWeekFromNow();
    var daysTillDue = dueDate.difference(now).inDays;
    var task = Task('Task', 14, dueDate);

    // Act
    // Assert
    expect(() => task.dayWeight(daysTillDue + 3), throwsArgumentError);
  });

  test('Task has correct day weight start', () {
    // Arrange
    var task = Task('Task', 14, DateTimeHelper.oneWeekFromNow());

    // Act
    var weight = task.dayWeight(0);

    // Assert
    assert(2 == weight);
  });

  test('Task has correct day weight middle', () {
    // Arrange
    var task = Task('Task', 14, DateTimeHelper.oneWeekFromNow());

    // Act
    var weight = task.dayWeight(3);

    // Assert
    assert((14 / 4) == weight);
  });

  test('Task has correct day weight end', () {
    // Arrange
    var task = Task('Task', 14, DateTimeHelper.oneWeekFromNow());

    // Act
    var weight = task.dayWeight(7);

    // Assert
    assert(14 == weight);
  });

  test('Task due today has correct day weight', () {
    // Arrange
    var task = Task('Task', 14, DateTimeHelper.eleven59Today());

    // Act
    var weight = task.dayWeight(0);

    // Assert
    assert(14 == weight);
  });

  test('Task due in one week has correct day weights', () {
    // Arrange
    var task = Task('Task', 14, DateTimeHelper.oneWeekFromNow());

    // Act
    var weights = task.dayWeights();

    // Assert
    assert(7 == weights.length);
    assert(2 == weights[0].weight);
    assert((14 / 6) == weights[1].weight);
    assert((14 / 5) == weights[2].weight);
    assert((14 / 4) == weights[3].weight);
    assert((14 / 3) == weights[4].weight);
    assert((14 / 2) == weights[5].weight);
    assert(14 == weights[6].weight);
  });
}