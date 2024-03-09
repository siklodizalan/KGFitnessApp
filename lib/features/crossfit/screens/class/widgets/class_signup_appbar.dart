import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kgf_app/common/widgets/appbar/add_class_icon.dart';
import 'package:kgf_app/common/widgets/appbar/appbar.dart';
import 'package:kgf_app/common/widgets/loaders/shimmer.dart';
import 'package:kgf_app/features/personalization/controllers/user_controller.dart';
import 'package:kgf_app/features/personalization/screens/session/add_new_session.dart';
import 'package:kgf_app/utils/constants/colors.dart';
import 'package:kgf_app/utils/constants/sizes.dart';
import 'package:kgf_app/utils/constants/text_strings.dart';

class TClassSignupAppBar extends StatelessWidget {
  const TClassSignupAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TTexts.classSignupAppbarTitle,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: TColors.grey),
          ),
          const SizedBox(height: TSizes.sm / 2),
          Obx(
            () {
              if (controller.profileLoading.value) {
                return const TShimmerEffect(width: 80, height: 15);
              } else {
                return Text(
                  controller.user.value.fullName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .apply(color: TColors.white),
                );
              }
            },
          ),
        ],
      ),
      actions: [
        Obx(
          () {
            if (controller.user.value.role == "COACH" ||
                controller.user.value.role == "ADMIN") {
              if (controller.profileLoading.value) {
                return const TShimmerEffect(width: 55, height: 55, radius: 55);
              } else {
                return TAddClassIcon(
                  onPressed: () => Get.to(() => const AddNewSessionScreen()),
                );
              }
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }
}
