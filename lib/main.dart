import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/sample_data/sample_data.dart';
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
  runApp(const NavigationBarApp());
}

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  NavigationExample({super.key});
  final List<Habit> habits = sampleHabits;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.db.collection('habits').get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          widget.habits.add(Habit.fromMap(doc.data() as Map<String, dynamic>));
        });
      }
    });
  }

  void addHabit(Habit habit) {
    setState(() {
      widget.habits.add(habit);
    });
    widget.db.collection('habits').add(habit.toMap());
  }

  void editHabit(Habit newHabit, Habit oldHabit) {
    setState(() {
      widget.db
          .collection('habits')
          .where('id', isEqualTo: oldHabit.id)
          .get()
          .then((QuerySnapshot querySnapshot) {
        widget.db
            .collection('habits')
            .doc(querySnapshot.docs[0].id)
            .update(newHabit.toMap())
            .then((doc) => debugPrint('updated habit with id ${oldHabit.id}'),
                onError: (error) =>
                    debugPrint('error updating habit with id ${oldHabit.id}'));
      });
      widget.habits[widget.habits.indexOf(oldHabit)] = newHabit;
    });
  }

  void deleteHabit(Habit oldHabit) {
    setState(() {
      // Can potentially save a query by storing the document id in the habit object
      // or by querying the cache instead of the server
      int index = widget.habits.indexOf(oldHabit);
      widget.db
          .collection('habits')
          .where('id', isEqualTo: widget.habits[index].id)
          .get()
          .then((QuerySnapshot querySnapshot) {
        widget.db
            .collection('habits')
            .doc(querySnapshot.docs[0].id)
            .delete()
            .then(
                (doc) => debugPrint(
                    'deleted habit with id ${widget.habits[index].id}'),
                onError: (error) => debugPrint(
                    'error deleting habit with id ${widget.habits[index].id}'));

        // querySnapshot.docs[0].reference.delete().then(
        //     (doc) => print('deleted habit with id ${widget.habits[index].id}'),
        //     onError: (error) => print(
        //         'error deleting habit with id ${widget.habits[index].id}'));
      });

      widget.habits.removeAt(index);
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
            habits: widget.habits,
            editHabit: editHabit,
            deleteHabit: deleteHabit),

        /// Habits page
        HabitListView(
            habits: widget.habits,
            addHabit: addHabit,
            editHabit: editHabit,
            deleteHabit: deleteHabit),

        /// Profile page
        const HomePage()
      ][currentPageIndex],
    );
  }
}
