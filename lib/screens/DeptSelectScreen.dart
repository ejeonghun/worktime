import 'package:flutter/material.dart';
import 'package:worktime/screens/MainScreen.dart';
import '../services/api_service.dart';
import '../utils/CustomSnackBar.dart';

class DeptSelectScreen extends StatefulWidget {
  final BuildContext parentContext; // 부모 컨텍스트 전달

  DeptSelectScreen({required this.parentContext});

  @override
  _DeptSelectScreenState createState() => _DeptSelectScreenState();
}

class _DeptSelectScreenState extends State<DeptSelectScreen> {
  String? _selectedDeptId;
  List<dynamic> _departments = [];
  final _positionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDepartments(); // 부서 목록 가져오기
  }

  Future<void> _fetchDepartments() async {
    try {
      final response = await ApiService.getDepartments(); // 인증 코드 필요 시 수정
      if (response['success']) {
        setState(() {
          _departments = response['data'];
        });
      } else {
        CustomSnackbar.showCustomSnackBar(context, '부서 목록을 가져오는 데 실패했습니다.', type: 'error');
      }
    } catch (e) {
      CustomSnackbar.showCustomSnackBar(context, e.toString(), type: 'error');
    }
  }

  Future<void> _joinDepartment() async {
    if (_selectedDeptId != null && _positionController.text.isNotEmpty) {
      try {
        await ApiService.joinDepartment(_selectedDeptId!, _positionController.text);
        Navigator.of(widget.parentContext).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        CustomSnackbar.showCustomSnackBar(context, '부서에 참가하였습니다.', type: 'success');
      } catch (e) {
        CustomSnackbar.showCustomSnackBar(context, e.toString(), type: 'error');
      }
    } else {
      CustomSnackbar.showCustomSnackBar(context, '부서를 선택하고 직급을 입력해주세요.', type: 'warning');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        '부서 선택',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              hint: Text('부서 선택'),
              value: _selectedDeptId,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDeptId = newValue;
                });
              },
              items: _departments.map<DropdownMenuItem<String>>((dept) {
                return DropdownMenuItem<String>(
                  value: dept['deptId'].toString(),
                  child: Text(dept['deptName']),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _positionController,
              decoration: InputDecoration(
                hintText: '직급',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _joinDepartment,
          child: Text('확인', style: TextStyle(color: Colors.blue)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // 팝업 닫기
          },
          child: Text('취소', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
