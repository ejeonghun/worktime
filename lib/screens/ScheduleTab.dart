import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:worktime/providers/schedule_provider.dart';
import 'package:intl/intl.dart';

import '../models/ScheduleModel.dart';
import '../models/ScheduleUtils.dart';

class ScheduleTab extends StatefulWidget {
  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  late final ScheduleProvider _provider;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final _formKey = GlobalKey<FormState>();
  
  // 일정 입력을 위한 컨트롤러들
  final _nameController = TextEditingController();
  final _detailsController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _scheduleType = ScheduleType.VACATION.value;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<ScheduleProvider>(context, listen: false);
    _provider.loadSchedules();
    _provider.loadSchedulesByDate(_provider.selectedDay);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('일정 관리', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _provider.loadSchedules(),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddScheduleDialog(context),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        decoration: const BoxDecoration(
          color: Color.fromARGB(0, 255, 255, 255),
        ),
        child: Consumer<ScheduleProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: const Color.fromARGB(0, 255, 255, 255),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: TableCalendar(

                    locale: 'ko_KR',
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: provider.focusedDay,
                    selectedDayPredicate: (day) =>
                        isSameDay(provider.selectedDay, day),
                    calendarFormat: _calendarFormat,
                    eventLoader: (day) {
                      return provider.events[DateTime(day.year, day.month, day.day)] ?? [];
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      provider.setSelectedDay(selectedDay);
                      provider.setFocusedDay(focusedDay);
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      provider.setFocusedDay(focusedDay);
                    },
                    calendarStyle: CalendarStyle(
                      defaultDecoration: const BoxDecoration(color: Color.fromARGB(0, 255, 255, 255), shape: BoxShape.rectangle),

                      markersMaxCount: 4,
                      markerDecoration: const BoxDecoration(
                        color: Colors.orangeAccent,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      outsideDaysVisible: false,
                      
                    ),
                    
                  ),
                ),
                Expanded(
                  child: Consumer<ScheduleProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final selectedDate = DateTime(
                        provider.selectedDay.year,
                        provider.selectedDay.month,
                        provider.selectedDay.day,
                      );
                      
                      final events = provider.events[selectedDate] ?? [];

                      if (events.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.event_busy, size: 50, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('등록된 일정이 없습니다',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }

                      // 스케줄 상세 페이지 부분
                      return ListView.builder( 
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final schedule = events[index];
                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        schedule.scheduleType.getTypeIcon(),
                                        color: schedule.scheduleType.getTypeColor(),
                                        size: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          schedule.scheduleName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${DateFormat('HH:mm').format(schedule.startDate)} - ${DateFormat('HH:mm').format(schedule.endDate)}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                  ),
                                  SizedBox(height: 12),
                                  Divider(),
                                  SizedBox(height: 12),
                                  _buildInfoRow('항목 :', schedule.scheduleType.getTypeText()),
                                  _buildInfoRow('상세내용 :', schedule.scheduleDetails),
                                  _buildInfoRow('담당자 : ', schedule.memberName!),
                                  _buildInfoRow('부서 : ', schedule.deptName!),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        icon: Icon(Icons.edit),
                                        label: Text('수정'),
                                        onPressed: () => _showEditScheduleDialog(context, schedule),
                                      ),
                                      TextButton.icon(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        label: Text('삭제', style: TextStyle(color: Colors.red)),
                                        onPressed: () => _showDeleteConfirmDialog(context, schedule),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
        
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmDialog(BuildContext context, Schedule schedule) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('일정 삭제'),
        content: Text('이 일정을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      try {
        await _provider.deleteSchedule(schedule.scheduleId!, schedule.startDate);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('일정이 삭제되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('일정 삭제 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showAddScheduleDialog(BuildContext context) async {
    _resetForm();
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('새 일정 추가'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildScheduleForm(),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => _submitSchedule(context, isEdit: false),
            child: Text('추가'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditScheduleDialog(BuildContext context, Schedule schedule) async {
    _setFormValues(schedule);
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('일정 수정'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildScheduleForm(),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => _submitSchedule(context, isEdit: true, schedule: schedule),
            child: Text('수정'),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleForm() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: '일정 제목',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return '일정 제목을 입력해주세요';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _detailsController,
          decoration: InputDecoration(
            labelText: '상세 내용',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _scheduleType,
          decoration: InputDecoration(
            labelText: '일정 유형',
            border: OutlineInputBorder(),
          ),
          items: ScheduleType.values.map((type) => DropdownMenuItem(
            value: type.value,
            child: Text(type.label),
          )).toList(),
          onChanged: (value) {
            setState(() {
              _scheduleType = value!;
            });
          },
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.calendar_today),
                label: Text(_startDate == null 
                  ? '시작일 선택' 
                  : DateFormat('yyyy-MM-dd').format(_startDate!)),
                onPressed: () => _selectDate(context, true),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.access_time),
                label: Text(_startTime == null 
                  ? '시작 시간' 
                  : _startTime!.format(context)),
                onPressed: () => _selectTime(context, true),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.calendar_today),
                label: Text(_endDate == null 
                  ? '종료일 선택' 
                  : DateFormat('yyyy-MM-dd').format(_endDate!)),
                onPressed: () => _selectDate(context, false),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.access_time),
                label: Text(_endTime == null 
                  ? '종료 시간' 
                  : _endTime!.format(context)),
                onPressed: () => _selectTime(context, false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime ?? TimeOfDay.now() : _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _resetForm() {
    _nameController.clear();
    _detailsController.clear();
    _startDate = null;
    _endDate = null;
    _startTime = null;
    _endTime = null;
    _scheduleType = 'VACATION';
  }

  void _setFormValues(Schedule schedule) {
    _nameController.text = schedule.scheduleName;
    _detailsController.text = schedule.scheduleDetails;
    _startDate = schedule.startDate;
    _endDate = schedule.endDate;
    _startTime = TimeOfDay.fromDateTime(schedule.startDate);
    _endTime = TimeOfDay.fromDateTime(schedule.endDate);
    _scheduleType = schedule.scheduleType;
  }

  Future<void> _submitSchedule(BuildContext context, {
    required bool isEdit,
    Schedule? schedule
  }) async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_startDate == null || _endDate == null || 
        _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('날짜와 시간을 모두 선택해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final startDateTime = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime!.hour,
      _startTime!.minute,
    );

    final endDateTime = DateTime(
      _endDate!.year,
      _endDate!.month,
      _endDate!.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    if (endDateTime.isBefore(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('종료일은 시작일 이후여야 합니다'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      if (isEdit) {
        final updatedSchedule = ScheduleCreateDto(
          scheduleId: schedule!.scheduleId,
          scheduleName: _nameController.text,
          scheduleType: _scheduleType,
          scheduleDetails: _detailsController.text,
          startDate: startDateTime,
          endDate: endDateTime,
        );
        await _provider.updateSchedule(updatedSchedule);
      } else {
        final newScheduleDto = ScheduleCreateDto(
          scheduleName: _nameController.text,
          scheduleType: _scheduleType,
          scheduleDetails: _detailsController.text,
          startDate: startDateTime,
          endDate: endDateTime,
        );
        await _provider.addSchedule(newScheduleDto);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? '일정이 수정되었습니다' : '일정이 추가되었습니다'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? '일정 수정 실패: $e' : '일정 추가 실패: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// 일정 타입에 따른 색상 및 아이콘 정의를 위한 확장 메서드
extension ScheduleTypeExtension on String {
  Color getTypeColor() {
    switch (this) {
      case 'VACATION':
        return Colors.blue;
      case 'MEETING':
        return Colors.orange;
      case 'BUSINESS_TRIP':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData getTypeIcon() {
    switch (this) {
      case 'VACATION':
        return Icons.beach_access;
      case 'MEETING':
        return Icons.people;
      case 'BUSINESS_TRIP':
        return Icons.flight;
      default:
        return Icons.event;
    }
  }

  String getTypeText() {
    switch (this) {
      case 'VACATION':
        return '휴가';
      case 'MEETING':
        return '회의';
      case 'BUSINESS_TRIP':
        return '출장';
      default:
        return '기타';
    }
  }
}