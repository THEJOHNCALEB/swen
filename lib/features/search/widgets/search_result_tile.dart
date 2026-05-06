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

class SearchResultTile extends StatefulWidget {
  final Article article;
  final VoidCallback onTap;

  const SearchResultTile({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  State<SearchResultTile> createState() => _SearchResultTileState();
}

class _SearchResultTileState extends State<SearchResultTile> {
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    _hovered ? AppColors.grey7 : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMetadata(),
                        const SizedBox(height: 6),
                        _buildTitle(),
                        if (widget.article.description != null) ...[
                          const SizedBox(height: 4),
                          _buildDescription(),
                        ],
                      ],
                    ),
                  ),
                  if (widget.article.imageUrl != null) ...[
                    const SizedBox(width: 12),
                    _buildThumbnail(),
                  ],
                ],
              ),
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
              style: AppTextStyles.caption,
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
      style: AppTextStyles.headline,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.article.description!,
      style: AppTextStyles.body,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 80,
        height: 80,
        child: CachedNetworkImage(
          imageUrl: widget.article.imageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.grey7,
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.grey7,
            child: const Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.grey4,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
