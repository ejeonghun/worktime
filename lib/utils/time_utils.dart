class TimeUtils {
  static String getElapsedTime(DateTime? startTime) {
    if (startTime == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(startTime);
    
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    
    if (hours > 0) {
      return '$hours시간 ${minutes}분';
    } else {
      return '$minutes분';
    }
  }
} 