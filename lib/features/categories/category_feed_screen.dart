import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/categories.dart';
import '../../core/models/api_response.dart';
import '../../core/widgets/doodle_background.dart';
import '../../providers/news_provider.dart';
import '../feed/widgets/article_card.dart';
import '../feed/widgets/article_card_skeleton.dart';

class CategoryFeedScreen extends ConsumerWidget {
  final String category;

  const CategoryFeedScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesState = ref.watch(topHeadlinesProvider(category));
    final displayName = categoriesDisplay[category] ?? category;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: DoodleBackground(
        opacity: 0.025,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, displayName),
              Expanded(
                child: _buildBody(context, ref, articlesState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String displayName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 22),
            color: AppColors.black,
            onPressed: () => context.pop(),
          ),
          Container(
            width: 3,
            height: 20,
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
            displayName,
            style: AppTextStyles.display.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ApiResponse articlesState,
  ) {
    return switch (articlesState) {
      ApiLoading() => _buildLoadingState(),
      ApiSuccess(data: final articles) => _buildSuccessState(
          context,
          ref,
          articles,
        ),
      ApiError(message: final message) => _buildErrorState(ref, message),
    };
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: ArticleCardSkeleton(),
        );
      },
    );
  }

  Widget _buildSuccessState(
    BuildContext context,
    WidgetRef ref,
    List articles,
  ) {
    if (articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.grey7.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.article_outlined,
                size: 48,
                color: AppColors.grey5,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppStrings.noResults,
              style: AppTextStyles.headline.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(topHeadlinesProvider(category).notifier).refresh();
      },
      color: AppColors.black,
      backgroundColor: AppColors.surface,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ArticleCard(
              article: article,
              onTap: () => context.push('/article', extra: article),
            ),
          )
              .animate()
              .fadeIn(
                duration: 350.ms,
                delay: (50 * index.clamp(0, 10)).ms,
              )
              .slideY(
                begin: 0.06,
                end: 0,
                duration: 350.ms,
                delay: (50 * index.clamp(0, 10)).ms,
                curve: Curves.easeOutCubic,
              );
        },
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.grey7,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: AppColors.grey4,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: AppTextStyles.body.copyWith(color: AppColors.grey4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(topHeadlinesProvider(category).notifier).refresh();
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                AppStrings.retry,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
