String todaysDateFormatted() {
  // today
  var dateTimeObject = DateTime.now();

  // year yyyy
  String year = dateTimeObject.year.toString();

  // month mm
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // day dd
  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  // final format
  String ddmmyyyy = day + month + year;
  return ddmmyyyy;
}

String yesterdayDateFormatted() {
  // today
  var today = DateTime.now();
  var dateTimeObject = today.subtract(Duration(days: 1));

  // year yyyy
  String year = dateTimeObject.year.toString();

  // month mm
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // day dd
  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  // final format
  String ddmmyyyy = day + month + year;
  return ddmmyyyy;
}

DateTime createDateTimeObject(String ddmmyyyy) {
  int dd = int.parse(ddmmyyyy.substring(0, 2));
  int mm = int.parse(ddmmyyyy.substring(2, 4));
  int yyyy = int.parse(ddmmyyyy.substring(4, 8));

  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
}

String convertDateTimeToString(DateTime dateTimeObject) {
    // year yyyy
  String year = dateTimeObject.year.toString();

  // month mm
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // day dd
  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  // final format
  String ddmmyyyy = day + month + year;
  return ddmmyyyy;
}
