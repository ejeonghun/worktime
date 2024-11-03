enum WorkType {
  NOT_CHECK_IN,
  CHECK_IN,
  // 필요한 다른 상태들 추가
}

extension WorkTypeExtension on WorkType {
  String get displayName {
    switch (this) {
      case WorkType.NOT_CHECK_IN:
        return '미출근';
      case WorkType.CHECK_IN:
        return '출근';
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

  MainScreenData({
    required this.userInfo,
    required this.deptList,
  });

  factory MainScreenData.fromJson(Map<String, dynamic> json) {
    return MainScreenData(
      userInfo: UserInfo.fromJson(json['userInfo']),
      deptList: (json['deptList'] as List)
          .map((e) => Department.fromJson(e))
          .toList(),
    );
  }
}

class UserInfo {
  final int memberId;
  final String memberName;
  final String workType;
  final String position;
  final String? imagePath;

  UserInfo({
    required this.memberId,
    required this.memberName,
    required this.workType,
    required this.position,
    this.imagePath,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      memberId: json['memberId'],
      memberName: json['memberName'],
      workType: json['workType'],
      position: json['position'],
      imagePath: json['imagePath'],
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

  Member({
    required this.memberId,
    required this.memberName,
    required this.workType,
    required this.position,
    this.imagePath,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberId: json['memberId'],
      memberName: json['memberName'],
      workType: json['workType'],
      position: json['position'],
      imagePath: json['imagePath'],
    );
  }
}
