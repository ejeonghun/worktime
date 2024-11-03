import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mainScreen_model.dart';
import '../providers/mainScreen_provider.dart';
import '../components/EmployeeItem.dart';
import 'settingsScreen.dart';
import '../services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
            centerTitle: true,
            title: const Text(
              '회사 이름',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
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
                color: Colors.grey[100],
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[300],
                      child: data.data.userInfo.imagePath != null
                          ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: '${ApiService.baseUrl}/images/${data.data.userInfo.imagePath}',
                                placeholder: (context, url) => Icon(Icons.person, color: Colors.grey[600]),
                                errorWidget: (context, url, error) => Icon(Icons.person, color: Colors.grey[600]),
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            )
                          : Icon(Icons.person, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.data.userInfo.memberName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.data.userInfo.position,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: data.data.userInfo.workType == "NOT_CHECK_IN"
                            ? Colors.red[100]
                            : Colors.green[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data.data.userInfo.workType == "NOT_CHECK_IN"
                            ? '미출근'
                            : '출근/퇴근',
                        style: TextStyle(
                          color: data.data.userInfo.workType == "NOT_CHECK_IN"
                              ? Colors.red[700]
                              : Colors.green[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (data.data.userInfo.workType == "NOT_CHECK_IN")
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final success = await ApiService.checkIn();
                        if (success) {
                          await provider.refreshData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('체크인 성공!')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('출근하기'),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: data.data.deptList.length,
                  itemBuilder: (context, index) {
                    final department = data.data.deptList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                department.deptName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${department.memberList.length}명',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...department.memberList.map((member) => 
                          MemberListItem(member: member),
                        ),
                      ],
                    );
                  },
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

class MemberListItem extends StatelessWidget {
  final Member member;

  const MemberListItem({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: member.imagePath != null
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: '${ApiService.baseUrl}/images/${member.imagePath}',
                      placeholder: (context, url) => Icon(Icons.person, color: Colors.grey[600]),
                      errorWidget: (context, url, error) => Icon(Icons.person, color: Colors.grey[600]),
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                    ),
                  )
                : Icon(Icons.person, color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.memberName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member.position,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: member.workType == "NOT_CHECK_IN"
                  ? Colors.grey[300]
                  : Colors.red[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              member.workType == "NOT_CHECK_IN" ? '휴가' : '근무중',
              style: TextStyle(
                color: member.workType == "NOT_CHECK_IN"
                    ? Colors.grey[700]
                    : Colors.red[700],
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}