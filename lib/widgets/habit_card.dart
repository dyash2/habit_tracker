import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import 'package:intl/intl.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  bool _isCompletedToday(DateTime? lastCompleted) {
    if (lastCompleted == null) return false;
    final now = DateTime.now();
    return lastCompleted.year == now.year &&
        lastCompleted.month == now.month &&
        lastCompleted.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final isCompletedToday = _isCompletedToday(habit.lastCompleted);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // streaks circle in the middle
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepPurple.shade50,
              border: Border.all(color: Colors.deepPurple, width: 2),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (habit.streak == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Icon(
                      Icons
                          .sentiment_very_dissatisfied,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                if (habit.streak != 0)
                  Text(
                    '${habit.streak}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.deepPurple,
                    ),
                  ),
                Text(
                  'days',
                  style: TextStyle(fontSize: 10, color: Colors.deepPurple),
                ),
              ],
            ),
          ),

          //habit names
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              habit.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          //last completed
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              habit.lastCompleted != null
                  ? DateFormat.yMMMd().format(habit.lastCompleted!)
                  : 'Not completed yet',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          //complete buttons
          ElevatedButton.icon(
            onPressed:
                isCompletedToday
                    ? null
                    : () {
                      context.read<HabitProvider>().markCompleted(habit);
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isCompletedToday ? Colors.grey : Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            icon: Icon(
              isCompletedToday ? Icons.check_circle : Icons.check,
              color: Colors.white,
            ),
            label: Text(
              isCompletedToday ? 'Completed' : 'Mark Complete',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),

          //delete buttons
          ElevatedButton.icon(
            onPressed: () {
              context.read<HabitProvider>().deleteHabit(habit);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            icon: Icon(Icons.delete, color: Colors.white),
            label: Text(
              'Delete Habit',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
