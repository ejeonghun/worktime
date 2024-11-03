import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginScreen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  String _selectedLanguage = '한국어';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('알림 설정'),
            subtitle: Text('앱 알림을 관리합니다'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // 알림 설정 상세 페이지로 이동
            },
          ),
          SwitchListTile(
            title: Text('푸시 알림'),
            value: _pushNotifications,
            onChanged: (bool value) {
              setState(() {
                _pushNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('이메일 알림'),
            value: _emailNotifications,
            onChanged: (bool value) {
              setState(() {
                _emailNotifications = value;
              });
            },
          ),
          ListTile(
            title: Text('언어 설정'),
            subtitle: Text(_selectedLanguage),
            trailing: Icon(Icons.chevron_right),
            onTap: _showLanguageDialog,
          ),
          ListTile(
            title: Text('개인정보 처리방침'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // 개인정보 처리방침 페이지로 이동
            },
          ),
          ListTile(
            title: Text('이용약관'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // 이용약관 페이지로 이동
            },
          ),
          ListTile(
            title: Text('앱 버전'),
            subtitle: Text('1.0.0'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: Text('로그아웃'),
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),)
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('언어 선택'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('한국어'),
                  onTap: () {
                    setState(() {
                      _selectedLanguage = '한국어';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('English'),
                  onTap: () {
                    setState(() {
                      _selectedLanguage = 'English';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // 토큰 삭제
    await prefs.remove('email'); // 저장된 이메일 삭제
    await prefs.remove('password'); // 저장된 비밀번호 삭제 

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}