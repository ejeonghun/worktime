import 'package:flutter/material.dart';

class StatusUtils {
  static Color getStatusColor(String workType) {
    switch (workType) {
      case 'CHECK_IN':
        return const Color(0xFF4CAF50);  // 초록색
      case 'OVERTIME':
        return const Color(0xFFFFA000);  // 주황색
      case 'CHECK_OUT':
        return const Color(0xFF9E9E9E);  // 회색
      default:
        return const Color(0xFFE57373);  // 빨간색
    }
  }

  static Color getStatusTextColor(String workType) {
    switch (workType) {
      case 'CHECK_OUT':
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  static String getStatusText(String workType) {
    switch (workType) {
      case 'CHECK_IN':
        return '근무중';
      case 'OVERTIME':
        return '추가근로';
      case 'CHECK_OUT':
        return '퇴근';
      default:
        return '미출근';
    }
  }
} 