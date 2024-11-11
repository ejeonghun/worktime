import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:worktime/providers/schedule_provider.dart';
import 'package:worktime/screens/MainScreen.dart';
import 'package:worktime/screens/ScheduleTab.dart';
import 'package:worktime/screens/SplashScreen.dart';
import 'package:worktime/screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktime/services/api_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

/// 전역 네비게이터 키
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // 타임존 초기화
  await ApiService.initialize();
  _initializeNotifications();
  await initializeDateFormatting();
  
  //앱이 종료된 상태에서 푸시 알림을 탭할 때
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    Future.delayed(const Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed('/message',
          arguments: notificationAppLaunchDetails?.notificationResponse?.payload);
    });
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'WorkTime',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: TokenCheckScreen(),
        routes: {
          '/message': (context) => MainScreen(),
          '/schedule': (context) => ScheduleTab(),
        },
      ),
    );
  }
}

class TokenCheckScreen extends StatefulWidget {
  @override
  _TokenCheckScreenState createState() => _TokenCheckScreenState();
}

class _TokenCheckScreenState extends State<TokenCheckScreen> {
  
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      // 토큰이 있으면 MainScreen으로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      // 토큰이 없으면 LoginScreen으로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

void _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = 
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS 초기화 설정
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );


  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}