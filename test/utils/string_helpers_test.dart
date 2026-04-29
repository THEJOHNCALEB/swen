import 'package:flutter_test/flutter_test.dart';
import 'package:swen/core/utils/string_helpers.dart';

void main() {
  group('StringHelpers', () {
    test('should truncate long strings', () {
      const longText = 'This is a very long text that needs to be truncated';
      final truncated = StringHelpers.truncate(longText, 20);
      
      expect(truncated.length, 23);
      expect(truncated, 'This is a very long ...');
    });

    test('should not truncate short strings', () {
      const shortText = 'Short text';
      final result = StringHelpers.truncate(shortText, 20);
      
      expect(result, shortText);
    });

    test('should remove HTML tags', () {
      const html = '<p>This is <strong>bold</strong> text</p>';
      final cleaned = StringHelpers.removeHtmlTags(html);
      
      expect(cleaned, 'This is bold text');
    });

    test('should capitalize first letter', () {
      expect(StringHelpers.capitalizeFirst('hello'), 'Hello');
      expect(StringHelpers.capitalizeFirst('world'), 'World');
      expect(StringHelpers.capitalizeFirst(''), '');
    });

    test('should get initials from name', () {
      expect(StringHelpers.getInitials('John Doe'), 'JD');
      expect(StringHelpers.getInitials('Jane Smith'), 'JS');
      expect(StringHelpers.getInitials('Single'), 'S');
      expect(StringHelpers.getInitials('Three Word Name', maxLength: 3), 'TWN');
    });
  });
}
