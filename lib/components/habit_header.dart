import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HabitHeader extends StatelessWidget {
  final int currentStreak;
  final LottieComposition? fireAnimation;
  final TextStyle headerStyle;
  const HabitHeader({
    super.key,
    required this.currentStreak,
    required this.fireAnimation,
    required this.headerStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Text('Habit Tracker', style: headerStyle),
          if (currentStreak > 0 && fireAnimation != null)
            Lottie(
              composition: fireAnimation,
              width: 60,
              height: 60,
              frameRate: FrameRate(20),
              repeat: false,
              animate: true,
            ),
          if (currentStreak > 0)
            Text(
              currentStreak.toString(),
              style: headerStyle.copyWith(
                color: const Color.fromARGB(255, 247, 152, 51),
              ),
            ),
        ],
      ),
    );
  }
}
