import 'package:flutter/material.dart';
import 'package:kgf_app/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:kgf_app/utils/constants/colors.dart';
import 'package:kgf_app/utils/constants/sizes.dart';
import 'package:kgf_app/utils/device/device_utility.dart';
import 'package:kgf_app/utils/helpers/helper_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingDotNavigation extends StatelessWidget {
  const OnboardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Positioned(
        bottom: TDeviceUtils.getBottomNavigationBarHeight() + 25,
        left: TSizes.defaultSpace,
        child: SmoothPageIndicator(
            controller: controller.pageController,
            onDotClicked: controller.dotNavigationClick,
            count: 3,
            effect: ExpandingDotsEffect(
                activeDotColor: dark ? TColors.dark : TColors.light,
                dotHeight: 6)));
  }
}
