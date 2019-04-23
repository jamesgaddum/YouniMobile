class DateTimeHelper {

  static DateTime middayToday() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 12, 00, 00, 00, 000);
  }

  static DateTime eleven59Today() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59, 99, 999);
  }

  static DateTime oneSecondPastMidnight() {
    var tomorrow = DateTime.now().add(Duration(days: 1));
    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 00, 00, 01, 00, 000);
  }

  static DateTime oneWeekFromNow() {
    return DateTime.now().add(Duration(days: 7));
  }

  static DateTime twoWeeksFromNow() {
    return DateTime.now().add(Duration(days: 14));
  }
}