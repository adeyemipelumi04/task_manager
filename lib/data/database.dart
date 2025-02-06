
import 'package:hive/hive.dart';
import 'package:to_do_task/models/task.dart';

class TaskDatabase {


  static Future<List<Task>> loadData()async{
        var taskbox = await Hive.openBox("Taskbox");       
        var tasks = await taskbox.get("task", defaultValue: []as List<Task>) as List<Task>;
         print(tasks);
        return await taskbox.get("task", defaultValue: []as List<Task>) as List<Task>;

  }
  static void updateDataBase(List<Task> tasks )async{
    var taskbox = await Hive.openBox("Taskbox");
    taskbox.put("task", tasks);    
  }
}