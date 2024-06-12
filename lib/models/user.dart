import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String username;
  final String email;

  User({required this.username, required this.email}) : id = const Uuid().v4();
}
