import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/mainScreen_model.dart';

class ApiService {
  static final Dio _dio = Dio();
  static const String baseUrl = 'https://ip.ggm.kr/test';

  static Future<MainScreenModel?> getMainScreenData() async {
    try {
      final response = await _dio.get('$baseUrl/main.json');
      debugPrint('API Response: ${response.data}'); // 디버깅용 로그
      if (response.statusCode == 200) {
        return MainScreenModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load main screen data: $e');
    }
  }

  static Future<bool> checkIn() async {
    try {
      final response = await _dio.post('$baseUrl/check-in');
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to check in: $e');
    }
  }
}