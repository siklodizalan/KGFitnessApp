import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:kgf_app/common/styles/disabled_style.dart";
import "package:kgf_app/common/widgets/appbar/appbar.dart";
import "package:kgf_app/common/widgets/list_tiles/settings_menu_tile.dart";
import "package:kgf_app/common/widgets/list_tiles/user_profile_tile.dart";
import "package:kgf_app/common/widgets/texts/section_heading.dart";
import "package:kgf_app/features/personalization/controllers/session_controller.dart";
import "package:kgf_app/features/personalization/controllers/user_controller.dart";
import "package:kgf_app/features/personalization/models/session_model.dart";
import "package:kgf_app/utils/constants/colors.dart";
import "package:kgf_app/utils/constants/image_strings.dart";
import "package:kgf_app/utils/constants/sizes.dart";
import "package:kgf_app/utils/helpers/helper_functions.dart";

class SessionDetailsScreen extends StatelessWidget {
  const SessionDetailsScreen({
    super.key,
    this.disabledButtons = false,
    required this.session,
  });

  final bool? disabledButtons;
  final SessionModel session;

  Future<Map<String, dynamic>> _fetchUserData(String userId) async {
    final profilePicture = await UserController.instance
        .getUserSingleField(userId, 'ProfilePicture');
    final name =
        '${await UserController.instance.getUserSingleField(userId, 'FirstName')} ${await UserController.instance.getUserSingleField(userId, 'LastName')}';

    return {
      'ProfilePicture': profilePicture,
      'Name': name,
    };
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final ButtonStyle? disabledElevatedButtonStyle =
        DisabledStyle.getDisabledButtonStyle(
            context, disabledButtons!, ElevatedButton.styleFrom());
    final ButtonStyle? disabledOutlinedButtonStyle =
        DisabledStyle.getDisabledButtonStyle(
            context, disabledButtons!, OutlinedButton.styleFrom());
    final userController = UserController.instance;
    final sessionController = SessionController.instance;
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
              if (userController.user.value.role == "COACH" ||
                  userController.user.value.role == "ADMIN") {
                return Container(
                  padding: const EdgeInsets.all(TSizes.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () => sessionController
                              .deleteSessionWarningPopup(session.id),
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
                title: session.title,
                showActionButton: false,
              ),
              TSettingsMenuTile(
                icon: Iconsax.clock,
                title: "Time",
                subTitle: "${session.fromTime} - ${session.toTime}",
                onTap: null,
              ),
              TSettingsMenuTile(
                icon: Iconsax.people,
                title: "Occupied",
                subTitle: "${session.occupied}/${session.maxPeople}",
                onTap: null,
              ),
              TSettingsMenuTile(
                icon: CupertinoIcons.chevron_right,
                title: "Minimum People",
                subTitle: "${session.minPeople}",
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
              FutureBuilder(
                future: _fetchUserData(session.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching user data');
                  } else {
                    final userData = snapshot.data!;
                    final networkImage = userData['ProfilePicture'];
                    final image = networkImage.isNotEmpty
                        ? networkImage
                        : TImages.userIcon;
                    final name = userData['Name'];
                    return TUserProfileTile(
                      image: image,
                      width: 50,
                      height: 50,
                      padding: 0,
                      title: name,
                      color: dark ? TColors.white : TColors.dark,
                      isNetworkImage: networkImage.isNotEmpty,
                    );
                  }
                },
              ),
              if (session.bringAFriend == true) const Divider(),
              if (session.bringAFriend == true)
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
              if (session.bringAFriend == true)
                const SizedBox(height: TSizes.spaceBtwItems),
              if (session.bringAFriend == false)
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
