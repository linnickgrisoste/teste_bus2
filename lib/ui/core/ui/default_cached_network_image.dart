import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:teste_bus2/ui/core/styles/app_colors.dart';

class DefaultCachedNetworkImage extends StatelessWidget {
  final BoxFit fit;
  final double size;
  final String imageUrl;

  const DefaultCachedNetworkImage({super.key, required this.imageUrl, required this.size, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildErrorWidget();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: fit),
        ),
      ),
      placeholder: (context, url) => SizedBox(
        width: size,
        height: size,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (context, url, error) {
        return _buildErrorWidget();
      },
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
      maxHeightDiskCache: 500,
      maxWidthDiskCache: 500,
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.grey200),
      child: Icon(Icons.person, size: size * 0.5, color: AppColors.textHint),
    );
  }
}
