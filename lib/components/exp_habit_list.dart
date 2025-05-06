import 'package:flutter/material.dart';
import 'package:habbit_tracker/components/habit_tile.dart';

class ExpHabitList extends StatelessWidget {
  final List todayHabitsList;
  final Function(bool?, int) checkBoxTapped;
  final Function(int) deleteHabit;
  final Function(int) openHabitSettings;
  const ExpHabitList({
    super.key,
    required this.todayHabitsList,
    required this.checkBoxTapped,
    required this.deleteHabit,
    required this.openHabitSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: todayHabitsList.length,
        itemBuilder: (context, index) {
          return HabitTile(
            habitName: todayHabitsList[index][0],
            habitCompleted: todayHabitsList[index][1],
            onChanged: (value) => checkBoxTapped(value, index),
            onDelete: (context) => deleteHabit(index),
            onSettings: (context) => openHabitSettings(index),
          );
        },
      ),
    );
  }
}
