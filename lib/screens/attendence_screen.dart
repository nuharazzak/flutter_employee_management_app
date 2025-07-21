import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

class AttendenceScreen extends StatefulWidget {
  const AttendenceScreen({super.key});

  @override
  State<AttendenceScreen> createState() => _AttendenceScreenState();
}

class _AttendenceScreenState extends State<AttendenceScreen> {
  List<Map<String, String>> attendanceHistory = [];
  final TextEditingController _nameController = TextEditingController();
  DateTime? _checkInTime;
  String? _checkedInName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAttendanceHistory();
  }

  Future<void> _loadAttendanceHistory() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('attendanceHistory');
    if (data != null) {
      final List decoded = jsonDecode(data);
      setState(() {
        attendanceHistory = decoded
            .cast<Map<String, dynamic>>()
            .map((e) => e.map((k, v) => MapEntry(k, v.toString())))
            .toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveAttendanceHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('attendanceHistory', jsonEncode(attendanceHistory));
  }

  void _addAttendanceRecord(Map<String, String> record) {
    setState(() {
      attendanceHistory.add(record);
    });
    _saveAttendanceHistory();
  }

  void _handleCheckIn() {
    FocusScope.of(context).unfocus();
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your name to check in.')),
      );
      return;
    }
    setState(() {
      _checkInTime = DateTime.now();
      _checkedInName = name;

      final date = DateFormat('MM/dd/yyyy').format(_checkInTime!);
      final day = DateFormat('EEEE').format(_checkInTime!);
      final checkInStr = DateFormat('HH:mm').format(_checkInTime!);

      _addAttendanceRecord({
        "name": name,
        "date": date,
        "day": day,
        "checkIn": checkInStr,
        "checkOut": "",
        "time_spent": "",
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Checked in at ${DateFormat('HH:mm').format(_checkInTime!)},',
        ),
      ),
    );
  }

  void _handleCheckOut() {
    FocusScope.of(context).unfocus();
    final name = _nameController.text.trim();
    if (_checkInTime == null || _checkedInName != name) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please check in first with the same name.')),
      );
      return;
    }
    final checkOutTime = DateTime.now();
    final duration = checkOutTime.difference(_checkInTime!);
    final date = DateFormat('MM/dd/yyyy').format(_checkInTime!);
    final day = DateFormat('EEEE').format(_checkInTime!);
    final checkInStr = DateFormat('HH:mm').format(_checkInTime!);
    final checkOutStr = DateFormat('HH:mm').format(checkOutTime);
    final timeSpent = '${duration.inHours}h ${(duration.inMinutes % 60)}m';

    // Find the existing record for this name and date
    final index = attendanceHistory.indexWhere(
      (rec) => rec['name'] == name && rec['date'] == date,
    );

    if (index != -1) {
      setState(() {
        attendanceHistory[index]['checkOut'] = checkOutStr;
        attendanceHistory[index]['time_spent'] = timeSpent;
      });
      _saveAttendanceHistory();
    } else {
      _addAttendanceRecord({
        "name": name,
        "date": date,
        "day": day,
        "checkIn": checkInStr,
        "checkOut": checkOutStr,
        "time_spent": timeSpent,
      });
    }

    setState(() {
      _checkInTime = null;
      _checkedInName = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checked out at $checkOutStr'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _clearAttendanceHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('attendanceHistory');
    setState(() {
      attendanceHistory.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All attendance history cleared!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentName = _nameController.text.trim();
    final today = DateFormat('MM/dd/yyyy').format(DateTime.now());
    final currentRecord = attendanceHistory.lastWhere(
      (rec) => rec['name'] == currentName && rec['date'] == today,
      orElse: () => {},
    );

    String summaryStatus;
    if (currentRecord.isNotEmpty) {
      final hasCheckIn = (currentRecord['checkIn']?.isNotEmpty ?? false);
      final hasCheckOut = (currentRecord['checkOut']?.isNotEmpty ?? false);
      if (hasCheckIn && hasCheckOut) {
        summaryStatus = "Present";
      } else if (hasCheckIn || hasCheckOut) {
        summaryStatus = "Incomplete";
      } else {
        summaryStatus = "Absent";
      }
    } else {
      summaryStatus = "-";
    }

    final incompleteHistory = attendanceHistory.where((record) {
      final hasCheckIn = (record['checkIn']?.isNotEmpty ?? false);
      final hasCheckOut = (record['checkOut']?.isNotEmpty ?? false);
      return (hasCheckIn || hasCheckOut) && !(hasCheckIn && hasCheckOut);
    }).toList();

    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Employee Name',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _handleCheckIn,
                    child: Text("Check In"),
                  ),
                  SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: _handleCheckOut,
                    child: Text("Check Out"),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text("Todays Summary...."),
              SizedBox(height: 8),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 222, 144, 201),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 222, 144, 201),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date: ${currentRecord['date'] ?? '-'}"),
                    Text("Day: ${currentRecord['day'] ?? '-'}"),
                    Text("Check-In: ${currentRecord['checkIn'] ?? '-'}"),
                    Text("Check-Out: ${currentRecord['checkOut'] ?? '-'}"),
                    Text("Time Spent: ${currentRecord['time_spent'] ?? '-'}"),
                    Text("Attendance Status: $summaryStatus"),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Attendance History',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                  ),
                  ElevatedButton(
                    onPressed: _clearAttendanceHistory,
                    child: Text("Refresh"),
                  ),
                ],
              ),

              SizedBox(height: 8),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: incompleteHistory.length,
                itemBuilder: (context, index) {
                  final record = incompleteHistory[index];
                  String status = "Incomplete";

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    elevation: 1,
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      leading: Icon(Icons.event_note, size: 24),
                      title: Text(
                        "${record['date'] ?? '-'} (${record['day'] ?? '-'})",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "In: ${record['checkIn'] ?? '-'}  Out: ${record['checkOut'] ?? '-'}",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "Status: $status  |  Time: ${record['time_spent'] ?? '-'}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: Text(
                        record['name'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
