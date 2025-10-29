import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DefaultCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final BoxFit fit;

  const DefaultCachedNetworkImage({super.key, required this.imageUrl, required this.size, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
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
      errorWidget: (context, url, error) => Icon(Icons.person, size: size * 0.6, color: Colors.grey[600]),
    );
  }
}
