import 'package:hive/hive.dart';

part 'data.g.dart'; // Required for code generation

@HiveType(typeId: 0) // Unique ID for this type
class MyUserData extends HiveObject {
  @HiveField(0)
  final String colors;

  @HiveField(1)
  final String model;

  MyUserData({required this.colors, required this.model});
}
