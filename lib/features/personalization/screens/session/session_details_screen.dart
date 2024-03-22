import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:kgf_app/common/styles/disabled_style.dart";
import "package:kgf_app/common/widgets/appbar/appbar.dart";
import "package:kgf_app/common/widgets/buttons/toggle_switch_button.dart";
import "package:kgf_app/common/widgets/list_tiles/settings_menu_tile.dart";
import "package:kgf_app/common/widgets/list_tiles/user_profile_tile.dart";
import "package:kgf_app/common/widgets/texts/section_heading.dart";
import "package:kgf_app/features/personalization/controllers/attendance_controller.dart";
import "package:kgf_app/features/personalization/controllers/session_controller.dart";
import "package:kgf_app/features/personalization/controllers/user_controller.dart";
import "package:kgf_app/features/personalization/models/session_model.dart";
import "package:kgf_app/features/personalization/screens/session/add_new_session.dart";
import "package:kgf_app/utils/constants/colors.dart";
import "package:kgf_app/utils/constants/image_strings.dart";
import "package:kgf_app/utils/constants/sizes.dart";
import "package:kgf_app/utils/helpers/helper_functions.dart";

class SessionDetailsScreen extends StatefulWidget {
  SessionDetailsScreen({
    super.key,
    this.disabledButtons = false,
    required this.selectedSession,
    required this.session,
  }) : bringAFriend = RxBool(false);

  final bool? disabledButtons;
  final SessionModel session;
  final bool selectedSession;
  final RxBool bringAFriend;

  @override
  _SessionDetailsState createState() => _SessionDetailsState();
}

class _SessionDetailsState extends State<SessionDetailsScreen> {
  late bool _selectedSession;

  @override
  void initState() {
    super.initState();
    _selectedSession = widget.selectedSession;
  }

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
    final ButtonStyle? disabledOutlinedButtonStyle =
        DisabledStyle.getDisabledButtonStyle(
            context, OutlinedButton.styleFrom());
    final ButtonStyle? disabledElevatedButtonStyle =
        DisabledStyle.getDisabledButtonStyle(
            context, ElevatedButton.styleFrom());
    final userController = UserController.instance;
    final sessionController = SessionController.instance;
    final attendanceController = AttendanceController.instance;
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
                              .deleteSessionWarningPopup(widget.session.id),
                          icon: const Icon(CupertinoIcons.delete)),
                      IconButton(
                          onPressed: () async => (widget.session.repeatId ==
                                      "" ||
                                  widget.session.repeatId == null)
                              ? {
                                  await sessionController
                                      .setUpEditSession(widget.session.id),
                                  Get.to(
                                    () => AddNewSessionScreen(
                                      sessionId: widget.session.id,
                                      repeatId: widget.session.repeatId,
                                      editAllRepeat: false,
                                    ),
                                  ),
                                }
                              : sessionController.editSessionChoosePopup(
                                  widget.session.id, widget.session.repeatId!),
                          icon: const Icon(Iconsax.edit)),
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
              if (userController.user.value.role == "COACH" ||
                  userController.user.value.role == "ADMIN")
                ToggleSwitchButton(sessionId: widget.session.id),
              if (userController.user.value.role == "COACH" ||
                  userController.user.value.role == "ADMIN")
                const Divider(),
              Image(
                height: 60,
                image: AssetImage(
                    dark ? TImages.darkAppLogo : TImages.lightAppLogo),
              ),
              TSectionHeading(
                title: widget.session.title,
                showActionButton: false,
              ),
              TSettingsMenuTile(
                icon: Iconsax.clock,
                title: "Time",
                subTitle:
                    "${widget.session.fromTime} - ${widget.session.toTime}",
                onTap: null,
              ),
              FutureBuilder(
                future: _getOccupied(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching occupied seats count');
                  } else {
                    return TSettingsMenuTile(
                      icon: Iconsax.people,
                      title: "Occupied",
                      subTitle: "${snapshot.data}/${widget.session.maxPeople}",
                      onTap: null,
                    );
                  }
                },
              ),
              TSettingsMenuTile(
                icon: CupertinoIcons.chevron_right,
                title: "Minimum People",
                subTitle: "${widget.session.minPeople}",
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
                future: _fetchUserData(widget.session.userId),
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
              if (widget.session.bringAFriend == true) const Divider(),
              if (widget.session.bringAFriend == true)
                Row(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: Obx(
                        () => Checkbox(
                          value: attendanceController.bringAFriend.value,
                          onChanged: widget.disabledButtons ?? true
                              ? null
                              : _selectedSession
                                  ? null
                                  : (value) => attendanceController
                                          .bringAFriend.value =
                                      !attendanceController.bringAFriend.value,
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems / 2),
                    const TSectionHeading(
                      title: "Bring a friend?",
                      showActionButton: false,
                    ),
                  ],
                ),
              if (widget.session.bringAFriend == true)
                const SizedBox(height: TSizes.spaceBtwItems),
              if (widget.session.bringAFriend == false)
                const SizedBox(height: TSizes.spaceBtwSections),
              Padding(
                padding: const EdgeInsets.all(TSizes.spaceBtwItems),
                child: Row(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: _getOccupied(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text(
                                'Error fetching occupied seats count');
                          } else {
                            return ElevatedButton(
                              onPressed: snapshot.data! >=
                                          widget.session.maxPeople ||
                                      _selectedSession ||
                                      widget.disabledButtons == true
                                  ? () {}
                                  : () async {
                                      sessionController.refreshData.toggle();
                                      await attendanceController
                                          .addNewAttendance(
                                        widget.session.id,
                                        widget.session.date,
                                        attendanceController.bringAFriend.value,
                                      );
                                      setState(() {
                                        _selectedSession = true;
                                      });
                                    },
                              style:
                                  snapshot.data! >= widget.session.maxPeople ||
                                          _selectedSession ||
                                          widget.disabledButtons == true
                                      ? disabledElevatedButtonStyle
                                      : null,
                              child: const Text('JOIN'),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: !_selectedSession ||
                                widget.disabledButtons == true
                            ? () {}
                            : () async {
                                sessionController.refreshData.toggle();
                                await attendanceController
                                    .deleteAttendanceBySessionIdUserIdAndDate(
                                  widget.session.id,
                                  widget.session.date,
                                  attendanceController.bringAFriend.value,
                                );
                                attendanceController.bringAFriend.value = false;
                                setState(() {
                                  _selectedSession = false;
                                });
                              },
                        style:
                            !_selectedSession || widget.disabledButtons == true
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

  Future<int> _getOccupied() async {
    final occupiedString = await SessionController.instance
        .getSessionSingleField(widget.session.id, "Occupied");
    return int.parse(occupiedString);
  }
}
