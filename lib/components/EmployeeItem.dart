import 'package:flutter/material.dart';

class EmployeeListItem extends StatelessWidget {
  final String memberName;
  final String position;
  final String workType;
  
  const EmployeeListItem({
    Key? key,
    required this.memberName,
    required this.position,
    required this.workType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(memberName),
      subtitle: Text(position),
      trailing: Text(
        workType == 'NOT_CHECK_IN' ? '미출근' : '출근',
        style: TextStyle(
          color: workType == 'NOT_CHECK_IN' ? Colors.red : Colors.green,
        ),
      ),
    );
  }
} 