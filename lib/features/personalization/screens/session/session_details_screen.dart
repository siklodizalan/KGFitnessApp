import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:kgf_app/common/styles/disabled_style.dart";
import "package:kgf_app/common/widgets/appbar/appbar.dart";
import "package:kgf_app/common/widgets/list_tiles/settings_menu_tile.dart";
import "package:kgf_app/common/widgets/list_tiles/user_profile_tile.dart";
import "package:kgf_app/common/widgets/texts/section_heading.dart";
import "package:kgf_app/features/personalization/controllers/user_controller.dart";
import "package:kgf_app/utils/constants/colors.dart";
import "package:kgf_app/utils/constants/image_strings.dart";
import "package:kgf_app/utils/constants/sizes.dart";
import "package:kgf_app/utils/helpers/helper_functions.dart";

class SessionDetailsScreen extends StatelessWidget {
  const SessionDetailsScreen({
    super.key,
    this.sessionName = "Functional Fitness",
    this.sessionTime = "17:00 - 18:00",
    this.occupied = "x/15",
    this.minRequiredPeople = "3",
    this.userName = "Kulcsar Zoltan",
    this.userRole = "Coach",
    this.disabledButtons = false,
    this.bringAFriend = true,
  });

  final String sessionName;
  final String sessionTime;
  final String occupied;
  final String minRequiredPeople;
  final String userName;
  final String userRole;
  final bool? disabledButtons;
  final bool? bringAFriend;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final ButtonStyle? disabledElevatedButtonStyle =
        DisabledStyle.getDisabledButtonStyle(
            context, disabledButtons!, ElevatedButton.styleFrom());
    final ButtonStyle? disabledOutlinedButtonStyle =
        DisabledStyle.getDisabledButtonStyle(
            context, disabledButtons!, OutlinedButton.styleFrom());
    final controller = Get.put(UserController());
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Session Details',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          Obx(
            () {
              if (controller.user.value.role == "COACH" ||
                  controller.user.value.role == "ADMIN") {
                return Container(
                  padding: const EdgeInsets.all(TSizes.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.delete)),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Iconsax.edit)),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                height: 60,
                image: AssetImage(
                    dark ? TImages.darkAppLogo : TImages.lightAppLogo),
              ),
              TSectionHeading(
                title: sessionName,
                showActionButton: false,
              ),
              TSettingsMenuTile(
                icon: Iconsax.clock,
                title: "Time",
                subTitle: sessionTime,
                onTap: null,
              ),
              TSettingsMenuTile(
                icon: Iconsax.people,
                title: "Occupied",
                subTitle: occupied,
                onTap: null,
              ),
              TSettingsMenuTile(
                icon: CupertinoIcons.chevron_right,
                title: "Minimum People",
                subTitle: minRequiredPeople,
                onTap: null,
              ),
              const TSettingsMenuTile(
                icon: CupertinoIcons.waveform_path_ecg,
                title: "Workout of the Day",
                subTitle: "Coming Soon...",
                onTap: null,
                disabled: true,
              ),
              const Divider(),
              const TSectionHeading(
                title: "Coach",
                showActionButton: false,
              ),
              TUserProfileTile(
                image: TImages.userIcon,
                width: 50,
                height: 50,
                padding: 0,
                title: userName,
                color: dark ? TColors.white : TColors.dark,
              ),
              if (bringAFriend == true) const Divider(),
              if (bringAFriend == true)
                Row(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: Checkbox(
                        value: false,
                        onChanged: disabledButtons ?? true ? null : (value) {},
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems / 2),
                    const TSectionHeading(
                      title: "Bring a friend?",
                      showActionButton: false,
                    ),
                  ],
                ),
              if (bringAFriend == true)
                const SizedBox(height: TSizes.spaceBtwItems),
              if (bringAFriend == false)
                const SizedBox(height: TSizes.spaceBtwSections),
              Padding(
                padding: const EdgeInsets.all(TSizes.spaceBtwItems),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: disabledButtons ?? true ? null : () {},
                        style: disabledButtons ?? true
                            ? disabledElevatedButtonStyle
                            : null,
                        child: const Text('JOIN'),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: disabledButtons ?? true ? null : () {},
                        style: disabledButtons ?? true
                            ? disabledOutlinedButtonStyle
                            : null,
                        child: const Text('LEAVE'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
