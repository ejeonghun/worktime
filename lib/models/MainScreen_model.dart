class MainScreenModel {
  final UserInfo userInfo;
  final UserStatus userStatus;
  final List<Department> departments;

  MainScreenModel({
    required this.userInfo,
    required this.userStatus,
    required this.departments,
  });

  factory MainScreenModel.fromJson(Map<String, dynamic> json) {
    return MainScreenModel(
      userInfo: UserInfo.fromJson(json['userInfo']),
      userStatus: UserStatus.fromJson(json['userStatus']),
      departments: (json['departments'] as List)
          .map((e) => Department.fromJson(e))
          .toList(),
    );
  }
}

class UserInfo {
  final String department;
  final String name;
  final String status;
  final int check;

  UserInfo({
    required this.department,
    required this.name,
    required this.status,
    required this.check,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      department: json['department'],
      name: json['name'],
      status: json['status'],
      check: json['check'],
    );
  }
}

class UserStatus {
  final String checkTime;

  UserStatus({
    required this.checkTime,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(
      checkTime: json['checkTime'],
    );
  }
}

class Department {
  final String team;
  final String teamCount;
  final List<Employee> employeeList;

  Department({
    required this.team,
    required this.teamCount,
    required this.employeeList,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      team: json['team'],
      teamCount: json['teamCount'],
      employeeList: (json['employeeList'] as List)
          .map((e) => Employee.fromJson(e))
          .toList(),
    );
  }
}

class Employee {
  final String department;
  final String name;
  final String status;

  Employee({
    required this.department,
    required this.name,
    required this.status,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      department: json['department'],
      name: json['name'],
      status: json['status'],
    );
  }
}