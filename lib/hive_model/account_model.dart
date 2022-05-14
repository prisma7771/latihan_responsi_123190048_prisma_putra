import 'package:hive/hive.dart';
part 'account_model.g.dart';

@HiveType(typeId: 1)
class UserAccountModel {
  UserAccountModel({required this.username, required this.password, required this.history, required this.image});

  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  @HiveField(2)
  String? history;

  @HiveField(3)
  String? image;

  @override
  String toString() {
    return 'UserAccountModel{username: $username, password: $password, history: $history, image: $image}';
  }
}