import 'dart:async';
import 'package:flutter/material.dart';
import '../models/mainScreen_model.dart';
import '../services/api_service.dart';
import '../utils/time_utils.dart';

class MainScreenProvider with ChangeNotifier {
  MainScreenModel? _mainScreenData;
  Timer? _timer;
  bool _isLoading = false;
  String _error = '';
  String _elapsedTime = '';
  int _selectedIndex = 0;

  MainScreenModel? get mainScreenData => _mainScreenData;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get elapsedTime => _elapsedTime;
  int get selectedIndex => _selectedIndex;

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
      
      if (_mainScreenData?.data.userInfo.workType == "CHECK_IN" || 
          _mainScreenData?.data.userInfo.workType == "OVERTIME") {
        startTimer();
      } else {
        _timer?.cancel();
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
      
      if (_mainScreenData?.data.userInfo.workType == "CHECK_IN" || 
          _mainScreenData?.data.userInfo.workType == "OVERTIME") {
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_mainScreenData?.data.userInfo.startTime != null &&
          (_mainScreenData?.data.userInfo.workType == "CHECK_IN" ||
           _mainScreenData?.data.userInfo.workType == "OVERTIME")) {
        _elapsedTime = TimeUtils.getElapsedTime(_mainScreenData?.data.userInfo.startTime);
        notifyListeners();
      }
    });
    // 초기값 설정
    if (_mainScreenData?.data.userInfo.startTime != null) {
      _elapsedTime = TimeUtils.getElapsedTime(_mainScreenData?.data.userInfo.startTime);
    }
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}