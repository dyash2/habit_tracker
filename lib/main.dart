import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: const MyApp(),
    ),
  );
}

class Habit {
  String name;
  int streak;
  DateTime lastCompleted;

  Habit({required this.name, this.streak = 0, required this.lastCompleted});
}

class HabitProvider extends ChangeNotifier {
  final List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  void addHabit(String name) {
    _habits.add(Habit(name: name, lastCompleted: DateTime.now()));
    notifyListeners();
  }

  void incrementStreak(int index) {
    _habits[index].streak++;
    _habits[index].lastCompleted = DateTime.now();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  void _showAddHabitDialog(BuildContext context) {
    TextEditingController habitController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Habit"),
          content: TextField(
            controller: habitController,
            decoration: const InputDecoration(hintText: "Enter habit name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (habitController.text.isNotEmpty) {
                  Provider.of<HabitProvider>(context, listen: false)
                      .addHabit(habitController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Habit Tracker",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.orange,
            Colors.lightBlueAccent
          ],begin:Alignment.topCenter,end:Alignment.bottomCenter)
        ),
        child: Consumer<HabitProvider>(
          builder: (context, habitProvider, child) {
            return ListView.builder(
              itemCount: habitProvider.habits.length,
              itemBuilder: (context, index) {
                final habit = habitProvider.habits[index];
                return Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    title: Text(habit.name),
                    subtitle: Text("Streak: ${habit.streak}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () => habitProvider.incrementStreak(index),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(context),
        tooltip: 'Add Habit',
        child: const Icon(Icons.add),
      ),
    );
  }
}