import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kgf_app/common/widgets/loaders/shimmer.dart';

class TCircluarImage extends StatelessWidget {
  const TCircluarImage({
    super.key,
    required this.image,
    this.width = 40,
    this.height = 40,
    this.padding = 0,
    this.isNetworkImage = false,
  });

  final String image;
  final double width;
  final double height;
  final double padding;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetworkImage
              ? CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: image,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const TShimmerEffect(width: 50, height: 50, radius: 50),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Image(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
