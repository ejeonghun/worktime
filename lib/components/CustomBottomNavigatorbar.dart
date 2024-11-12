// lib/components/custom_bottom_navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

@override
Widget build(BuildContext context) {
  return BottomBar(
    child: Container(
      margin: const EdgeInsets.only(bottom: 8, top: 8, left: 80, right: 80),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home, '홈'),
          _buildNavItem(1, Icons.calendar_today, '일정'),
          _buildNavItem(2, Icons.person, '내 정보'),
        ],
      ),
    ),
    width: MediaQuery.of(context).size.width,
    borderRadius: BorderRadius.circular(20),
    duration: const Duration(milliseconds: 500),
    curve: Curves.decelerate,
    showIcon: false,
    barColor: Colors.transparent,
    start: 2,
    end: 0,
    offset: 0,
    barAlignment: Alignment.bottomCenter,
    hideOnScroll: true,
    body: (context, controller) => Container(),
  );
}

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}