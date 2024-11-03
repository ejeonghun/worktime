import 'package:flutter/material.dart';
import 'package:worktime/screens/MainScreen.dart';
import 'package:worktime/screens/SplashScreen.dart';
import 'package:worktime/screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktime/services/api_service.dart';

/// 전역 네비게이터 키
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'WorkTime',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TokenCheckScreen(),
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