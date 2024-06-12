import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/network/network.dart';
import 'package:habitsmasher/screens/habit_list_view.dart';
import 'package:habitsmasher/screens/login_view.dart';
import 'package:habitsmasher/screens/test_widget.dart';
import 'package:habitsmasher/screens/today_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habitsmasher/theme.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Bug List:
/// Sort event button works but only after second press
/// delete button doesnt work in today view
/// refactor making habits to use the ID from the db instead of the random one
/// editing an event with a picture without replacing it causes the picture link to be lost
/// Strength gauge shows NaN/infinity when there are no events
///
/// TO ADD:
/// - Colour indicator to strength gauge (green yellow red)
///

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: HabitSmasherApp()));
}

// ignore: must_be_immutable
class HabitSmasherApp extends StatelessWidget {
  HabitSmasherApp({super.key});
  bool loggedIn = FirebaseAuth.instance.currentUser != null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: theme, home: loggedIn ? Navigation() : const LoginView());
  }
}

// kinda hacky but it works
// could probably fix this by putting the list methods in the main class
// ignore: must_be_immutable
class Navigation extends StatefulWidget {
  Navigation({super.key});
  List<Habit> habits = [];
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  void addHabit(Habit habit) {
    setState(() {
      widget.habits.add(habit);
    });
    db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('habits')
        .add(habit.toMap());
  }

  void editHabit(Habit newHabit, Habit oldHabit) {
    setState(() {
      db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection('habits')
          .where('id', isEqualTo: oldHabit.id)
          .get()
          .then((QuerySnapshot querySnapshot) {
        db
            .collection("users")
            .doc(auth.currentUser!.uid)
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
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection('habits')
          .where('id', isEqualTo: widget.habits[index].id)
          .get()
          .then((QuerySnapshot querySnapshot) {
        db
            .collection("users")
            .doc(auth.currentUser!.uid)
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
      body: FutureBuilder(
        future: getHabits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            widget.habits = snapshot.data as List<Habit>;
            return <Widget>[
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
            ][currentPageIndex];
          } else {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            );
          }
        },
      ),
    );
  }
}
