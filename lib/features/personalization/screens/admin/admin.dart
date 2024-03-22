import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:kgf_app/common/widgets/appbar/appbar.dart";
import "package:kgf_app/common/widgets/custom_shapes/containers/primary_header_container.dart";
import "package:kgf_app/common/widgets/texts/section_heading.dart";
import "package:kgf_app/features/personalization/controllers/user_controller.dart";
import "package:kgf_app/features/personalization/screens/profile/widgets/change_name.dart";
import "package:kgf_app/features/personalization/screens/profile/widgets/profile_menu.dart";
import "package:kgf_app/utils/constants/colors.dart";
import "package:kgf_app/utils/constants/sizes.dart";

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// -- Header
            TPrimaryHeaderContainer(
              expandable: false,
              initialHeight: 80,
              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      'Admin Dashboard',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: TColors.white),
                    ),
                  ),
                ],
              ),
            ),

            /// -- Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  /// -- Account Settings
                  const TSectionHeading(
                    title: "Personal Information",
                    showActionButton: false,
                  ),
                  TProfileMenu(
                    title: "Name",
                    value: controller.user.value.fullName,
                    onPressed: () => Get.to(() => const ChangeName()),
                  ),
                  TProfileMenu(
                    title: "E-mail",
                    value: controller.user.value.email,
                    onPressed: () {},
                  ),
                  const Divider(),
                  const TSectionHeading(
                    title: "Data and Privacy",
                    showActionButton: false,
                  ),
                  TProfileMenu(
                    icon: CupertinoIcons.delete,
                    title: "Delete my account",
                    onPressed: () => controller.deleteAccountWarningPopup(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
