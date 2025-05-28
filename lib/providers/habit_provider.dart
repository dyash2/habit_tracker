import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitProvider with ChangeNotifier {
  final List<Habit> _habits = [];

  List<Habit> get habits {
    //sorts the habits in descending order 
    _habits.sort((a, b) => b.streak.compareTo(a.streak));
    return _habits;
  }

 
  void addHabit(String name) {
    _habits.add(Habit(name: name));
    notifyListeners();
  }

  void deleteHabit(Habit habit) {
    _habits.remove(habit);
    notifyListeners();
  }

  void markCompleted(Habit habit) {
    final now = DateTime.now();
    if (habit.lastCompleted == null || !isSameDay(habit.lastCompleted!, now)) {
      if (habit.lastCompleted != null &&
          !isSameDay(habit.lastCompleted!, now.subtract(Duration(days: 1)))) {
        habit.streak = 0;
      }
      habit.streak++;
      habit.lastCompleted = now;
      notifyListeners();
    }
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
