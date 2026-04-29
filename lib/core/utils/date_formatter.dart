import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatPublishedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  static String formatFullDate(DateTime date) {
    return DateFormat('MMMM d, yyyy • h:mm a').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }
}
