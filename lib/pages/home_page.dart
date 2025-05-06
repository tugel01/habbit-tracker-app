import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habbit_tracker/components/exp_habit_list.dart';
import 'package:habbit_tracker/components/fab.dart';
import 'package:habbit_tracker/components/habit_header.dart';
import 'package:habbit_tracker/components/month_summary.dart';
import 'package:habbit_tracker/components/my_alert_box.dart';
import 'package:habbit_tracker/components/upper_date.dart';
import 'package:habbit_tracker/data/habit_database.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LottieComposition? _fireAnimation;

  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box('Habit_Database');

  final _headerStyle = GoogleFonts.dmSans(
    fontSize: 44,
    color: Colors.black,
  );

  @override
  void initState() {
    _loadLottie();
    if (_myBox.get('CURRENT_HABIT_LIST') == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }
    db.maybeUpdateStreak();
    super.initState();
  }

  @override
  void dispose() {
    _newHabitController.dispose();
    super.dispose();
  }

  void _loadLottie() async {
    final assetData = await rootBundle.load('assets/fire.json');
    final composition = await LottieComposition.fromByteData(assetData);
    setState(() {
      _fireAnimation = composition;
    });
  }

  // when we tap checkbox on habit
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todayHabitsList[index][1] = value!;
    });
    db.updateDatabase();
  }

  final _newHabitController = TextEditingController();
  // when we tap + fab
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitController,
          onCancel: cancelDialogBox,
          onSave: saveNewHabit,
        );
      },
    );
  }

  void cancelDialogBox() {
    Navigator.of(context).pop();
    _newHabitController.clear();
  }

  void saveNewHabit() {
    if (_newHabitController.text == '') return;
    setState(() {
      db.todayHabitsList.add([_newHabitController.text, false]);
    });
    Navigator.of(context).pop();
    _newHabitController.clear();
    db.updateDatabase();
  }

  void saveExistingHabit(int index) {
    if (_newHabitController.text == '') return;
    setState(() {
      db.todayHabitsList[index][0] = _newHabitController.text;
    });
    Navigator.of(context).pop();
    _newHabitController.clear();
    db.updateDatabase();
  }

  void deleteHabit(int index) {
    setState(() {
      db.todayHabitsList.removeAt(index);
    });
    db.updateDatabase();
  }

  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        _newHabitController.text = db.todayHabitsList[index][0];
        return MyAlertBox(
          controller: _newHabitController,
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: Column(
        children: [
          TodayDateDisplay(headerStyle: _headerStyle,),
          MonthlySummary(
            datasets: db.heatMapDataSet,
            startDate: _myBox.get('START_DATE'),
          ),
          HabitHeader(
            currentStreak: db.displayStreak,
            fireAnimation: _fireAnimation,
            headerStyle: _headerStyle,
          ),
          ExpHabitList(
            todayHabitsList: db.todayHabitsList,
            checkBoxTapped: checkBoxTapped,
            deleteHabit: deleteHabit,
            openHabitSettings: openHabitSettings,
          ),
        ],
      ),
    );
  }
}
