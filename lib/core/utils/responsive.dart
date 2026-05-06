import 'package:flutter/widgets.dart';

enum ScreenLayout { mobile, tablet, desktop }

class Responsive {
  static const double mobileMax = 600;
  static const double tabletMax = 1024;

  static ScreenLayout of(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileMax) return ScreenLayout.mobile;
    if (width < tabletMax) return ScreenLayout.tablet;
    return ScreenLayout.desktop;
  }

  static bool isMobile(BuildContext context) =>
      of(context) == ScreenLayout.mobile;
  static bool isTablet(BuildContext context) =>
      of(context) == ScreenLayout.tablet;
  static bool isDesktop(BuildContext context) =>
      of(context) == ScreenLayout.desktop;
}
