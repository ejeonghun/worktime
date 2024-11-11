import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktime/utils/LocalPushNotifications.dart';
import 'LoginScreen.dart';
import 'package:timezone/timezone.dart' as tz;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  String _selectedLanguage = '한국어';
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
  }

  void _scheduleNotification() async {
    if (_pushNotifications) {
      // 9시간 후 알림 스케줄링
      await flutterLocalNotificationsPlugin.zonedSchedule(
        androidScheduleMode: AndroidScheduleMode.exact,
        0,
        '근무 시간 알림',
        '근무 시간이 9시간이 되었습니다.',
        // 현재 시간 + 9시간
        tz.TZDateTime.now(tz.local).add(Duration(hours: 9)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id',
            'your_channel_name',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  void _showTemporaryNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      '임시 알림',
      '이것은 테스트용 임시 알림입니다.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

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
          SwitchListTile(
            title: Text('푸시 알림'),
            value: _pushNotifications,
            onChanged: (bool value) {
              setState(() {
                _pushNotifications = value;
                if (_pushNotifications) {
                  _scheduleNotification(); // 알림 스케줄링
                }
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                LocalPushNotifications.showSimpleNotification(
                  title: "일반 푸시 알림 제목",
                  body: "일반 푸시 알림 바디",
                  payload: "일반 푸시 알림 데이터");
              },
              child: Text('임시 알림'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
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