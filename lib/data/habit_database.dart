import 'package:habbit_tracker/datetime/date_time.dart';
import 'package:hive/hive.dart';

final _myBox = Hive.box('Habit_Database');

class HabitDatabase {
  List todayHabitsList = [];
  Map<DateTime, int> heatMapDataSet = {};
  int currentStreak = 0;

  // UI streak to account for today
  int get displayStreak {
    final String today = todaysDateFormatted();
    double todayPercent = double.parse(
      _myBox.get('PERCENTAGE_SUMMARY_$today') ?? '0.0',
    );
    return todayPercent == 1.0 ? currentStreak + 1 : currentStreak;
  }

  // check if we need to update streak
  void maybeUpdateStreak() {
    String today = todaysDateFormatted();
    String lastUpdateDate = _myBox.get('LAST_STREAK_UPDATE', defaultValue: '');

    if (lastUpdateDate != today) {
      updateStreak();
      _myBox.put('LAST_STREAK_UPDATE', today);
    }
  }

  void updateStreak() {
    String yesterday = convertDateTimeToString(
      createDateTimeObject(
        todaysDateFormatted(),
      ).subtract(const Duration(days: 1)),
    );

    double yesterdayPercent = double.parse(
      _myBox.get('PERCENTAGE_SUMMARY_$yesterday') ?? '0.0',
    );

    int streak = _myBox.get('STREAK', defaultValue: 0);

    if (yesterdayPercent == 1.0) {
      streak++;
    } else {
      streak = 0;
    }

    currentStreak = streak;
    _myBox.put('STREAK', currentStreak);
  }

  // create initial data
  void createDefaultData() {
    todayHabitsList = [
      ['Run', false],
      ['Read', false],
    ];
    _myBox.put('START_DATE', todaysDateFormatted());
    _myBox.put('STREAK', 0);
  }

  // load data
  void loadData() {
    // if it is the new day, get habit list from db
    if (_myBox.get(todaysDateFormatted()) == null) {
      todayHabitsList = _myBox.get('CURRENT_HABIT_LIST');
      // set everything back to false
      for (int i = 0; i < todayHabitsList.length; i++) {
        todayHabitsList[i][1] = false;
      }
    }
    // if it is the same day, load todays list
    else {
      todayHabitsList = _myBox.get(todaysDateFormatted());
    }
    currentStreak = _myBox.get('STREAK');
  }

  // update database
  void updateDatabase() {
    _myBox.put(todaysDateFormatted(), todayHabitsList);
    _myBox.put('CURRENT_HABIT_LIST', todayHabitsList);

    calculateHabitPercentages();
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countComplete = 0;
    for (int i = 0; i < todayHabitsList.length; i++) {
      if (todayHabitsList[i][1] == true) {
        countComplete++;
      }
    }
    String percent =
        todayHabitsList.isEmpty
            ? '0.0'
            : (countComplete / todayHabitsList.length).toStringAsFixed(1);
    // key = PERCENTAGE_SUMMARY_ddmmyyyy
    // value = 0.0-1.0
    _myBox.put('PERCENTAGE_SUMMARY_${todaysDateFormatted()}', percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get('START_DATE'));
    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;
    for (int i = 0; i <= daysInBetween; i++) {
      String ddmmyyyy = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get('PERCENTAGE_SUMMARY_$ddmmyyyy') ?? '0.0',
      );

      int year = startDate.add(Duration(days: i)).year;

      int month = startDate.add(Duration(days: i)).month;

      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
