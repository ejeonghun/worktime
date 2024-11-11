import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showCustomSnackBar(BuildContext context, String message, {String type = 'info'}) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case 'success':
        backgroundColor = Colors.green; // 성공 색상
        textColor = Colors.white;
        break;
      case 'error':
        backgroundColor = Colors.red; // 실패 색상
        textColor = Colors.white;
        break;
      case 'warning':
        backgroundColor = Colors.orange; // 주의 색상
        textColor = Colors.black;
        break;
      default:
        backgroundColor = Colors.blueAccent; // 기본 색상
        textColor = Colors.white;
    }

    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
      ),
      backgroundColor: backgroundColor, // 배경색
      behavior: SnackBarBehavior.floating, // 플로팅 스낵바
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // 모서리 둥글기
      ),
      margin: const EdgeInsets.all(16), // 여백
      duration: const Duration(seconds: 3), // 지속 시간
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}