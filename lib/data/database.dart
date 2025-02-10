import 'package:hive/hive.dart';
import 'package:to_do_task/models/task.dart';

class TaskDatabase {
  static Future<List<Task>> loadData() async {
    var taskbox = await Hive.openBox("Taskbox");
    var tasks = await taskbox.get("task", defaultValue: <Task>[]);
    List<Task> taskList = tasks.cast<Task>();
    return taskList;
  }

  static void updateDataBase(List<Task> tasks) async {
    var taskbox = await Hive.openBox("Taskbox");
    taskbox.put("task", tasks);
  }
}
