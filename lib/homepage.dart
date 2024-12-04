import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Box _todoBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  void _openBox() async {
    _todoBox = await Hive.openBox('todoBox');
    setState(() {});
  }

  void _addTask(String task) {
    if (task.isNotEmpty) {
      _todoBox.add(task);
      setState(() {});
    }
  }

  void _deleteTask(int index) {
    _todoBox.deleteAt(index);
    setState(() {});
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController taskController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add a New Task'),
            content: TextField(
              controller: taskController,
              decoration: const InputDecoration(hintText: 'Enter Task'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _addTask(taskController.text);
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }
  // Build the main UI with a custom button and task tiles
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: _todoBox.isOpen
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _todoBox.length,
                    itemBuilder: (context, index) {
                      final task = _todoBox.getAt(index);
                      return TaskTile(
                        task: task,
                        onDelete: () => _deleteTask(index),
                      );
                    },
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: CustomButton(
        onPressed: () => _showAddTaskDialog(context),
        label: 'Add Task',
      ),
    );
  }
}

// Custom Button Widget
class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const CustomButton({super.key, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: label,
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add),
    );
  }
}

// Custom Task Tile Widget
class TaskTile extends StatelessWidget {
  final String task;
  final VoidCallback onDelete;

  const TaskTile({super.key, required this.task, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16.0),
      title: Text(task),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
      tileColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () {
        // You can implement task editing functionality here if needed
      },
    );
  }
}



