import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mainScreen_provider.dart';
import '../components/EmployeeItem.dart';
import 'settingsScreen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainScreenProvider(),
      child: MainScreenContent(),
    );
  }
}

class MainScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenProvider>(
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
          appBar: AppBar(
            title: const Text('회사 이름'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
            ],
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[200],
                child: Column(
                  children: [
                    EmployeeListItem(
                      department: data.userInfo.department,
                      name: data.userInfo.name,
                      status: data.userInfo.status,
                    ),
                    if (data.userInfo.check == 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton(
                          onPressed: () => provider.checkIn(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(double.infinity, 40),
                          ),
                          child: Text('출근하기'),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: data.departments.length,
                  itemBuilder: (context, index) {
                    final department = data.departments[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                department.team,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                department.teamCount,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        ...department.employeeList.map((employee) => 
                          EmployeeListItem(
                            department: employee.department,
                            name: employee.name,
                            status: employee.status,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('출근 : ${data.userStatus.checkTime}'),
                    Text('근무 시간 : ${provider.workingTime}'),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today), label: '일정'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications), label: '공지사항'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보')
            ],
          ),
        );
      },
    );
  }
}