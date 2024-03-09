import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kgf_app/common/styles/disabled_style.dart';
import 'package:kgf_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:kgf_app/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:kgf_app/utils/constants/colors.dart';
import 'package:kgf_app/utils/constants/image_strings.dart';
import 'package:kgf_app/utils/constants/sizes.dart';
import 'package:kgf_app/utils/helpers/helper_functions.dart';

class TSingleSession extends StatefulWidget {
  const TSingleSession({
    super.key,
    required this.selectedSession,
    this.disabled = false,
    this.iconsDisabled = false,
  });

  final bool selectedSession;
  final bool? disabled;
  final bool? iconsDisabled;

  @override
  _TSingleSessionState createState() => _TSingleSessionState();
}

class _TSingleSessionState extends State<TSingleSession> {
  late bool _selectedSession;

  @override
  void initState() {
    super.initState();
    _selectedSession = widget.selectedSession;
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
    final Color joinIconColor = widget.iconsDisabled!
        ? Theme.of(context).disabledColor
        : dark
            ? TColors.light
            : TColors.dark;
    final Color leaveIconColor = widget.iconsDisabled!
        ? Theme.of(context).disabledColor
        : dark
            ? _selectedSession
                ? TColors.light
                : TColors.light.withOpacity(0.5)
            : _selectedSession
                ? TColors.dark
                : TColors.dark.withOpacity(0.5);
    return TRoundedContainer(
      showBorder: true,
      padding: const EdgeInsets.only(
          top: TSizes.md, right: TSizes.md, left: TSizes.md),
      width: double.infinity,
      backgroundColor: Colors.transparent,
      borderColor: dark ? TColors.darkerGrey : TColors.grey,
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Functional Fitness",
                style: disabledTitleLargeStyle ??
                    Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: TSizes.sm / 2),
              Text(
                "17:00 - 18:00",
                style: disabledTitleSmallStyle ??
                    Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: TSizes.sm / 2),
              Text(
                "x/15 occupied",
                style: disabledTitleSmallStyle ??
                    Theme.of(context).textTheme.titleSmall,
              ),
              TUserProfileTile(
                image: TImages.userIcon,
                width: 40,
                height: 40,
                padding: 0,
                color: profileTileColor,
                title: 'Kulcsar Zoltan',
                subtitle: 'Coach',
              ),
            ],
          ),
          Positioned(
            top: 25,
            right: 5,
            child: GestureDetector(
              onTap: widget.iconsDisabled ?? false
                  ? () {}
                  : () {
                      setState(() {
                        _selectedSession = true;
                      });
                    },
              child: Icon(
                _selectedSession
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.check_mark_circled,
                size: 40,
                color: joinIconColor,
              ),
            ),
          ),
          Positioned(
            top: 75,
            right: 5,
            child: GestureDetector(
              onTap: widget.iconsDisabled ?? false
                  ? () {}
                  : () {
                      setState(() {
                        _selectedSession = false;
                      });
                    },
              child: Icon(
                CupertinoIcons.clear_circled,
                size: 40,
                color: leaveIconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
