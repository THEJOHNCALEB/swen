import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/models/api_response.dart';
import '../../core/widgets/doodle_background.dart';
import '../../core/widgets/empty_state_illustration.dart';
import '../../core/widgets/swen_brand.dart';
import '../../providers/bookmarks_provider.dart';
import '../feed/widgets/article_card.dart';
import '../feed/widgets/article_card_skeleton.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksState = ref.watch(bookmarksProvider);

    return DoodleBackground(
      opacity: 0.025,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
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
                          Icons.bookmark_rounded,
                          size: 14,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SAVED',
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
            Expanded(
              child: _buildBody(context, ref, bookmarksState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ApiResponse bookmarksState,
  ) {
    return switch (bookmarksState) {
      ApiLoading() => _buildLoadingState(),
      ApiSuccess(data: final bookmarks) => _buildSuccessState(
          context,
          ref,
          bookmarks,
        ),
      ApiError(message: final message) => _buildErrorState(message),
    };
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
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
    List bookmarks,
  ) {
    if (bookmarks.isEmpty) {
      return const Center(
        child: EmptyStateIllustration(
          icon: Icons.bookmark_border_rounded,
          message: 'No bookmarks yet',
          subtitle: 'Save articles to read them later',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(bookmarksProvider.notifier).loadBookmarks();
      },
      color: AppColors.black,
      backgroundColor: AppColors.surface,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: bookmarks.length,
        itemBuilder: (context, index) {
          final article = bookmarks[index];
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
