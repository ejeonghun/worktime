class Schedule {
  final int? scheduleId;
  final int? memberId;
  final int? departmentId;
  final int? companyId;
  final String scheduleName;
  final String scheduleType;
  final String scheduleDetails;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? memberName;
  final String? deptName;

  Schedule({
    this.scheduleId,
    this.memberId,
    this.departmentId,
    this.companyId,
    required this.scheduleName,
    required this.scheduleType,
    required this.scheduleDetails,
    required this.startDate,
    required this.endDate,
    this.createdAt,
    this.updatedAt,
    this.memberName,
    this.deptName,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleId: json['scheduleId'],
      memberId: json['memberId'],
      departmentId: json['departmentId'],
      companyId: json['companyId'],
      scheduleName: json['scheduleName'],
      scheduleType: json['scheduleType'],
      scheduleDetails: json['scheduleDetails'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
      memberName: json['memberName'],
      deptName: json['deptName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'memberId': memberId,
      'departmentId': departmentId,
      'companyId': companyId,
      'scheduleName': scheduleName,
      'scheduleType': scheduleType,
      'scheduleDetails': scheduleDetails,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'memberName': memberName,
      'deptName': deptName,
    };
  }
}