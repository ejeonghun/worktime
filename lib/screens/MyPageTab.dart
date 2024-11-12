import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktime/screens/SettingsScreen.dart';
import '../providers/user_provider.dart';
import 'package:intl/intl.dart';

class MyPageTab extends StatefulWidget {
  @override
  _MyPageTabState createState() => _MyPageTabState();
}

class _MyPageTabState extends State<MyPageTab> {
  @override
  void initState() {
    super.initState();
    // 다음 프레임에서 실행되도록 스케줄링
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('내 정보', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (userProvider.errorMessage != null) {
            return Center(child: Text('오류 발생: ${userProvider.errorMessage}'));
          }
          if (userProvider.userInfo == null) {
            return Center(child: Text('데이터가 없습니다.'));
          }

          final userInfo = userProvider.userInfo!;
          DateTime startAt = DateTime.parse(userInfo['startAt'] ?? DateTime.now().toString());
          DateTime endAt = DateTime.parse(userInfo['endAt'] ?? DateTime.now().toString());
          Duration workDuration = endAt.difference(startAt);

          return SingleChildScrollView(
            child: Column(
              children: [
                // 프로필 섹션
                Container(
                  color: const Color.fromARGB(0, 255, 255, 255),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        child: Icon(Icons.person, size: 50, color: Colors.grey[400]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        userInfo['name'] ?? '이름 정보 없음',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${userInfo['deptName'] ?? '부서 정보 없음'} · ${userInfo['position'] ?? '직급 정보 없음'}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                
                // 근무 정보 카드
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(0, 255, 255, 255),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoTile(
                        '오늘의 근무 시간',
                        _formatDuration(workDuration),
                        Icons.access_time,
                        Colors.blue,
                      ),
                      Divider(height: 1),
                      _buildInfoTile(
                        '출근 시간',
                        DateFormat('HH:mm').format(startAt),
                        Icons.login,
                        Colors.green,
                      ),
                      Divider(height: 1),
                      _buildInfoTile(
                        '퇴근 시간',
                        DateFormat('HH:mm').format(endAt),
                        Icons.logout,
                        Colors.red,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 20),
                
                // 추가 정보 섹션
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value.isNotEmpty ? value : '정보 없음',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "$twoDigitHours시간 $twoDigitMinutes분";
  }
}