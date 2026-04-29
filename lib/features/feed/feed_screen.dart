import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/models/api_response.dart';
import '../../core/widgets/doodle_background.dart';
import '../../core/widgets/empty_state_illustration.dart';
import '../../core/widgets/swen_brand.dart';
import '../../providers/news_provider.dart';
import 'widgets/article_card.dart';
import 'widgets/featured_article_card.dart';
import 'widgets/article_card_skeleton.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesState = ref.watch(topHeadlinesProvider('general'));

    return DoodleBackground(
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(topHeadlinesProvider('general').notifier).refresh();
          },
          color: AppColors.black,
          backgroundColor: AppColors.surface,
          edgeOffset: 80,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              _buildContent(context, ref, articlesState),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: const SwenBrand()
          .animate()
          .fadeIn(duration: 500.ms, curve: Curves.easeOut)
          .slideX(
            begin: -0.05,
            end: 0,
            duration: 500.ms,
            curve: Curves.easeOutCubic,
          ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    ApiResponse articlesState,
  ) {
    return switch (articlesState) {
      ApiLoading() => _buildLoadingSliver(),
      ApiSuccess(data: final articles) => _buildSuccessSliver(
          context,
          ref,
          articles,
        ),
      ApiError(message: final message) => SliverToBoxAdapter(
          child: _buildErrorState(ref, message),
        ),
    };
  }

  Widget _buildLoadingSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ArticleCardSkeleton(isFeatured: index == 0),
          );
        },
        childCount: 5,
      ),
    );
  }

  Widget _buildSuccessSliver(
    BuildContext context,
    WidgetRef ref,
    List articles,
  ) {
    if (articles.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: const Center(
          child: EmptyStateIllustration(
            icon: Icons.article_outlined,
            message: 'No articles found',
            subtitle: 'Check back later for the latest news',
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return _buildTopStorySection(context, articles[0], index);
          }

          if (index == 1) {
            return _buildSectionLabel('LATEST', Icons.trending_up_rounded, index);
          }

          final articleIndex = index - 1;
          if (articleIndex >= articles.length) {
            return _buildCaughtUpCard(index);
          }

          final article = articles[articleIndex];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ArticleCard(
              article: article,
              onTap: () => context.push('/article', extra: article),
            ),
          )
              .animate()
              .fadeIn(
                duration: 400.ms,
                delay: (60 * (index - 2).clamp(0, 8)).ms,
              )
              .slideY(
                begin: 0.06,
                end: 0,
                duration: 400.ms,
                delay: (60 * (index - 2).clamp(0, 8)).ms,
                curve: Curves.easeOutCubic,
              );
        },
        childCount: articles.length + 2,
      ),
    );
  }

  Widget _buildTopStorySection(BuildContext context, dynamic article, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('TOP STORY', Icons.star_rounded, index),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FeaturedArticleCard(
            article: article,
            onTap: () => context.push('/article', extra: article),
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 100.ms)
            .slideY(
              begin: 0.08,
              end: 0,
              duration: 500.ms,
              delay: 100.ms,
              curve: Curves.easeOutCubic,
            ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildSectionLabel(String text, IconData icon, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.grey7,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: AppColors.black),
          ),
          const SizedBox(width: 8),
          Text(
            text,
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.grey6,
                    AppColors.grey6.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: (60 * index).ms)
        .slideX(
          begin: -0.03,
          end: 0,
          duration: 400.ms,
          delay: (60 * index).ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildCaughtUpCard(int index) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.grey7,
            AppColors.grey6.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              size: 28,
              color: AppColors.black,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All caught up',
                  style: AppTextStyles.headline.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Pull down to refresh',
                  style: AppTextStyles.caption.copyWith(color: AppColors.grey4),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 300.ms)
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 500.ms,
          delay: 300.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildErrorState(WidgetRef ref, String message) {
    return SizedBox(
      height: 400,
      child: Center(
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
              const SizedBox(height: 24),
              Text(
                'Oops!',
                style: AppTextStyles.display.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: AppTextStyles.body.copyWith(color: AppColors.grey4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(topHeadlinesProvider('general').notifier).refresh();
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
      ),
    );
  }
}
