import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_strings.dart';

class SwenBrand extends StatelessWidget {
  final double titleSize;
  final double taglineSize;
  final bool showTagline;
  final CrossAxisAlignment alignment;

  const SwenBrand({
    super.key,
    this.titleSize = 26,
    this.taglineSize = 12,
    this.showTagline = true,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 4,
              height: titleSize * 0.9,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.black, AppColors.grey4],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              AppStrings.appName,
              style: AppTextStyles.display.copyWith(
                fontSize: titleSize,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                height: 1.1,
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              AppStrings.tagline,
              style: AppTextStyles.caption.copyWith(
                fontSize: taglineSize,
                color: AppColors.grey4,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
