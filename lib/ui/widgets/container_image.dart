import 'package:cached_network_image/cached_network_image.dart';
import 'package:fake_store_app/config/constants.dart';
import 'package:flutter/material.dart';

class ContainerImage extends StatelessWidget {
  final String imageUrl;
  const ContainerImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          Image.asset(Constants.noImageAsset, fit: BoxFit.cover),
      fadeInDuration: const Duration(milliseconds: 150),
      fadeOutDuration: const Duration(milliseconds: 150),
    );
  }
}
