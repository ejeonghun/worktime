import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktime/components/CustomBottomNavigatorbar.dart';
import 'package:worktime/screens/ScheduleTab.dart';
import 'HomeTab.dart';
import '../providers/mainScreen_provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {
        _currentIndex = tabController.index; // 현재 탭 인덱스 업데이트
      });
    });
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

  @override
Widget build(BuildContext context) {
  return ChangeNotifierProvider(
    create: (_) => MainScreenProvider(),
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
                          Container(), // 공지사항 탭
                          Container(), // 내 정보 탭
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