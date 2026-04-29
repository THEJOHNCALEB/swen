import 'package:flutter_test/flutter_test.dart';
import 'package:swen/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    test('should format recent dates as relative time', () {
      final now = DateTime.now();
      
      final justNow = now.subtract(const Duration(seconds: 30));
      expect(DateFormatter.formatPublishedDate(justNow), 'Just now');

      final minutes = now.subtract(const Duration(minutes: 5));
      expect(DateFormatter.formatPublishedDate(minutes), '5m ago');

      final hours = now.subtract(const Duration(hours: 3));
      expect(DateFormatter.formatPublishedDate(hours), '3h ago');

      final days = now.subtract(const Duration(days: 2));
      expect(DateFormatter.formatPublishedDate(days), '2d ago');
    });

    test('should format old dates as absolute date', () {
      final oldDate = DateTime(2024, 1, 15);
      final formatted = DateFormatter.formatPublishedDate(oldDate);
      
      expect(formatted, contains('Jan'));
      expect(formatted, contains('15'));
      expect(formatted, contains('2024'));
    });

    test('should format full date with time', () {
      final date = DateTime(2024, 3, 15, 14, 30);
      final formatted = DateFormatter.formatFullDate(date);
      
      expect(formatted, contains('March'));
      expect(formatted, contains('15'));
      expect(formatted, contains('2024'));
      expect(formatted, contains('2:30'));
    });

    test('should format short date', () {
      final date = DateTime(2024, 3, 15);
      final formatted = DateFormatter.formatShortDate(date);
      
      expect(formatted, 'Mar 15, 2024');
    });
  });
}
