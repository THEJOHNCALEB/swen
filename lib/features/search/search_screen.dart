import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/models/api_response.dart';
import '../../core/widgets/doodle_background.dart';
import '../../core/widgets/swen_brand.dart';
import '../../providers/search_provider.dart';
import 'widgets/swen_search_bar.dart';
import 'widgets/search_result_tile.dart';
import '../feed/widgets/article_card_skeleton.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);

    return DoodleBackground(
      opacity: 0.025,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: const SwenBrand(titleSize: 22, taglineSize: 10),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: SwenSearchBar(
                onSearch: (q) {
                  ref.read(searchQueryProvider.notifier).state = q;
                  ref.read(searchResultsProvider.notifier).search(q);
                },
                onClear: () {
                  ref.read(searchQueryProvider.notifier).state = '';
                  ref.read(searchResultsProvider.notifier).clear();
                },
              ),
            ),
            Expanded(
              child: _buildBody(context, ref, searchState, query),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ApiResponse searchState,
    String query,
  ) {
    if (query.isEmpty) {
      return _buildEmptySearch();
    }

    return switch (searchState) {
      ApiLoading() => _buildLoadingState(),
      ApiSuccess(data: final articles) => _buildSuccessState(
          context,
          articles,
        ),
      ApiError(message: final message) => _buildErrorState(message),
    };
  }

  Widget _buildEmptySearch() {
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
              Icons.search_rounded,
              size: 48,
              color: AppColors.grey5,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Discover stories',
            style: AppTextStyles.headline.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search for topics, sources, or keywords',
            style: AppTextStyles.caption.copyWith(
              fontSize: 13,
              color: AppColors.grey4,
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 6,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: ArticleCardSkeleton(),
        );
      },
    );
  }

  Widget _buildSuccessState(BuildContext context, List articles) {
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
                Icons.search_off_rounded,
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
            const SizedBox(height: 80),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SearchResultTile(
            article: article,
            onTap: () => context.push('/article', extra: article),
          ),
        )
            .animate()
            .fadeIn(
              duration: 300.ms,
              delay: (40 * index.clamp(0, 10)).ms,
            )
            .slideY(
              begin: 0.05,
              end: 0,
              duration: 300.ms,
              delay: (40 * index.clamp(0, 10)).ms,
              curve: Curves.easeOutCubic,
            );
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColors.grey4,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.body.copyWith(color: AppColors.grey4),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
