import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worktime/components/CustomBottomNavigatorbar.dart';
import '../models/mainScreen_model.dart';
import '../providers/mainScreen_provider.dart';
import '../components/EmployeeItem.dart';
import 'settingsScreen.dart';
import '../services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/StatusUtils.dart';
import 'package:flutter/cupertino.dart';
import '../utils/time_utils.dart';
import '../utils/CustomSnackBar.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainScreenProvider(),
      child: HomeTabContent(),
    );
  }
}

class HomeTabContent extends StatelessWidget {
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
            title: Text(
              data.data.companyName,
              style: const TextStyle(
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
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await provider.refreshData();
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Color.fromARGB(213, 235, 235, 235),
                  child: Column(
                    children: [
                      Row(
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
                              color: StatusUtils.getStatusColor(data.data.userInfo.workType),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              StatusUtils.getStatusText(data.data.userInfo.workType),
                              style: TextStyle(
                                color: StatusUtils.getStatusTextColor(data.data.userInfo.workType),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (data.data.userInfo.startTime != null &&
                          (data.data.userInfo.workType == "CHECK_IN" || 
                           data.data.userInfo.workType == "OVERTIME"))
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 18,
                                color: Color(0xFF4CAF50),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '근무시간: ${TimeUtils.getElapsedTime(data.data.userInfo.startTime)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                if (data.data.userInfo.workType == "VACATION")
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.yellow[100],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.beach_access,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '휴가 중입니다.',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
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
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: data.data.userInfo.workType != null
            ? Container(
                margin: const EdgeInsets.only(bottom: 70),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 55,
                child: Material(
                  elevation: 10,
                  shadowColor: _getButtonShadowColor(data.data.userInfo.workType),
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _getButtonGradient(data.data.userInfo.workType),
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        try {
                          if (data.data.userInfo.workType == "CHECK_IN" || 
                              data.data.userInfo.workType == "OVERTIME") {
                            if (context.mounted) {
                              bool? shouldCheckOut = await showCupertinoDialog<bool>(
                                context: context,
                                builder: (BuildContext context) => CupertinoAlertDialog(
                                  title: const Text('퇴근 확인'),
                                  content: const Text('퇴근 하시겠습니까?'),
                                  actions: [
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: const Text('취소'),
                                    ),
                                    CupertinoDialogAction(
                                      isDestructiveAction: true,
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text('퇴근하기'),
                                    ),
                                  ],
                                ),
                              );

                              if (shouldCheckOut == true && context.mounted) {
                                final success = await ApiService.checkOut();
                                if (success) {
                                  await provider.refreshData();
                                  if (context.mounted) {
                                    CustomSnackbar.showCustomSnackBar(context, "퇴근 처리가 완료되었습니다.", type: 'success');
                                  }
                                } else {
                            await provider.refreshData();
                            CustomSnackbar.showCustomSnackBar(context, "회사가 설정한 위치에서 200m 벗어났습니다.", type: 'error');
                          }
                              }
                            }
                          } else {
                            final success = await ApiService.checkIn();
                            if (success) {
                              await provider.refreshData();
                              if (context.mounted) {
                                CustomSnackbar.showCustomSnackBar(context, "출근 하셨습니다.", type: 'success');
                              }
                            } else {
                            await provider.refreshData();
                            CustomSnackbar.showCustomSnackBar(context, "회사가 설정한 거리에서 200m 벗어났습니다.", type: 'error');
                          }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getButtonIcon(data.data.userInfo.workType),
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _getButtonText(data.data.userInfo.workType),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : null,
          // bottomNavigationBar: CustomBottomNavigationBar(
          //   currentIndex: provider.selectedIndex, // 현재 선택된 인덱스
          //   onTap: (index) {
          //     provider.setSelectedIndex(index); // 선택된 인덱스 업데이트
          //     // 화면 전환 로직 추가
          //     switch (index) {
          //       case 0:
          //         Navigator.pushNamed(context, '/home');
          //         break;
          //       case 1:
          //         Navigator.pushNamed(context, '/schedule');
          //         break;
          //       case 2:
          //         Navigator.pushNamed(context, '/notifications');
          //         break;
          //       case 3:
          //         Navigator.pushNamed(context, '/profile');
          //         break;
          //     }
          //   },
          // ),
        );
      },
    );
  }

  Color _getButtonShadowColor(String workType) {
    switch (workType) {
      case 'CHECK_OUT':
      case 'NOT_CHECK_IN':
      case 'VACATION':
        return Colors.green.withOpacity(0.4);
      case 'CHECK_IN':
      case 'OVERTIME':
        return Colors.red.withOpacity(0.4);
      default:
        return Colors.grey.withOpacity(0.4);
    }
  }

  List<Color> _getButtonGradient(String workType) {
    switch (workType) {
      case 'CHECK_OUT':
      case 'NOT_CHECK_IN':
      case 'VACATION':
        return [
          const Color(0xFF4CAF50),
          const Color(0xFF66BB6A),
        ];
      case 'CHECK_IN':
      case 'OVERTIME':
        return [
          const Color(0xFFFF6B6B),
          const Color(0xFFFF8787),
        ];
      default:
        return [
          Colors.grey,
          Colors.grey.shade600,
        ];
    }
  }

  IconData _getButtonIcon(String workType) {
    switch (workType) {
      case 'CHECK_OUT':
      case 'NOT_CHECK_IN':
      case 'VACATION':
        return Icons.login_rounded;
      case 'CHECK_IN':
      case 'OVERTIME':
        return Icons.logout_rounded;
      default:
        return Icons.access_time;
    }
  }

  String _getButtonText(String workType) {
    switch (workType) {
      case 'CHECK_OUT':
      case 'NOT_CHECK_IN':
      case 'VACATION':
        return '출근하기';
      case 'CHECK_IN':
      case 'OVERTIME':
        return '퇴근하기';
      default:
        return '상태 확인';
    }
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
      child: Column(
        children: [
          Row(
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
                  color: member.workType == "VACATION" 
                      ? Colors.yellow[300] 
                      : StatusUtils.getStatusColor(member.workType),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  member.workType == "VACATION" 
                      ? '휴가' 
                      : StatusUtils.getStatusText(member.workType),
                  style: TextStyle(
                    color: member.workType == "VACATION" 
                        ? Colors.black 
                        : StatusUtils.getStatusTextColor(member.workType),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          if (member.startTime != null &&
              (member.workType == "CHECK_IN" || 
               member.workType == "OVERTIME"))
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 56),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    TimeUtils.getElapsedTime(member.startTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}