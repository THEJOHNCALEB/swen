import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GlassBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlassBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 24,
      right: 24,
      bottom: MediaQuery.of(context).padding.bottom + 12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.75),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppColors.white.withOpacity(0.12),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _BarItem(
                  icon: Icons.home_rounded,
                  label: 'Feed',
                  isActive: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _BarItem(
                  icon: Icons.grid_view_rounded,
                  label: 'Explore',
                  isActive: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
                _BarItem(
                  icon: Icons.search_rounded,
                  label: 'Search',
                  isActive: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
                _BarItem(
                  icon: Icons.bookmark_rounded,
                  label: 'Saved',
                  isActive: currentIndex == 3,
                  onTap: () => onTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.white : AppColors.white.withOpacity(0.5),
              size: 22,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  color: AppColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
