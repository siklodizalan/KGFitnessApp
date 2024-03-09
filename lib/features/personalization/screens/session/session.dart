import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:kgf_app/features/personalization/screens/session/session_details_screen.dart';
import "package:kgf_app/features/personalization/screens/session/widgets/single_session.dart";
import "package:kgf_app/utils/constants/sizes.dart";

class UserSessionScreen extends StatelessWidget {
  const UserSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Get.to(() => const SessionDetailsScreen(
                  disabledButtons: false,
                  bringAFriend: true,
                )),
            child: const TSingleSession(
              selectedSession: false,
              disabled: false,
              iconsDisabled: false,
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(() => const SessionDetailsScreen(
                  disabledButtons: true,
                  bringAFriend: true,
                )),
            child: const TSingleSession(
              selectedSession: true,
              disabled: true,
              iconsDisabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
