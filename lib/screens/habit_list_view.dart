import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/screens/add_edit_habit_view.dart';
import 'package:habitsmasher/screens/habit_card_view.dart';
import 'package:habitsmasher/screens/habit_detail_view.dart';
import 'package:habitsmasher/extensions.dart';

class HabitListView extends StatefulWidget {
  final List<Habit> habits;
  final Function addHabit;
  final Function editHabit;
  final Function deleteHabit;

  const HabitListView(
      {super.key,
      required this.habits,
      required this.addHabit,
      required this.editHabit,
      required this.deleteHabit});

  @override
  State<HabitListView> createState() => _HabitListViewState();
}

class _HabitListViewState extends State<HabitListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Habit List'),
          centerTitle: false,
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 20),
              icon: const Icon(Icons.add),
              style: ButtonStyle(iconSize: MaterialStateProperty.all(40)),
              onPressed: () {
                // Add a new habit
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEditHabitView(
                            operation: Operation.add,
                            addHabit: widget.addHabit)));
              },
            ),
          ],
        ),
        body: habitCards(
            habits: widget.habits,
            editHabit: widget.editHabit,
            deleteHabit: widget.deleteHabit));
  }
}

// This is the widget that will be displayed in the list view
Widget habitCards(
    {required List<Habit> habits,
    required Function editHabit,
    required Function deleteHabit}) {
  return Center(
    child: ListView.builder(
        padding: const EdgeInsets.only(
            left: 10, right: 10, bottom: kBottomNavigationBarHeight + 70),
        itemCount: habits.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HabitDetailView(habit: habits[index])));
              },
              child: Slidable(
                actionPane: const SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Edit',
                    color: Colors.blue,
                    icon: Icons.edit,
                    onTap: () {
                      // Edit the habit
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddEditHabitView(
                                    operation: Operation.edit,
                                    index: index,
                                    habit: habits[index],
                                    editHabit: editHabit,
                                  )));
                    },
                  ),
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      // Delete the habit
                      deleteHabit(habits[index]);
                      habits.removeAt(index);
                    },
                  ),
                ],
                child: HabitCardView(habit: habits[index]),
              ));
        }),
  );
}
