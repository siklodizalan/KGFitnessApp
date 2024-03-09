import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:kgf_app/common/widgets/appbar/appbar.dart";
import "package:kgf_app/common/widgets/custom_shapes/containers/primary_header_container.dart";
import "package:kgf_app/common/widgets/list_tiles/user_profile_tile.dart";
import "package:kgf_app/common/widgets/texts/section_heading.dart";
import "package:kgf_app/data/repositories/authentication/authentication_repository.dart";
import "package:kgf_app/features/personalization/controllers/user_controller.dart";
import "package:kgf_app/features/personalization/screens/profile/widgets/change_name.dart";
import "package:kgf_app/features/personalization/screens/profile/widgets/profile_menu.dart";
import "package:kgf_app/utils/constants/colors.dart";
import "package:kgf_app/utils/constants/image_strings.dart";
import "package:kgf_app/utils/constants/sizes.dart";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              initialHeight: 160,
              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      'Account',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: TColors.white),
                    ),
                  ),

                  /// -- User Profile Card
                  Obx(() {
                    final networkImage = controller.user.value.profilePicture;
                    final image = networkImage.isNotEmpty
                        ? networkImage
                        : TImages.userIcon;
                    return TUserProfileTile(
                      image: image,
                      width: 50,
                      height: 50,
                      padding: 0,
                      title: controller.user.value.fullName,
                      isNetworkImage: networkImage.isNotEmpty,
                      subtitle: controller.user.value.email,
                      trailing: IconButton(
                        onPressed: () => controller.uploadUserProfilePicture(),
                        icon: const Icon(CupertinoIcons.camera,
                            color: TColors.white),
                      ),
                    );
                  }),
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
                  /*
                  TProfileMenu(
                    title: "Phone",
                    value: controller.user.value.phoneNumber,
                    onPressed: () {},
                  ),
                  TProfileMenu(
                    title: "Gender",
                    value: "Male",
                    onPressed: () {},
                  ),
                  TProfileMenu(
                    title: "Date of Birth",
                    value: "19 Aug, 2002",
                    onPressed: () {},
                  ),
                  */
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
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          AuthenticationRepository.instance.logout(),
                      child: const Text('Logout'),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections * 2.5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
