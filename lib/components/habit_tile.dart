import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? onSettings;
  final Function(BuildContext)? onDelete;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    this.onSettings,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final habitTextStyle = GoogleFonts.montserratAlternates(
      fontSize: 15,
      decoration:
          habitCompleted ? TextDecoration.lineThrough : TextDecoration.none,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: onSettings,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: onDelete,
              backgroundColor: Colors.red.shade400,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: habitCompleted ? Colors.grey[300] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Checkbox(value: habitCompleted, onChanged: onChanged),
              Expanded(
                child: Text(
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  habitName,
                  style: habitTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
