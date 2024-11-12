import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _userInfo;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get userInfo => _userInfo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserInfo() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getUserDetail();
      if (response['success']) {
        _userInfo = response['data'];
      } else {
        _errorMessage = response['message'];
      }
    } catch (error) {
      _errorMessage = '사용자 정보를 가져오는 데 실패했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
