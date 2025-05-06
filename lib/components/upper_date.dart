import 'package:flutter/material.dart';

class TodayDateDisplay extends StatelessWidget {
  final TextStyle headerStyle;

  const TodayDateDisplay({super.key, required this.headerStyle});

  String getFormattedTodayDate() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')} "
        "${_monthName(now.month)} "
        "${now.year}";
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Text(
        getFormattedTodayDate(),
        style: headerStyle.copyWith(
          fontSize: 22,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}
