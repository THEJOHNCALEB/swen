import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';

class ArticleCardSkeleton extends StatelessWidget {
  final bool isFeatured;

  const ArticleCardSkeleton({
    super.key,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isFeatured ? 16 : 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.grey6, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSkeleton(),
          Padding(
            padding: EdgeInsets.all(isFeatured ? 16 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetadataSkeleton(),
                SizedBox(height: isFeatured ? 12 : 8),
                _buildTitleSkeleton(),
                SizedBox(height: isFeatured ? 8 : 6),
                _buildDescriptionSkeleton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSkeleton() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: AspectRatio(
        aspectRatio: isFeatured ? 16 / 10 : 16 / 9,
        child: Shimmer.fromColors(
          baseColor: AppColors.grey7,
          highlightColor: AppColors.grey6,
          child: Container(
            color: AppColors.grey7,
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.grey7,
      highlightColor: AppColors.grey6,
      child: Row(
        children: [
          Container(
            width: 80,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.grey7,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 2,
            height: 2,
            decoration: const BoxDecoration(
              color: AppColors.grey7,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 60,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.grey7,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.grey7,
      highlightColor: AppColors.grey6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: isFeatured ? 18 : 14,
            decoration: BoxDecoration(
              color: AppColors.grey7,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            height: isFeatured ? 18 : 14,
            decoration: BoxDecoration(
              color: AppColors.grey7,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 200,
            height: isFeatured ? 18 : 14,
            decoration: BoxDecoration(
              color: AppColors.grey7,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.grey7,
      highlightColor: AppColors.grey6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.grey7,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 250,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.grey7,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
