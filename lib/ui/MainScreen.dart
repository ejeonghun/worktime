import 'package:flutter/material.dart';
import 'package:worktime/component/EmployeeItem.dart';
import 'package:worktime/ui/SettingsScreen.dart';

class MainScreen extends StatelessWidget {
  // 서버에서 받아올 데이터 예시
  final Map<String, dynamic> data = {
    "userInfo": {"department": "시스템개발부", "name": "홍길동", "status": "출근"},
    "userStatus": {"time": "09:01", "remainingTime": "08:59"},
    "departments": [
      {
        "team": "시스템개발부",
        "teamCount": "28/30",
        "employeeList": [
          {"department": "시스템개발부", "name": "김철수", "status": "근무중"},
          {"department": "시스템개발부", "name": "이영희", "status": "근무중"},
          {"department": "시스템개발부", "name": "정수민", "status": "휴가"},
          {"department": "시스템개발부", "name": "강민수", "status": "미출근"},
        ]
      },
      {
        "team": "인사팀",
        "teamCount": "28/30",
        "employeeList": [
          {"department": "인사팀", "name": "김철수", "status": "근무중"},
          {"department": "인사팀", "name": "이영희", "status": "근무중"},
          {"department": "인사팀", "name": "정수민", "status": "휴가"},
          {"department": "인사팀", "name": "강민수", "status": "미출근"},
        ]
      },
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    title: const Text('회사 이름'),
    actions: [
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          // 설정 화면으로 이동하는 로직
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
        },
      ),
    ],
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
      body: Column(
        children: [
          UserInfoWidget(userInfo: data['userInfo']),
          Expanded(
            child: ListView.builder(
              itemCount: data['departments'].length,
              itemBuilder: (context, index) {
                return DepartmentSection(
                  departmentData: data['departments'][index],
                );
              },
            ),
          ),
          if (data['userStatus'] != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('출근 : ${data['userStatus']['time']}'),
                Text('남은 시간 : ${data['userStatus']['remainingTime']}'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '일정'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: '공지사항'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보')
        ],
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  final Map<String, dynamic> userInfo;

  const UserInfoWidget({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[200],
      child: EmployeeListItem(
        department: userInfo['department'],
        name: userInfo['name'],
        status: userInfo['status'],
      ),
    );
  }
}

class DepartmentSection extends StatelessWidget {
  final Map<String, dynamic> departmentData;

  const DepartmentSection({Key? key, required this.departmentData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(departmentData['team'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(departmentData['teamCount'], style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
        ...departmentData['employeeList'].map<Widget>((employee) => 
          EmployeeListItem(
            department: employee['department'],
            name: employee['name'],
            status: employee['status'],
          )
        ).toList(),
      ],
    );
  }
}

