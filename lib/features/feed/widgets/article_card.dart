import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:swen/core/utils/platform_utils.dart';
import '../../../core/models/article.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null) _buildImage(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMetadata(),
                  const SizedBox(height: 8),
                  _buildTitle(),
                  if (article.description != null) ...[
                    const SizedBox(height: 6),
                    _buildDescription(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: CachedNetworkImage(
          imageUrl: article.imageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.grey7,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
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
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetadata() {
    return Row(
      children: [
        if (article.sourceName != null) ...[
          Flexible(
            child: Text(
              article.sourceName!.toUpperCase(),
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
          DateFormatter.formatPublishedDate(article.publishedAt),
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      article.title,
      style: AppTextStyles.headline,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      article.description!,
      style: AppTextStyles.body,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
