import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/categories.dart';
import '../../core/utils/responsive.dart';
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
    final layout = Responsive.of(context);

    return DoodleBackground(
      opacity: 0.025,
      child: SafeArea(
        bottom: false,
        child: layout == ScreenLayout.mobile
            ? _buildMobileLayout(context)
            : _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SwenBrand(titleSize: 22, taglineSize: 10),
                const SizedBox(height: 20),
                _buildExploreLabel(),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          sliver: _buildCategoryGrid(context),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 28, 20, 12),
                child: Text('Explore',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black)),
              ),
              const Divider(height: 1, color: AppColors.grey6),
              const SizedBox(height: 8),
              ...newsCategories.map((category) {
                final displayName =
                    categoriesDisplay[category] ?? category;
                return _CategorySidebarItem(
                  category: category,
                  label: displayName,
                  onTap: () =>
                      context.push('/category/$category'),
                );
              }),
            ],
          ),
        ),
        const VerticalDivider(width: 1, color: AppColors.grey6),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildExploreLabel()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                sliver: _buildCategoryGrid(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExploreLabel() {
    return Row(
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
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    return SliverGrid(
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
          final icon = _categoryIcons[category] ?? Icons.article_rounded;

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
                    child:
                        Icon(icon, size: 18, color: AppColors.black),
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

class _CategorySidebarItem extends StatefulWidget {
  final String category;
  final String label;
  final VoidCallback onTap;
  const _CategorySidebarItem({
    required this.category,
    required this.label,
    required this.onTap,
  });

  @override
  State<_CategorySidebarItem> createState() => _CategorySidebarItemState();
}

class _CategorySidebarItemState extends State<_CategorySidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.grey7
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(widget.label,
                style: AppTextStyles.caption.copyWith(
                    fontSize: 13,
                    color: AppColors.black,
                    fontWeight: FontWeight.w400)),
          ),
        ),
      );
}
