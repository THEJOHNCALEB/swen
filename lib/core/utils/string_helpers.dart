class StringHelpers {
  StringHelpers._();

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String removeHtmlTags(String htmlString) {
    final exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String getInitials(String name, {int maxLength = 2}) {
    final words = name.trim().split(' ');
    final initials = words
        .where((word) => word.isNotEmpty)
        .take(maxLength)
        .map((word) => word[0].toUpperCase())
        .join();
    return initials;
  }
}
