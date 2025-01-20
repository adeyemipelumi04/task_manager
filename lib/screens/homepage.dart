import 'dart:async';

import 'package:flutter/material.dart';
import 'package:to_do_task/models/task.dart';
import 'package:to_do_task/screens/add_edit_page.dart';

class TaskPage extends StatefulWidget {
  // @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> tasks = [];

  void _addOrEditTask({Task? task, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(task: task),
      ),
    );

    if (result != null && result is Task) {
      setState(() {
        if (index != null) {
          tasks[index] = result;
        } else {
          tasks.add(result);
        }
      });
    }
  }

  void _deleteTask(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                tasks.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour % 12}:${dateTime.minute.toString().padLeft(2, '0')}'
        ' ${dateTime.hour >= 12 ? 'PM' : 'AM'}, '
        '${dateTime.day} ${_getMonthName(dateTime.month)}, ${dateTime.year}';
  }

  Timer? timer;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatRemainingTime(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    String result = '';
    if (days > 0) result += '$days day${days > 1 ? 's' : ''} ';
    if (hours > 0) result += '$hours hour${hours > 1 ? 's' : ''} ';
    if (minutes > 0) result += '$minutes minute${minutes > 1 ? 's' : ''} ';
    if (seconds > 0) result += '$seconds second${seconds > 1 ? 's' : ''}';

    return result.trim();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (remainingDuration > 0) {
          remainingDuration--;
        } else {
          timer.cancel();
        }
      }); // Rebuild the widget every second
    });
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
              child: TaskList(tasks: tasks),
            ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.tasks,
  });

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      final _remainingtime = remainingDuration;
      itemBuilder: (context, index) {
        final task = tasks[index];
        
        return Card(
          child: ListTile(
            title: Text(task.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            subtitle: Text(
                'Start: ${_formatDateTime(task.startTime)}\n End: ${_formatDateTime(task.endTime)}\nTask Expires in:$remainingDuration '),
            trailing: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _addOrEditTask(task: task, index: index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTask(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
