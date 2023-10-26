import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsi_flutter/models/task_model.dart';
import 'package:responsi_flutter/screen/add_task.dart';
import 'package:responsi_flutter/service/api_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Task> _taskList = [];

  @override
  void initState() {
    super.initState();
    _getAllData();
  }

  Future _getAllData() async {
    final result = await APIService.getAll();
    final List<dynamic> body = jsonDecode(result.body)['result'];
    final List<Task> data = body.map((task) {
      return Task.fromJson(task);
    }).toList();
    setState(() {
      _taskList = data;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute != null && modalRoute.isCurrent) {
      _getAllData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Task Manager", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _getAllData();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _taskList.isNotEmpty
                        ? Text(
                            'All tasks',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          )
                        : null),
                Expanded(
                  child: _taskList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.inbox_outlined,
                                size: 60,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Item Empty',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _taskList.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Container();
                            } else {
                              final task = _taskList[index - 1];
                              return taskCard(
                                id: task.id,
                                title: task.title,
                                description: task.description,
                                deadline: task.deadline,
                              );
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => const AddTask()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget taskCard({
    required int id,
    required String title,
    required String description,
    required String deadline,
  }) {
    Widget _deleteDialog(BuildContext context, int id, Function closeModal) {
      return AlertDialog(
        title: const Text('Yakin ingin menghapus item ini?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await APIService.delete(id);
              Navigator.of(context).pop();
              closeModal();
              _getAllData();
            },
            child: const Text('Hapus'),
          ),
        ],
      );
    }

    void _showModal(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => AddTask(
                                  id: id,
                                  title: title,
                                  description: description,
                                  deadline: deadline,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _deleteDialog(context, id, () {
                                  Navigator.of(context).pop();
                                });
                              },
                            );
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  deadline,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Text(
                  description,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
        },
      );
    }

    return InkWell(
      onTap: () => _showModal(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(title), Text(deadline)],
            ),
            Text(description)
          ],
        ),
      ),
    );
  }
}
