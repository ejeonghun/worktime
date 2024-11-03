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
        await refreshData();
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
      
      // 체크인 상태 확인
      if (_mainScreenData?.data.userInfo.workType != 'NOT_CHECK_IN') {
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

  Future<void> refreshData() async {
    try {
      _isLoading = true;
      notifyListeners();

      await fetchMainScreenData();  // 기존 데이터 새로고침
      
      // 체크인 상태에 따라 타이머 시작
      if (_mainScreenData?.data.userInfo.workType != 'NOT_CHECK_IN') {
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
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      updateWorkingTime();
    });
    updateWorkingTime();
  }

  void updateWorkingTime() {
    // 현재는 단순히 타이머만 업데이트
    final now = DateTime.now();
    final hours = now.hour;
    final minutes = now.minute;
    
    _workingTime = '$hours:${minutes.toString().padLeft(2, '0')}';
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}