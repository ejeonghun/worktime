import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:worktime/screens/LoginScreen.dart';
import '../models/mainScreen_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';  // navigatorKey를 사용하기 위한 import
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';


class ApiService {
  static final Dio _dio = Dio();
  static const String baseUrl = 'http://localhost:8080';
  
  /// 저장된 인증 정보를 담을 static 변수들
  static String? _token;
  static String? _savedEmail;
  static String? _savedPassword;

  /// 초기 설정 메서드
  static Future<void> initialize() async {
    // SharedPreferences에서 저장된 값들 불러오기
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _savedEmail = prefs.getString('email');
    _savedPassword = prefs.getString('password');

    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        // 응답의 success 필드로 토큰 만료 체크
        if (response.data is Map<String, dynamic> && 
            response.data['success'] == false && 
            response.data['message'].toString().contains('401 UNAUTHORIZED')) {
          // 저장된 인증 정보로 재로그인 시도
          if (_savedEmail != null && _savedPassword != null) {
            try {
              await login(_savedEmail!, _savedPassword!, saveCredentials: false);
              // 원래 요청 재시도
              final opts = response.requestOptions;
              final newResponse = await _dio.request(
                opts.path,
                options: Options(
                  method: opts.method,
                  headers: opts.headers,
                ),
                data: opts.data,
                queryParameters: opts.queryParameters,
              );
              return handler.resolve(newResponse);
            } catch (e) {
              debugPrint('재로그인 실패: $e');
              // 재로그인 실패 시 로그인 화면으로 이동
              navigateToLogin();
            }
          } else {
            // 저장된 인증 정보가 없으면 로그인 화면으로 이동
            navigateToLogin();
          }
        }
        return handler.next(response);
      },
    ));
  }

  // 로그인 메서드
  static Future<String?> login(
    String email, 
    String password, 
    {bool saveCredentials = true}
  ) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/v1/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      if (response.statusCode == 200) {
        _token = response.data as String;
        if (saveCredentials) {
          _savedEmail = email;
          _savedPassword = password;
          // SharedPreferences에도 저장
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', _token!);
          await prefs.setString('email', email);
          await prefs.setString('password', password);
        }
        return _token;
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception(e.response?.data['message'] ?? '로그인에 실패했습니다.');
      }
      throw Exception('로그인 중 오류가 발생했습니다.');
    }
  }

  // 저장된 인증 정보로 자동 로그인
  static Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');
    
    if (savedEmail != null && savedPassword != null) {
      try {
        await login(savedEmail, savedPassword);
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  // 로그아웃
  static Future<void> logout() async {
    _token = null;
    _savedEmail = null;
    _savedPassword = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('password');
  }

  // 로그인 화면으로 이동하는 유틸리티 메서드
  static void navigateToLogin() {
    // 현재 라우트를 모두 제거하고 로그인 화면으로 이동
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  // 선택적: 에러 메시지를 표시하는 유틸리티 메서드
  static void showErrorMessage(String message) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  static Future<MainScreenModel?> getMainScreenData() async {
    try {
      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('yyyyMMdd');
      String today = formatter.format(now);
      
      final response = await _dio.get('$baseUrl/api/v1/work/list?date=${today}');
      
      // 응답 데이터 로깅
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data.toString()}');
      debugPrint('Response data type: ${response.data.runtimeType}');
      
      if (response.statusCode == 200) {
        // response.data가 이미 Map<String, dynamic> 형태인지 확인
        if (response.data is Map<String, dynamic>) {
          return MainScreenModel.fromJson(response.data);
        } else {
          // JSON 문자열인 경우 파싱
          final Map<String, dynamic> jsonData = 
              response.data is String ? 
              jsonDecode(response.data) : 
              response.data;
          return MainScreenModel.fromJson(jsonData);
        }
      }
      return null;
    } on DioException catch (e) {
      debugPrint('DioError: ${e.message}');
      debugPrint('Error Response: ${e.response?.data}');
      throw Exception('Failed to load main screen data: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('Failed to load main screen data: $e');
    }
  }

  static Future<bool> checkIn() async {
    try {
      // 위치 권한 확인
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('위치 권한이 거부되었습니다.');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해주세요.');
      }

      // 현재 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      debugPrint("위도 : ${position.latitude}, 경도 : ${position.longitude}");
      // 체크인 요청
      final response = await _dio.post(
        '$baseUrl/api/v1/work/checkIn',
        data: {
          "latitude": position.latitude,
          "longitude": position.longitude,
        },
      );

      if (response.data['success'] == true) {
        return true;
      } else {
        throw Exception(response.data['message'] ?? '체크인에 실패했습니다.');
      }
    } catch (e) {
      throw Exception('체크인 실패: $e');
    }
  }
}