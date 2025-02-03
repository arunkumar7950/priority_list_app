import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const PriorityListApp());
}

class PriorityListApp extends StatelessWidget {
  const PriorityListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Priority List',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black87,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.tealAccent,
        ),
        cardColor: Colors.grey[850],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

// Dashboard to introduce users to the app
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Priority List")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.checklist, size: 80, color: Colors.white),
            const SizedBox(height: 15),
            const Text(
              "Stay Organized, Stay Focused",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaskScreen()),
                );
              },
              child: const Text(
                "Start Managing Tasks",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Main Task Management Screen
class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<Map<String, dynamic>> _taskList = [];
  final TextEditingController _taskInputController = TextEditingController();
  String _priorityLevel = "Medium";
  DateTime? _dueDate;

  void _createTask() {
    if (_taskInputController.text.isNotEmpty && _dueDate != null) {
      setState(() {
        _taskList.add({
          'taskName': _taskInputController.text,
          'priority': _priorityLevel,
          'dueDate': _dueDate,
          'isDone': false,
        });
        _taskInputController.clear();
        _priorityLevel = "Medium";
        _dueDate = null;
      });
      Navigator.pop(context);
    }
  }

  void _toggleTaskStatus(int index) {
    setState(() {
      _taskList[index]['isDone'] = !_taskList[index]['isDone'];
    });
  }

  void _removeTask(int index) {
    setState(() {
      _taskList.removeAt(index);
    });
  }

  Future<void> _pickDueDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _dueDate = selectedDate;
      });
    }
  }

  void _showTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: const Text("Add Task", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskInputController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Task Name",
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _priorityLevel,
                dropdownColor: Colors.grey[850],
                items: ["High", "Medium", "Low"]
                    .map((priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(priority, style: const TextStyle(color: Colors.white)),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _priorityLevel = value!;
                  });
                },
                decoration: const InputDecoration(labelText: "Priority"),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    _dueDate == null
                        ? "No Due Date"
                        : "Due: ${DateFormat('dd/MM/yyyy').format(_dueDate!)}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    onPressed: () => _pickDueDate(context),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: _createTask,
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Tasks")),
      body: ListView.builder(
        itemCount: _taskList.length,
        itemBuilder: (context, index) {
          final task = _taskList[index];
          return Card(
            color: Colors.grey[850],
            child: ListTile(
              leading: Checkbox(
                value: task['isDone'],
                onChanged: (_) => _toggleTaskStatus(index),
              ),
              title: Text(
                task['taskName'],
                style: TextStyle(
                  color: Colors.white,
                  decoration: task['isDone']
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text(
                "Priority: ${task['priority']} | Due: ${DateFormat('dd/MM/yyyy').format(task['dueDate'])}",
                style: TextStyle(
                  color: task['priority'] == "High"
                      ? Colors.red
                      : task['priority'] == "Medium"
                      ? Colors.orange
                      : Colors.green,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeTask(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
