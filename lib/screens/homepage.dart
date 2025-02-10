import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do_task/data/database.dart';
import 'package:to_do_task/models/task.dart';
import 'package:to_do_task/screens/add_edit_page.dart';

import '../widgets/task_card.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> tasks = [];

  
  @override
  void initState() {
    loadTask();
    super.initState();
  
  }

  void loadTask()async{
    tasks= await TaskDatabase.loadData();
    setState(() {
      
    });
  }

  void _addOrEditTask({Task? task, int? index}) async {
    
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(task: task),
      ),
    );

    if (result != null && result is Task) {
      if (index != null) {
          tasks[index] = result;
        } else {
          tasks.add(result);
        }
        TaskDatabase.updateDataBase(tasks);
      setState(() {
        
      });
    }
  }

  void _deleteTask(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              
              tasks.removeAt(index);
              TaskDatabase.updateDataBase(tasks);
              setState(() {
                              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title:
            const Text('Task Manager', style: TextStyle(color: Colors.white)),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks available.'))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCardWidget(
                    task: task,
                    index: index,
                    onAddOrEditTask: _addOrEditTask,
                    onDeleteTask: _deleteTask,
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditTask(),
        child: Icon(Icons.add),
      ),
);
}
}