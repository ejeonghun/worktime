import 'package:flutter/material.dart';
import 'MainScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    // 여기에서 서버와의 통신 및 데이터 로딩을 수행합니다.
    // 예: API 호출, 로컬 데이터 로딩 등
    await Future.delayed(Duration(seconds: 1)); // 예시로 2초 대기

    // 데이터 로딩이 완료되면 MainScreen으로 이동합니다.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 150, // 로고 크기 조정
              height: 150,
            ),
            const SizedBox(height: 11),
            const Text(
              'WorkTime',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}