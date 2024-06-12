import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/screens/add_edit_habit_view.dart';
import 'package:habitsmasher/screens/habit_card_view.dart';
import 'package:habitsmasher/screens/habit_detail_view.dart';
import 'package:habitsmasher/extensions.dart';
import 'package:habitsmasher/theme.dart';

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
          title: Text('Habit List', style: theme.appBarTheme.titleTextStyle),
          centerTitle: false,
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 20),
              icon: const Icon(Icons.add),
              style: ButtonStyle(
                  iconSize: WidgetStateProperty.all(40),
                  iconColor: WidgetStateProperty.all(Colors.black)),
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
  return Padding(
    padding: const EdgeInsets.only(top: 12.0),
    child: Center(
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
                  endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: 0.5,
                      openThreshold: 0.2,
                      closeThreshold: 0.8,
                      children: <Widget>[
                        SlidableAction(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            label: 'Edit',
                            backgroundColor: Colors.blue,
                            icon: Icons.edit,
                            onPressed: (context) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddEditHabitView(
                                            operation: Operation.edit,
                                            index: index,
                                            habit: habits[index],
                                            editHabit: editHabit,
                                          )));
                            }),
                        SlidableAction(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          label: 'Delete',
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          onPressed: (context) {
                            deleteHabit(habits[index]);
                            habits.removeAt(index);
                          },
                        )
                      ]),
                  child: HabitCardView(habit: habits[index]),
                ));
          }),
    ),
  );
}
