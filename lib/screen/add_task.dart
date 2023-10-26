import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:intl/intl.dart';
import 'package:responsi_flutter/models/task_model.dart';
import 'package:responsi_flutter/service/api_service.dart';

class AddTask extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String deadline;
  const AddTask(
      {super.key, this.title = '', this.description = '', this.deadline = '', this.id = 0});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final deadlineController = TextEditingController();
  bool isUpdate = false;
  @override
  void initState() {
    super.initState();
    if (widget.id != 0) {
      isUpdate = true;
    }
    titleController.text = widget.title;
    descriptionController.text = widget.description;
    deadlineController.text = widget.deadline;
  }

  void addNewTask() async {
    final String title = titleController.text;
    final String description = descriptionController.text;
    final String deadline = deadlineController.text;
    final Task taskBaru = Task(
      DateTime.now().millisecondsSinceEpoch,
      DateTime.now().toString(),
      DateTime.now().toString(),
      title: title,
      description: description,
      deadline: deadline,
    );
    Response response;
    if (isUpdate) {
      response = await APIService.update(widget.id, taskBaru);
      String message = jsonDecode(response.body)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      response = await APIService.create(taskBaru);
      String message = jsonDecode(response.body)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }
    if (jsonDecode(response.body)['code'] == 200) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      deadlineController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.title.isNotEmpty ? "Edit task" : 'Add new task',
        style: const TextStyle(fontWeight: FontWeight.bold),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: deadlineController,
              decoration: const InputDecoration(labelText: 'Deadline'),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: addNewTask,
                  child: Text(isUpdate ? 'Edit Task' : 'Add Task'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
