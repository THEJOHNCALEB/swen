import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/categories.dart';
import '../../core/widgets/doodle_background.dart';
import '../../core/widgets/swen_brand.dart';

const _categoryIcons = <String, IconData>{
  'general': Icons.public_rounded,
  'business': Icons.trending_up_rounded,
  'technology': Icons.memory_rounded,
  'science': Icons.science_rounded,
  'health': Icons.favorite_rounded,
  'sports': Icons.sports_soccer_rounded,
  'entertainment': Icons.movie_rounded,
};

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DoodleBackground(
      opacity: 0.025,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SwenBrand(titleSize: 22, taglineSize: 10),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.grey7,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.grid_view_rounded,
                            size: 14,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'EXPLORE',
                          style: AppTextStyles.label.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: AppColors.grey6,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = newsCategories[index];
                    final displayName =
                        categoriesDisplay[category] ?? category;
                    final icon =
                        _categoryIcons[category] ?? Icons.article_rounded;

                    return _buildCategoryCard(
                      context,
                      category,
                      displayName,
                      icon,
                      index,
                    );
                  },
                  childCount: newsCategories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String category,
    String displayName,
    IconData icon,
    int index,
  ) {
    return GestureDetector(
      onTap: () => context.push('/category/$category'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: 12,
              bottom: 12,
              child: Icon(
                icon,
                size: 40,
                color: AppColors.grey6.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.grey7,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 18, color: AppColors.black),
                  ),
                  const Spacer(),
                  Text(
                    displayName,
                    style: AppTextStyles.headline.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 350.ms,
          delay: (60 * index).ms,
        )
        .scale(
          begin: const Offset(0.92, 0.92),
          end: const Offset(1, 1),
          duration: 350.ms,
          delay: (60 * index).ms,
          curve: Curves.easeOutCubic,
        );
  }
}
