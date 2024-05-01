import 'dart:math';

import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/models/habit_event.dart';
import 'package:habitsmasher/models/user.dart';
import 'package:location/location.dart';

User user1 = User(username: 'user1', email: 'cameron@gmail.com');
User user2 = User(username: 'user2', email: 'matthew@gmail.com');

Future<LocationData> locationService() async {
  Location location = Location();
  await location.requestPermission();
  await location.requestService();
  LocationData place = await location.getLocation();
  return place;
}

Habit habit1 = Habit(
  name: 'Exercise',
  description: 'Run 5 miles',
  startDate: DateTime.now(),
  recurranceDays: [Days.monday, Days.wednesday, Days.friday],
);

Habit habit2 = Habit(
  name: 'Read',
  description: 'Read 50 pages',
  startDate: DateTime.now(),
  recurranceDays: [Days.tuesday, Days.thursday],
);

Habit habit3 = Habit(
  name: 'Meditate',
  description: 'Meditate for 10 minutes',
  startDate: DateTime.now(),
  recurranceDays: [Days.saturday, Days.sunday],
);

Habit habit4 = Habit(
  name: 'Drink Water',
  description: 'Drink 8 cups of water',
  startDate: DateTime.now(),
  recurranceDays: [
    Days.monday,
    Days.tuesday,
    Days.wednesday,
    Days.thursday,
    Days.friday,
    Days.saturday,
    Days.sunday
  ],
);

Future<List<HabitEvent>> makeSampleHabitEvents() async {
  List<HabitEvent> habitEvents = [];
  for (Habit habit in sampleHabits) {
    habitEvents.add(HabitEvent(
      habit: habit,
      date: DateTime.now()
          .subtract(Duration(days: Random.secure().nextInt(max(1, 10)))),
      comment: 'This is a sample habit event',
      //location: await locationService(),
    ));
  }

  return habitEvents;
}

Future<List<HabitEvent>> testNoEvents() async {
  List<HabitEvent> habitEvents = [];
  return habitEvents;
}

List<Habit> sampleHabits = [
  habit1,
  habit2,
  habit3,
  habit4,
  habit4,
  habit4,
  habit4,
  habit4,
  habit4,
  habit4,
  habit4,
];
