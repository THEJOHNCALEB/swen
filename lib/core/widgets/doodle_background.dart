import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DoodleBackground extends StatelessWidget {
  final Widget child;
  final double opacity;

  const DoodleBackground({
    super.key,
    required this.child,
    this.opacity = 0.04,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _DoodlePainter(opacity: opacity),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _DoodlePainter extends CustomPainter {
  final double opacity;

  _DoodlePainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final color = AppColors.grey4.withOpacity(opacity);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final icons = [
      Icons.article_outlined,
      Icons.public_outlined,
      Icons.feed_outlined,
      Icons.language_outlined,
      Icons.bookmark_border_rounded,
      Icons.trending_up_rounded,
      Icons.search_rounded,
      Icons.auto_awesome_outlined,
      Icons.lightbulb_outline_rounded,
      Icons.podcasts_rounded,
      Icons.rss_feed_rounded,
      Icons.wifi_rounded,
    ];

    const spacing = 90.0;
    const iconSize = 28.0;

    int iconIdx = 0;
    for (double y = -20; y < size.height + spacing; y += spacing) {
      final offsetX = ((y / spacing).floor() % 2 == 0) ? 0.0 : spacing / 2;
      for (double x = -20 + offsetX; x < size.width + spacing; x += spacing) {
        final icon = icons[iconIdx % icons.length];
        iconIdx++;

        textPainter.text = TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: iconSize,
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
            color: color,
          ),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DoodlePainter old) => old.opacity != opacity;
}
