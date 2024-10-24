import 'dart:async';
import 'package:flutter/material.dart';
import '../models/mainScreen_model.dart';
import '../services/api_service.dart';

class MainScreenProvider with ChangeNotifier {
  MainScreenModel? _mainScreenData;
  String _workingTime = "0:00";
  Timer? _timer;
  bool _isLoading = false;
  String _error = '';

  MainScreenModel? get mainScreenData => _mainScreenData;
  String get workingTime => _workingTime;
  bool get isLoading => _isLoading;
  String get error => _error;

  MainScreenProvider() {
    // 생성자에서 즉시 데이터 로드
    _initData();
  }

  Future<void> _initData() async {
    await fetchMainScreenData();
  }

  Future<void> checkIn() async {
    try {
      _isLoading = true;
      notifyListeners();

      final success = await ApiService.checkIn();
      if (success) {
        // checkIn 성공 후 메인 화면 데이터 새로고침
        await fetchMainScreenData();
        // 타이머 시작
        startTimer();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMainScreenData() async {
    try {
      _isLoading = true;
      notifyListeners();

      _mainScreenData = await ApiService.getMainScreenData();
      
      // 체크인 시간이 있으면 타이머 시작
      if (_mainScreenData?.userStatus.checkTime != null) {
        startTimer();
      }
      
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startTimer() {
    if (_mainScreenData?.userStatus.checkTime != null) {
      _timer?.cancel();
      _timer = Timer.periodic(Duration(minutes: 1), (timer) {
        updateWorkingTime();
      });
      updateWorkingTime();
    }
  }

  void updateWorkingTime() {
    if (_mainScreenData?.userStatus.checkTime != null) {
      final checkTime = DateTime.parse(_mainScreenData!.userStatus.checkTime);
      final now = DateTime.now();
      final difference = now.difference(checkTime);
      
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      
      _workingTime = '$hours:${minutes.toString().padLeft(2, '0')}';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}