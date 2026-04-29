import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class EmptyStateIllustration extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? subtitle;

  const EmptyStateIllustration({
    super.key,
    required this.icon,
    required this.message,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.grey7,
                AppColors.grey6,
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppColors.grey4,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          message,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}
