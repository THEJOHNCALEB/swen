import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/models/api_response.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/doodle_background.dart';
import '../../core/widgets/empty_state_illustration.dart';
import '../../core/widgets/swen_brand.dart';
import '../../providers/news_provider.dart';
import '../../providers/bookmarks_provider.dart';
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
        child: LayoutBuilder(builder: (context, constraints) {
          final layout = Responsive.of(context);
          return switch (layout) {
            ScreenLayout.desktop => _buildDesktopLayout(
                context, ref, articlesState, constraints),
            ScreenLayout.tablet => _buildTabletLayout(
                context, ref, articlesState, constraints),
            ScreenLayout.mobile => _buildMobileLayout(
                context, ref, articlesState),
          };
        }),
      ),
    );
  }

  Widget _buildMobileLayout(
      BuildContext context, WidgetRef ref, ApiResponse articlesState) {
    return RefreshIndicator(
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
    );
  }

  Widget _buildTabletLayout(BuildContext context, WidgetRef ref,
      ApiResponse articlesState, BoxConstraints constraints) {
    return RefreshIndicator(
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
          _buildContentTablet(context, ref, articlesState),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref,
      ApiResponse articlesState, BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(topHeadlinesProvider('general').notifier)
                  .refresh();
            },
            color: AppColors.black,
            backgroundColor: AppColors.surface,
            edgeOffset: 80,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                _buildContent(context, ref, articlesState),
                const SliverToBoxAdapter(
                    child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
        const VerticalDivider(
            width: 1, color: AppColors.grey6),
        Expanded(
          flex: 4,
          child: _DesktopSidebar(
            categories: const [
              'general',
              'technology',
              'business',
              'sports',
              'health',
              'entertainment',
              'science',
            ],
            savedCount: ref.watch(bookmarksProvider) is ApiSuccess
                ? (ref.watch(bookmarksProvider) as ApiSuccess)
                        .data
                        .length
                    .toString()
                : '-',
          ),
        ),
      ],
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

  Widget _buildContentTablet(
    BuildContext context,
    WidgetRef ref,
    ApiResponse articlesState,
  ) {
    return switch (articlesState) {
      ApiLoading() => _buildLoadingGrid(),
      ApiSuccess(data: final articles) =>
        _buildSuccessGrid(context, ref, articles),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child:
                ArticleCardSkeleton(isFeatured: index == 0),
          );
        },
        childCount: 5,
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ArticleCardSkeleton(),
          );
        },
        childCount: 6,
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
            return _buildSectionLabel(
                'LATEST', Icons.trending_up_rounded, index);
          }

          final articleIndex = index - 1;
          if (articleIndex >= articles.length) {
            return _buildCaughtUpCard(index);
          }

          final article = articles[articleIndex];
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ArticleCard(
              article: article,
              onTap: () =>
                  context.push('/article', extra: article),
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

  Widget _buildSuccessGrid(
      BuildContext context, WidgetRef ref, List articles) {
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

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      sliver: SliverGrid(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final article = articles[index];
            return ArticleCard(
                    article: article,
                    compactImage: true,
                    onTap: () =>
                        context.push('/article', extra: article))
                .animate()
                .fadeIn(
                  duration: 400.ms,
                  delay: (60 * index.clamp(0, 8)).ms,
                )
                .slideY(
                  begin: 0.06,
                  end: 0,
                  duration: 400.ms,
                  delay: (60 * index.clamp(0, 8)).ms,
                  curve: Curves.easeOutCubic,
                );
          },
          childCount: articles.length,
        ),
      ),
    );
  }

  Widget _buildTopStorySection(
      BuildContext context, dynamic article, int index) {
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
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.grey4),
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
                style: AppTextStyles.body
                    .copyWith(color: AppColors.grey4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref
                      .read(topHeadlinesProvider('general').notifier)
                      .refresh();
                },
                icon:
                    const Icon(Icons.refresh_rounded, size: 18),
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

class _DesktopSidebar extends StatelessWidget {
  final List<String> categories;
  final String savedCount;

  const _DesktopSidebar({
    required this.categories,
    required this.savedCount,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.grey7,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.grid_view_rounded,
                    size: 14, color: AppColors.black),
              ),
              const SizedBox(width: 8),
              Text(
                'CATEGORIES',
                style: AppTextStyles.label.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories
                .map((cat) => ActionChip(
                      label: Text(
                        cat[0].toUpperCase() + cat.substring(1),
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 11,
                          color: AppColors.black,
                        ),
                      ),
                      backgroundColor: AppColors.grey7,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8),
                        side: const BorderSide(
                            color: AppColors.grey6),
                      ),
                      onPressed: () => context
                          .push('/category/$cat'),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.grey6),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.grey7,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.bookmark_rounded,
                    size: 14, color: AppColors.black),
              ),
              const SizedBox(width: 8),
              Text(
                'SAVED ARTICLES',
                style: AppTextStyles.label.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            savedCount,
            style: AppTextStyles.display.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => context.go('/bookmarks'),
            child: Text(
              'View all saved →',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.grey4,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Divider(color: AppColors.grey6),
          const SizedBox(height: 16),
          Text(
            'Swen v1.0.0',
            style: AppTextStyles.caption
                .copyWith(color: AppColors.grey5),
          ),
        ],
      ),
    );
  }
}
