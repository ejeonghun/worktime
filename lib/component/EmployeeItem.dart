import 'package:flutter/material.dart';

class EmployeeListItem extends StatelessWidget {
  final String department;
  final String name;
  final String status;

  const EmployeeListItem({
    Key? key,
    required this.department,
    required this.name,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(child: Text(name[0]), backgroundColor: Colors.grey[300]),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(department),
                Text(name),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(status),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(status, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '출근': return Colors.green;
      case '근무중': return Colors.blue;
      case '휴가': return Colors.grey;
      case '미출근': return Colors.red;
      default: return Colors.grey;
    }
  }
}