import 'package:flutter/material.dart';
import 'package:flutter_employee_management_app/screens/model/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> _taskList = [];

  final TextEditingController _taskNameController = TextEditingController();
  DateTime? _dueDate;
  String? _priority;
  String? _status;
  bool _isLoading = false;
  String? _taskNameError;
  String? _priorityError;
  String? _statusError;

  String? _dueDateError;

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson = jsonEncode(
      _taskList.map((task) => task.toJson()).toList(),
    );
    await prefs.setString('tasks', taskListJson);
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final taskListString = prefs.getString('tasks');
    if (taskListString != null) {
      final List decoded = jsonDecode(taskListString);
      setState(() {
        _taskList = decoded.map((e) => Task.fromJson(e)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _clearTasksHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tasksHistory');
    setState(() {
      _taskList.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All tasks history cleared!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Task Name',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _taskNameController,
                        decoration: InputDecoration(
                          labelText: "Enter Task Name",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          errorText: _taskNameError,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _dueDate == null
                                  ? 'Due Date: Not set'
                                  : 'Due Date: ${_dueDate!.month}/${_dueDate!.day}/${_dueDate!.year}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _pickDueDate,
                            icon: Icon(Icons.calendar_today, size: 18),
                            label: Text('Pick Date'),
                          ),
                        ],
                      ),

                      if (_dueDateError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, top: 2.0),
                          child: Text(
                            _dueDateError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _priority,
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          errorText: _priorityError, // Add this for validation
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(
                              'Select Priority',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ...['Low', 'Medium', 'High'].map(
                            (level) => DropdownMenuItem(
                              value: level,
                              child: Text(level),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _priority = value;
                            _priorityError = null;
                          });
                        },
                      ),
                      SizedBox(height: 24),
                      DropdownButtonFormField<String>(
                        value: _status,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          errorText: _statusError, // Add this for validation
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(
                              'Select Status',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ...['Not Started', 'In Progress', 'Done'].map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _status = value;
                            _statusError = null;
                          });
                        },
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _dueDateError = null;
                            _taskNameError = null;
                          });
                          if (_taskNameController.text.trim().isEmpty) {
                            setState(() {
                              _taskNameError = 'Please enter a task name';
                            });
                            return;
                          }
                          if (_dueDate == null) {
                            setState(() {
                              _dueDateError = 'Please select a due date';
                            });
                            return;
                          }
                          if (_priority == null) {
                            setState(() {
                              _priorityError = 'Please select a priority';
                            });
                            return;
                          }
                          if (_status == null) {
                            setState(() {
                              _statusError = 'Please select a status';
                            });
                            return;
                          }
                          final newTask = Task(
                            name: _taskNameController.text.trim(),
                            dueDate: _dueDate!,
                            priority: _priority ?? '',
                            status: _status ?? '',
                          );
                          setState(() {
                            _taskList.add(newTask);
                            _taskNameController.clear();
                            _dueDate = null;
                            _priority = null;
                            _status = null;
                            _dueDateError = null;
                            _taskNameError = null;
                            _priorityError = null;
                            _statusError = null;
                          });
                          _saveTasks();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Task Saved!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text('Add Task'),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tasks List',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                  ),
                  ElevatedButton(
                    onPressed: _clearTasksHistory,
                    child: Text("Refresh"),
                  ),
                ],
              ),

              SizedBox(height: 24),
              _isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _taskList.length,
                      itemBuilder: (context, index) {
                        final task = _taskList[index];

                        // Priority color
                        Color priorityColor;
                        switch (task.priority) {
                          case 'High':
                            priorityColor = Colors.red;
                            break;
                          case 'Medium':
                            priorityColor = Colors.orange;
                            break;
                          default:
                            priorityColor = Colors.green;
                        }

                        // Status icon
                        IconData statusIcon;
                        Color statusColor;
                        switch (task.status) {
                          case 'Done':
                            statusIcon = Icons.check_circle;
                            statusColor = Colors.green;
                            break;
                          case 'In Progress':
                            statusIcon = Icons.autorenew;
                            statusColor = Colors.orange;
                            break;
                          default:
                            statusIcon = Icons.radio_button_unchecked;
                            statusColor = Colors.grey;
                        }

                        return Card(
                          margin: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 2,
                          ),
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                              task.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.blueGrey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Due Date: ${task.dueDate.month}/${task.dueDate.day}/${task.dueDate.year}',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.flag,
                                        size: 16,
                                        color: priorityColor,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Priority: ${task.priority}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: priorityColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        size: 16,
                                        color: statusColor,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Status: ${task.status}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: statusColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
