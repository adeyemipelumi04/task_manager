import 'package:hive/hive.dart';
part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
   @HiveField(0)
  final String name;

   @HiveField(1)
  final DateTime startTime;

    @HiveField(2)
  final DateTime endTime;

  Task({
    required this.name,
    required this.startTime,
    required this.endTime, 
  });
}

