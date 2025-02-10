import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class TaskCardWidget extends StatefulWidget {
  final Task task;
  final int index;
  final Function({Task? task, int? index}) onAddOrEditTask;
  final Function(int index) onDeleteTask;

  const TaskCardWidget({
    super.key,
    required this.task,
    required this.index,
    required this.onAddOrEditTask,
    required this.onDeleteTask,
  });

  @override
  State<TaskCardWidget> createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> {
  Duration? _timeRemaining;
  Timer? _timer;

  @override
  void initState() {
    _calculateTimeRemaining();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _calculateTimeRemaining() {
    _timeRemaining = widget.task.endTime.difference(widget.task.startTime);

    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timeRemaining!.inSeconds > 0) {
        _timeRemaining = _timeRemaining! - const Duration(seconds: 1);
      } else {
        _timeRemaining = Duration.zero;
        _timer!.cancel();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.task.name),
        subtitle: Column(
          children: [
            Text(
              'Start: ${DateFormat('yyyy-MM-dd hh:mma').format(widget.task.startTime)}',
            ),
            Text(
              'End: ${DateFormat('yyyy-MM-dd hh:mma').format(widget.task.endTime)}',
            ),
            Text(
              'Time remaining: ${_timeRemaining?.inHours ?? 0} hours ${_timeRemaining?.inMinutes.remainder(60) ?? 0} minutes ${_timeRemaining?.inSeconds.remainder(60) ?? 0} seconds',
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => widget.onAddOrEditTask(
                task: widget.task,
                index: widget.index,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => widget.onDeleteTask(widget.index),
            ),
          ],
        ),
      ),
    );
  }
}
