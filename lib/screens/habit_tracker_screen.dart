import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import '../widgets/add_habit_dialog.dart';

class HabitTrackerScreen extends StatelessWidget {
  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = context.watch<HabitProvider>().habits;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Habit Tracker',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child:
            habits.isEmpty
                ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        'assets/lottie/nothing.json',
                        width: 200,
                        height: 200,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No Habits yet!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                )
                : GridView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: habits.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder:
                      (context, index) => HabitCard(habit: habits[index]),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.deepPurpleAccent,

        onPressed:
            () =>
                showDialog(context: context, builder: (_) => AddHabitDialog()),
        tooltip: 'Add Habit',
        child: Icon(Icons.add),
      ),
    );
  }
}
