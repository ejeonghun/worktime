import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktime/components/CustomBottomNavigatorbar.dart';
import 'package:worktime/screens/MyPageTab.dart';
import 'package:worktime/screens/ScheduleTab.dart';
import 'package:worktime/screens/deptSelectScreen.dart';
import 'package:worktime/services/api_service.dart';
import 'HomeTab.dart';
import '../providers/mainScreen_provider.dart';
import '../providers/user_provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  int _currentIndex = 0;
  int? _deptId; // 회원의 부서 번호 저장 변수 

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {
        _currentIndex = tabController.index; // 현재 탭 인덱스 업데이트
      });
    });
    _checkUserDepartment();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      tabController.index = index; // 탭 인덱스 업데이트
    });
  }

  Future<void> _checkUserDepartment() async {
    // 사용자 정보를 조회하여 deptId 확인
    final userInfo = await ApiService.getUserInfo(); // 사용자 정보 얻어오기
    setState(() {
      _deptId = userInfo['data']['deptId'];
    });
    debugPrint(userInfo.toString());

    // deptId가 없으면 부서 선택 화면으로 이동
    if (_deptId == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DeptSelectScreen(parentContext: context)), // context 전달
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MainScreenProvider()),
      ],
      child: Consumer<MainScreenProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (provider.error.isNotEmpty) {
            return Scaffold(
              body: Center(child: Text(provider.error)),
            );
          }

          if (provider.mainScreenData == null) {
            return const Scaffold(
              body: Center(child: Text('데이터가 없습니다.')),
            );
          }

          final data = provider.mainScreenData!;

          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  // 메인 컨텐츠
                  Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            HomeTab(),
                            ScheduleTab(),
                            MyPageTab() // 내 정보 탭
                          ],
                        ),
                      ),
                      // 바텀바를 위한 여백
                      SizedBox(height: 10),
                    ],
                  ),
                  
                  // 바텀 네비게이션 바
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(0, 255, 255, 255),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: CustomBottomNavigationBar(
                          currentIndex: _currentIndex,
                          onTap: _onTabTapped,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}