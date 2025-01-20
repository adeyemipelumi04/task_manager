import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_task/models/task.dart';
import 'package:to_do_task/screens/homepage.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({this.task});

  @override
  // ignore: library_private_types_in_public_api
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  //final String Function(DateTime) _formatDateTime;

  DateTime? _startTime;
  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task?.name ?? '');
    _startTime = widget.task?.startTime;
    _endTime = widget.task?.endTime;
  }

  void _pickDateTime(bool isStart) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (time != null) {
        final dateTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        setState(() {
          if (isStart) {
            _startTime = dateTime;
          } else {
            _endTime = dateTime;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Task Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () => _pickDateTime(true),
                          child: Text(_startTime == null
                              ? 'Pick Start Time'
                              : 'Start: ${_startTime!}'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () => _pickDateTime(false),
                          child: Text(_endTime == null
                              ? 'Pick End Time'
                              : 'End: $_endTime'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _startTime != null &&
                      _endTime != null) {
                    Navigator.pop(
                      context,
                      Task(
                        name: _nameController.text,
                        startTime: _startTime!,
                        endTime: _endTime!,
                      ),
                    );
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
