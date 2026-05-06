import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/article.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/platform_utils.dart';
import '../../../providers/bookmarks_provider.dart';

class FeaturedArticleCard extends StatefulWidget {
  final Article article;
  final VoidCallback onTap;

  const FeaturedArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  State<FeaturedArticleCard> createState() => _FeaturedArticleCardState();
}

class _FeaturedArticleCardState extends State<FeaturedArticleCard> {
  bool _hovered = false;

  void _showContextMenu(BuildContext context, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          position.dx, position.dy, position.dx, position.dy),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.grey6)),
      items: [
        PopupMenuItem(
          child: const Text('Open Article'),
          onTap: () => context.push('/article',
              extra: widget.article),
        ),
        PopupMenuItem(
          child: Text(widget.article.isBookmarked
              ? 'Remove Bookmark'
              : 'Bookmark'),
          onTap: () {
            ProviderScope.containerOf(context)
                .read(bookmarksProvider.notifier)
                .toggleBookmark(widget.article);
          },
        ),
        PopupMenuItem(
          child: const Text('Copy Link'),
          onTap: () => Clipboard.setData(
              ClipboardData(text: widget.article.url)),
        ),
        PopupMenuItem(
          child: const Text('Share'),
          onTap: () => Share.share(
              '${widget.article.title}\n${widget.article.url}'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onSecondaryTapDown: PlatformUtils.isDesktopOrWeb
          ? (details) =>
              _showContextMenu(context, details.globalPosition)
          : null,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            context.push('/article', extra: widget.article);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          cursor: SystemMouseCursors.click,
          child: AnimatedScale(
            scale: _hovered && PlatformUtils.isDesktopOrWeb
                ? 1.005
                : 1.0,
            duration: const Duration(milliseconds: 150),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color:
                    _hovered ? AppColors.grey7 : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.article.imageUrl != null)
                    _buildImage(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMetadata(),
                        const SizedBox(height: 12),
                        _buildTitle(),
                        if (widget.article.description !=
                            null) ...[
                          const SizedBox(height: 8),
                          _buildDescription(),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(16)),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: CachedNetworkImage(
          imageUrl: widget.article.imageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.grey7,
            child: Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: PlatformUtils.adaptiveProgressIndicator(
                  color: AppColors.grey4,
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.grey7,
            child: const Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.grey4,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetadata() {
    return Row(
      children: [
        if (widget.article.sourceName != null) ...[
          Flexible(
            child: Text(
              widget.article.sourceName!.toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 2,
            height: 2,
            decoration: const BoxDecoration(
              color: AppColors.grey4,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          DateFormatter.formatPublishedDate(
              widget.article.publishedAt),
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.article.title,
      style: AppTextStyles.display,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.article.description!,
      style: AppTextStyles.body,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
