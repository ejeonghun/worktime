// 일정 타입 enum 정의
import 'package:intl/intl.dart';

enum ScheduleType {
  MEETING('미팅', 'MEETING'),
  VACATION('휴가', 'VACATION'),
  BUSINESS_TRIP('출장', 'BUSINESS_TRIP'),
  OTHER('기타', 'OTHER');

  final String label;
  final String value;
  const ScheduleType(this.label, this.value);
}

// 일정 생성을 위한 DTO 클래스
class ScheduleCreateDto {
  final int? scheduleId;
  final String scheduleName;
  final String scheduleType;
  final String scheduleDetails;
  final DateTime startDate;
  final DateTime endDate;

  ScheduleCreateDto({
    this.scheduleId,
    required this.scheduleName,
    required this.scheduleType,
    required this.scheduleDetails,
    required this.startDate,
    required this.endDate,
  });


  Map<String, dynamic> toJson() {
    // 서버 형식에 맞춰 날짜 포맷팅
    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm");
    return {
      if (scheduleId != null) 'scheduleId': scheduleId,
      'scheduleName': scheduleName,
      'scheduleType': scheduleType,
      'scheduleDetails': scheduleDetails,
      'startDate': formatter.format(startDate),
      'endDate': formatter.format(endDate),
    };
  }
}