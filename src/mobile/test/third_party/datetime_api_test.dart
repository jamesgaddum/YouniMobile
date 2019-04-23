import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Date should be after now', () {
    // Arrange
    var now = DateTime.now();
    var future = DateTime.now().add(Duration(days: 1));

    // Act
    // Assert
    assert(future.isAfter(now));
  });

  test('Day should be the same as now', () {
    // Arrange
    var now = DateTime.now();
    var future = DateTime.now();

    // Act
    // Assert
    assert(now.day == future.day);
  });

  test('Difference in days should be 10', () {
    // Arrange
    var now = DateTime.now();
    var future = DateTime.now().add(Duration(days: 10));

    // Act
    var diff = future.difference(now);

    // Assert
    assert(diff.inDays == 10);
  });

  test('Difference should not be negative', () {
    // Arrange
    var now = DateTime.now();
    var future = DateTime.now().add(Duration(days: 10));

    // Act
    var diff = future.difference(now);

    // Assert
    assert(!diff.isNegative);
  });

  test('23 hours added is still today', () {
    // Arrange
    var now = DateTime.now();
    var future = DateTime.now().add(Duration(hours: 23));

    // Act
    var diff = future.difference(now);

    // Assert
    assert(diff.inDays == 0);
  });

  test('25 hours added is not today', () {
    // Arrange
    var now = DateTime.now();
    var future = DateTime.now().add(Duration(hours: 25));

    // Act
    var diff = future.difference(now);

    // Assert
    assert(diff.inDays == 1);
  });
}