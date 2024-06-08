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
/// Sort event button works but only after second press
/// Location doesn't appear in event detail view after event deloads
///   - Location isn't being added in database upload
///   - Pictures will have the same issue when implemented fully
///   - UPDATE: Fix was to make a future.delayed in a while loop to wait for the location to be added
/// delete button doesnt work in today view

ThemeData theme = ThemeData(
  useMaterial3: true,
  primarySwatch: Colors.green,
  primaryColor: Colors.green[300],
  hintColor: Colors.green[300],
  scaffoldBackgroundColor: Colors.green[100],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.green[400],
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.green,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.green[100],
    selectedItemColor: Colors.green[400],
    unselectedItemColor: Colors.green[300],
  ),
  cardTheme: CardTheme(
    color: Colors.green[200],
    shadowColor: Colors.green[400],
    elevation: 10,
  ),
);

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
      theme: theme,
      home: FutureBuilder(
          future: getHabits(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Habit> habits = snapshot.data as List<Habit>;
              return Navigation(habits: habits);
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.green,
                semanticsLabel: 'Loading habits',
              ));
            }
          }),
    );
  }
}

// kinda hacky but it works
// could probably fix this by putting the list methods in the main class
// ignore: must_be_immutable
class Navigation extends StatefulWidget {
  Navigation({super.key, required this.habits});
  List<Habit> habits;
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getHabits().then((list) {
      setState(() {
        widget.habits = list;
      });
    });
  }

  void addHabit(Habit habit) {
    setState(() {
      widget.habits.add(habit);
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
      widget.habits[widget.habits.indexOf(oldHabit)] = newHabit;
    });
  }

  void deleteHabit(Habit oldHabit) {
    setState(() {
      // Can potentially save a query by storing the document id in the habit object
      // or by querying the cache instead of the server
      int index = widget.habits.indexOf(oldHabit);
      db
          .collection('habits')
          .where('id', isEqualTo: widget.habits[index].id)
          .get()
          .then((QuerySnapshot querySnapshot) {
        db.collection('habits').doc(querySnapshot.docs[0].id).delete().then(
            (doc) =>
                debugPrint('deleted habit with id ${widget.habits[index].id}'),
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
        backgroundColor: Colors.green[100],
        indicatorColor: Colors.green[400],
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
