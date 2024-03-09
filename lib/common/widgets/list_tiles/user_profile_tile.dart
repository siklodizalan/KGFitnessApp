import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kgf_app/common/widgets/custom_shapes/containers/circular_image.dart';
import 'package:kgf_app/common/widgets/loaders/shimmer.dart';
import 'package:kgf_app/features/personalization/controllers/user_controller.dart';
import 'package:kgf_app/utils/constants/colors.dart';

class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({
    super.key,
    required this.title,
    this.subtitle, // Making subtitle optional
    required this.image,
    this.isNetworkImage = false,
    this.width = 40,
    this.height = 40,
    this.padding = 0,
    this.color = TColors.white,
    this.trailing,
  });

  final String image;
  final double width;
  final double height;
  final double padding;
  final Color color;
  final String title;
  final String? subtitle; // Making subtitle nullable
  final Widget? trailing;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return ListTile(
      leading: Obx(
        () {
          return controller.imageUploading.value
              ? const TShimmerEffect(width: 50, height: 50, radius: 50)
              : TCircluarImage(
                  image: image,
                  width: width,
                  height: height,
                  padding: padding,
                  isNetworkImage: isNetworkImage,
                );
        },
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall!.apply(color: color),
      ),
      subtitle: subtitle != null
          ? FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                subtitle!,
                style:
                    Theme.of(context).textTheme.bodyMedium!.apply(color: color),
              ),
            )
          : null,
      trailing: trailing,
    );
  }
}
