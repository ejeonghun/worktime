// lib/providers/schedule_provider.dart

import 'package:flutter/material.dart';
import 'package:worktime/models/ScheduleUtils.dart';
import 'package:worktime/services/api_service.dart';
import '../models/ScheduleModel.dart';
import 'package:intl/intl.dart';

class ScheduleProvider with ChangeNotifier {
  Map<DateTime, List<Schedule>> _events = {};
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  late bool _isLoading;

  bool get isLoading => _isLoading; 

  Map<DateTime, List<Schedule>> get events => _events;
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;


// Future<void> loadSchedules() async {
//     try {
//       final yearMonth = DateFormat('yyyy-MM').format(_focusedDay);
//       final schedules = await ApiService.getSchedules(yearMonth);
      
//       _events.clear(); // 기존 이벤트 초기화
      
//       // 여러 날짜에 걸친 일정 처리
//       for (var schedule in schedules) {
//         DateTime start = schedule.startDate;
//         DateTime end = schedule.endDate;
        
//         // 시작일부터 종료일까지 모든 날짜에 일정 추가
//         for (var date = start;
//             date.isBefore(end.add(Duration(days: 1)));
//             date = date.add(Duration(days: 1))) {
          
//           DateTime key = DateTime(date.year, date.month, date.day);
//           _events[key] = [...(_events[key] ?? []), schedule];
//         }
//       }
      
//       notifyListeners();
//     } catch (e) {
//       debugPrint('일정 로드 실패: $e');
//       rethrow;
//     }
//   }

Future<void> loadSchedules() async {
    try {
      _isLoading = true;

      // 현재 포커스된 달의 첫날과 마지막날 계산
      final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
      final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

      final yearMonth = DateFormat('yyyy-MM').format(_focusedDay);
      final schedules = await ApiService.getSchedules(yearMonth);
      
      // 해당 월의 이벤트 초기화
      _events.removeWhere((key, _) => 
        key.isAfter(firstDay.subtract(Duration(days: 1))) && 
        key.isBefore(lastDay.add(Duration(days: 1)))
      );

      // 새로운 일정 추가
      for (var schedule in schedules) {
        DateTime start = schedule.startDate;
        DateTime end = schedule.endDate;
        
        for (var date = start;
            date.isBefore(end.add(Duration(days: 1)));
            date = date.add(Duration(days: 1))) {
          
          DateTime key = DateTime(date.year, date.month, date.day);
          _events[key] = [...(_events[key] ?? []), schedule];
        }
      }
    } catch (e) {
      debugPrint('일정 로드 실패: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFocusedDay(DateTime day) {
    if (_focusedDay.month != day.month || _focusedDay.year != day.year) {
      _focusedDay = day;
      loadSchedules(); // 월이 변경될 때마다 데이터 로드
    } else {
      _focusedDay = day;
    }
    notifyListeners();
  }


Future<void> loadSchedulesByDate(DateTime date) async {
  try {
    _isLoading = true;

    final schedules = await ApiService.getSchedulesByDate(date);
    final key = DateTime(date.year, date.month, date.day);
    _events[key] = schedules;
    
    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _isLoading = false;
    debugPrint('특정 날짜 일정 로드 실패: $e');
    notifyListeners();
    rethrow;
  }
}



void setSelectedDay(DateTime day) {
  _selectedDay = day;
  loadSchedulesByDate(day); // API 호출
  notifyListeners(); // UI 업데이트 트리거
}


  Future<void> addSchedule(ScheduleCreateDto schedule) async {
    try {
      await ApiService.createSchedule(schedule);
      await loadSchedulesByDate(schedule.startDate);
      await loadSchedules();
    } catch (e) {
      debugPrint('일정 추가 실패: $e');
      rethrow;
    }
  }

  Future<void> updateSchedule(ScheduleCreateDto schedule) async {
    try {
      await ApiService.updateSchedule(schedule);
      await loadSchedulesByDate(schedule.startDate);
      await loadSchedules();
    } catch (e) {
      debugPrint('일정 수정 실패: $e');
      rethrow;
    }
  }

  Future<void> deleteSchedule(int scheduleId, DateTime date) async {
    try {
      await ApiService.deleteSchedule(scheduleId);
      await loadSchedulesByDate(date);
      await loadSchedules();
    } catch (e) {
      debugPrint('일정 삭제 실패: $e');
      rethrow;
    }
  }

  // 에러 처리를 위한 헬퍼 메서드
  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}