import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/network/network.dart';
import 'package:habitsmasher/screens/habit_list_view.dart';
import 'package:habitsmasher/screens/test_widget.dart';
import 'package:habitsmasher/screens/today_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// Bug List:

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const HabitSmasherApp());
}

class HabitSmasherApp extends StatelessWidget {
  const HabitSmasherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const Navigation(),
    );
  }
}

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;
  List<Habit> habits = [];
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getHabits().then((list) {
      setState(() {
        habits = list;
      });
    });
  }

  void addHabit(Habit habit) {
    setState(() {
      habits.add(habit);
    });
    db.collection('habits').add(habit.toMap());
  }

  void editHabit(Habit newHabit, Habit oldHabit) {
    setState(() {
      db
          .collection('habits')
          .where('id', isEqualTo: oldHabit.id)
          .get()
          .then((QuerySnapshot querySnapshot) {
        db
            .collection('habits')
            .doc(querySnapshot.docs[0].id)
            .update(newHabit.toMap())
            .then((doc) => debugPrint('updated habit with id ${oldHabit.id}'),
                onError: (error) =>
                    debugPrint('error updating habit with id ${oldHabit.id}'));
      });
      habits[habits.indexOf(oldHabit)] = newHabit;
    });
  }

  void deleteHabit(Habit oldHabit) {
    setState(() {
      // Can potentially save a query by storing the document id in the habit object
      // or by querying the cache instead of the server
      int index = habits.indexOf(oldHabit);
      db
          .collection('habits')
          .where('id', isEqualTo: habits[index].id)
          .get()
          .then((QuerySnapshot querySnapshot) {
        db.collection('habits').doc(querySnapshot.docs[0].id).delete().then(
            (doc) => debugPrint('deleted habit with id ${habits[index].id}'),
            onError: (error) =>
                debugPrint('error deleting habit with id ${habits[index].id}'));

        // querySnapshot.docs[0].reference.delete().then(
        //     (doc) => print('deleted habit with id ${widget.habits[index].id}'),
        //     onError: (error) => print(
        //         'error deleting habit with id ${widget.habits[index].id}'));
      });

      habits.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month_outlined),
            icon: Icon(Icons.home_outlined),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_outlined),
            label: 'Habits',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        /// Today page
        TodayView(
            habits: habits, editHabit: editHabit, deleteHabit: deleteHabit),

        /// Habits page
        HabitListView(
            habits: habits,
            addHabit: addHabit,
            editHabit: editHabit,
            deleteHabit: deleteHabit),

        /// Profile page
        const HomePage()
      ][currentPageIndex],
    );
  }
}
