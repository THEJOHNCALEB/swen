import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;

  static const _fallbackUrl =
      'https://plus.unsplash.com/premium_photo-1688561384438-bfa9273e2c00'
      '?fm=jpg&q=60&w=3000&auto=format&fit=crop'
      '&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bmV3c3xlbnwwfHwwfHx8MA%3D%3D';

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        cacheWidth: width?.toInt(),
        cacheHeight: height?.toInt(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          if (placeholder != null) return placeholder!(context, imageUrl);
          return Container(color: AppColors.grey7);
        },
        errorBuilder: (context, error, stackTrace) {
          if (errorWidget != null) return errorWidget!(context, imageUrl, error);
          return Image.network(
            _fallbackUrl,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppColors.grey7,
              child: const Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.grey4,
              ),
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(color: AppColors.grey7);
            },
          );
        },
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder: placeholder ??
          (context, url) => Container(color: AppColors.grey7),
      errorWidget: errorWidget ??
          (context, url, error) => Container(
                color: AppColors.grey7,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.grey4,
                ),
              ),
    );
  }
}
