import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:kgf_app/features/personalization/controllers/user_controller.dart";
import "package:kgf_app/features/personalization/screens/admin/admin.dart";
import 'package:kgf_app/features/personalization/screens/session/session_signup.dart';
import 'package:kgf_app/features/personalization/screens/profile/profile.dart';
import "package:kgf_app/utils/constants/colors.dart";
import "package:kgf_app/utils/helpers/helper_functions.dart";

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final userController = UserController.instance;
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? TColors.black : Colors.white,
          indicatorColor: darkMode
              ? TColors.white.withOpacity(0.1)
              : TColors.black.withOpacity(0.1),
          destinations: userController.user.value.role == "ADMIN"
              ? const [
                  NavigationDestination(
                      icon: Icon(Iconsax.home), label: 'Today'),
                  NavigationDestination(
                      icon: Icon(Iconsax.user), label: 'Profile'),
                  NavigationDestination(
                      icon: Icon(Iconsax.computing), label: 'Admin'),
                ]
              : const [
                  NavigationDestination(
                      icon: Icon(Iconsax.home), label: 'Today'),
                  NavigationDestination(
                      icon: Icon(Iconsax.user), label: 'Profile'),
                ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  late final UserController userController;
  late final Rx<int> selectedIndex;
  late final List<Widget> screens;

  NavigationController() {
    userController = UserController.instance;
    selectedIndex = 0.obs;
    screens = userController.user.value.role == "ADMIN"
        ? [
            const SessionSignupScreen(),
            const ProfileScreen(),
            const AdminScreen(),
          ]
        : [
            const SessionSignupScreen(),
            const ProfileScreen(),
          ];
  }
}
