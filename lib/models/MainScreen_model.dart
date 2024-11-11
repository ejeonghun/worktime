enum WorkType {
  NOT_CHECK_IN,
  CHECK_IN,
  OVERTIME,
  CHECK_OUT,
  // 필요한 다른 상태들 추가
}

extension WorkTypeExtension on WorkType {
  String get displayName {
    switch (this) {
      case WorkType.NOT_CHECK_IN:
        return '미출근';
      case WorkType.CHECK_IN:
        return '근무중';
      case WorkType.OVERTIME:
        return '추가근로';
      case WorkType.CHECK_OUT:
        return '퇴근';
      default:
        return '알 수 없음';
    }
  }
}

class MainScreenModel {
  final bool success;
  final String resultCode;
  final String message;
  final MainScreenData data;

  MainScreenModel({
    required this.success,
    required this.resultCode,
    required this.message,
    required this.data,
  });

  factory MainScreenModel.fromJson(Map<String, dynamic> json) {
    return MainScreenModel(
      success: json['success'],
      resultCode: json['resultCode'],
      message: json['message'],
      data: MainScreenData.fromJson(json['data']),
    );
  }
}

class MainScreenData {
  final UserInfo userInfo;
  final List<Department> deptList;
  final String companyName;

  MainScreenData({
    required this.userInfo,
    required this.deptList,
    required this.companyName,
  });

  factory MainScreenData.fromJson(Map<String, dynamic> json) {
    return MainScreenData(
      userInfo: UserInfo.fromJson(json['userInfo']),
      deptList: (json['deptList'] as List)
          .map((e) => Department.fromJson(e))
          .toList(),
      companyName: json['companyInfo'].toString(),
    );
  }
}

class UserInfo {
  final int memberId;
  final String memberName;
  final String workType;
  final String position;
  final String? imagePath;
  final DateTime? startTime;

  UserInfo({
    required this.memberId,
    required this.memberName,
    required this.workType,
    required this.position,
    this.imagePath,
    this.startTime,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      memberId: json['memberId'],
      memberName: json['memberName'],
      workType: json['workType'],
      position: json['position'],
      imagePath: json['imagePath'],
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
    );
  }
}

class Department {
  final String deptName;
  final List<Member> memberList;

  Department({
    required this.deptName,
    required this.memberList,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      deptName: json['deptName'],
      memberList: (json['memberList'] as List)
          .map((e) => Member.fromJson(e))
          .toList(),
    );
  }
}

class Member {
  final int memberId;
  final String memberName;
  final String workType;
  final String position;
  final String? imagePath;
  final DateTime? startTime;

  Member({
    required this.memberId,
    required this.memberName,
    required this.workType,
    required this.position,
    this.imagePath,
    this.startTime,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberId: json['memberId'],
      memberName: json['memberName'],
      workType: json['workType'],
      position: json['position'],
      imagePath: json['imagePath'],
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
    );
  }
}
