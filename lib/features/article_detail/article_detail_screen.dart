import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swen/core/utils/platform_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/models/article.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/doodle_background.dart';
import '../../providers/bookmarks_provider.dart';

class ArticleDetailScreen extends ConsumerStatefulWidget {
  final Article article;

  const ArticleDetailScreen({
    super.key,
    required this.article,
  });

  @override
  ConsumerState<ArticleDetailScreen> createState() =>
      _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends ConsumerState<ArticleDetailScreen> {
  late WebViewController _webViewController;
  bool _isLoading = true;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
    _checkBookmarkStatus();
  }

  void _initWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.article.url));
  }

  Future<void> _checkBookmarkStatus() async {
    final isBookmarked = await ref
        .read(bookmarksProvider.notifier)
        .isBookmarked(widget.article.id);
    setState(() => _isBookmarked = isBookmarked);
  }

  Future<void> _toggleBookmark() async {
    await ref.read(bookmarksProvider.notifier).toggleBookmark(widget.article);
    await _checkBookmarkStatus();
  }

  void _shareArticle() {
    Share.share(
      '${widget.article.title}\n\n${widget.article.url}',
      subject: widget.article.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final layout = Responsive.of(context);
    final isWide = layout != ScreenLayout.mobile;
    final maxWidth = layout == ScreenLayout.tablet ? 720.0 : 760.0;

    final content = Column(
      children: [
        _buildAppBar(context),
        if (widget.article.imageUrl != null) _buildHeroImage(),
        _buildArticleHeader(),
        Expanded(
          child: Stack(
            children: [
              WebViewWidget(controller: _webViewController),
              if (_isLoading)
                Container(
                  color: AppColors.background,
                  child: Center(
                    child: PlatformUtils.adaptiveProgressIndicator(
                      color: AppColors.black,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: DoodleBackground(
        opacity: 0.02,
        child: SafeArea(
          child: isWide
              ? Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: content,
                  ),
                )
              : content,
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.grey6, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.grey7,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
              color: AppColors.black,
              onPressed: () => context.pop(),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  size: 22,
                ),
                color: AppColors.black,
                onPressed: _toggleBookmark,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.share, size: 22),
                color: AppColors.black,
                onPressed: _shareArticle,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: widget.article.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.grey7,
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.grey7,
        ),
      ),
    );
  }

  Widget _buildArticleHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.grey6, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.article.sourceName != null)
            Text(
              widget.article.sourceName!.toUpperCase(),
              style: AppTextStyles.caption,
            ),
          const SizedBox(height: 8),
          Text(
            widget.article.title,
            style: AppTextStyles.display,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (widget.article.author != null) ...[
                Text(
                  '${AppStrings.author} ${widget.article.author}',
                  style: AppTextStyles.caption,
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
          ),
        ],
      ),
    );
  }
}
