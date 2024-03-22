import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kgf_app/common/styles/disabled_style.dart';
import 'package:kgf_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:kgf_app/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:kgf_app/features/personalization/controllers/attendance_controller.dart';
import 'package:kgf_app/features/personalization/controllers/session_controller.dart';
import 'package:kgf_app/features/personalization/controllers/user_controller.dart';
import 'package:kgf_app/features/personalization/models/session_model.dart';
import 'package:kgf_app/utils/constants/colors.dart';
import 'package:kgf_app/utils/constants/image_strings.dart';
import 'package:kgf_app/utils/constants/sizes.dart';
import 'package:kgf_app/utils/helpers/helper_functions.dart';

class TSingleSession extends StatefulWidget {
  const TSingleSession({
    super.key,
    required this.selectedSession,
    required this.session,
    this.disabled = false,
    this.iconsDisabled = false,
  });

  final bool selectedSession;
  final bool? disabled;
  final bool? iconsDisabled;
  final SessionModel session;

  @override
  _TSingleSessionState createState() => _TSingleSessionState();
}

class _TSingleSessionState extends State<TSingleSession> {
  late bool _selectedSession;
  late Future<Map<String, dynamic>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _selectedSession = widget.selectedSession;
    _userDataFuture = _fetchUserData(widget.session.userId);
  }

  Future<Map<String, dynamic>> _fetchUserData(String userId) async {
    final profilePicture = await UserController.instance
        .getUserSingleField(userId, 'ProfilePicture');
    final name =
        '${await UserController.instance.getUserSingleField(userId, 'FirstName')} ${await UserController.instance.getUserSingleField(userId, 'LastName')}';
    final role =
        await UserController.instance.getUserSingleField(userId, 'Role');

    return {
      'ProfilePicture': profilePicture,
      'Name': name,
      'Role': role,
    };
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final TextStyle? disabledTitleLargeStyle =
        DisabledStyle.getDisabledTextStyle(
            context, widget.disabled!, Theme.of(context).textTheme.titleLarge);
    final TextStyle? disabledTitleSmallStyle =
        DisabledStyle.getDisabledTextStyle(
            context, widget.disabled!, Theme.of(context).textTheme.titleSmall);
    final Color profileTileColor = widget.disabled!
        ? Theme.of(context).disabledColor
        : dark
            ? TColors.white
            : TColors.dark;
    final attendanceController = AttendanceController.instance;
    final sessionController = SessionController.instance;
    return FutureBuilder<Map<String, dynamic>>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching user data'));
        } else {
          final userData = snapshot.data!;
          final networkImage = userData['ProfilePicture'] ?? '';
          final name = userData['Name'] ?? '';
          final role = userData['Role'] ?? '';

          return TRoundedContainer(
            showBorder: true,
            padding: const EdgeInsets.only(
                top: TSizes.md, right: TSizes.md, left: TSizes.md),
            width: double.infinity,
            backgroundColor: _selectedSession
                ? TColors.primary.withOpacity(0.5)
                : Colors.transparent,
            borderColor: _selectedSession
                ? Colors.transparent
                : dark
                    ? TColors.darkerGrey
                    : TColors.grey,
            margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.session.title,
                      style: disabledTitleLargeStyle ??
                          Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: TSizes.sm / 2),
                    Text(
                      "${widget.session.fromTime} - ${widget.session.toTime}",
                      style: disabledTitleSmallStyle ??
                          Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: TSizes.sm / 2),
                    FutureBuilder(
                      future: _getOccupied(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text(
                              'Error fetching occupied seats count');
                        } else {
                          return Text(
                            "${snapshot.data}/${widget.session.maxPeople} occupied",
                            style: disabledTitleSmallStyle ??
                                Theme.of(context).textTheme.titleSmall,
                          );
                        }
                      },
                    ),
                    TUserProfileTile(
                      image: networkImage.isNotEmpty
                          ? networkImage
                          : TImages.userIcon,
                      width: 40,
                      height: 40,
                      padding: 0,
                      color: profileTileColor,
                      title: name,
                      subtitle: role,
                      isNetworkImage: networkImage.isNotEmpty,
                    ),
                  ],
                ),
                Positioned(
                  top: 25,
                  right: 5,
                  child: FutureBuilder(
                    future: _getOccupied(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text(
                            'Error fetching occupied seats count');
                      } else {
                        return GestureDetector(
                          onTap: snapshot.data! >= widget.session.maxPeople ||
                                  _selectedSession ||
                                  widget.iconsDisabled == true
                              ? () {}
                              : () async {
                                  sessionController.refreshData.toggle();
                                  await attendanceController.addNewAttendance(
                                    widget.session.id,
                                    widget.session.date,
                                    attendanceController.bringAFriend.value,
                                  );
                                  setState(() {
                                    _selectedSession = true;
                                  });
                                },
                          child: Icon(
                            _selectedSession
                                ? CupertinoIcons.check_mark_circled_solid
                                : CupertinoIcons.check_mark_circled,
                            size: 40,
                            color: snapshot.data! >= widget.session.maxPeople ||
                                    widget.iconsDisabled!
                                ? Theme.of(context).disabledColor
                                : dark
                                    ? TColors.light
                                    : TColors.dark,
                          ),
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 75,
                  right: 5,
                  child: GestureDetector(
                    onTap: !_selectedSession || widget.iconsDisabled == true
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
                    child: Icon(
                      CupertinoIcons.clear_circled,
                      size: 40,
                      color: widget.iconsDisabled!
                          ? Theme.of(context).disabledColor
                          : dark
                              ? _selectedSession
                                  ? TColors.light
                                  : TColors.light.withOpacity(0.5)
                              : _selectedSession
                                  ? TColors.dark
                                  : TColors.dark.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<int> _getOccupied() async {
    final occupiedString = await SessionController.instance
        .getSessionSingleField(widget.session.id, "Occupied");
    return int.parse(occupiedString);
  }
}
