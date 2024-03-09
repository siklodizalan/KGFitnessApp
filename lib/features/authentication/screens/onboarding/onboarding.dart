import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kgf_app/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:kgf_app/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:kgf_app/features/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:kgf_app/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:kgf_app/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:kgf_app/utils/constants/image_strings.dart';
import 'package:kgf_app/utils/constants/text_strings.dart';
import 'package:kgf_app/utils/helpers/helper_functions.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body: Stack(
        children: [
          PageView(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndicator,
              children: [
                OnboardingPage(
                  image: THelperFunctions.isDarkMode(context)
                      ? TImages.darkKGFImage
                      : TImages.ligthKGFImage,
                  title: TTexts.onBoardingTitle1,
                  subTitle: TTexts.onBoardingSubTitle1,
                ),
                OnboardingPage(
                  image: THelperFunctions.isDarkMode(context)
                      ? TImages.darkKGFImage
                      : TImages.ligthKGFImage,
                  title: TTexts.onBoardingTitle2,
                  subTitle: TTexts.onBoardingSubTitle2,
                ),
                OnboardingPage(
                  image: THelperFunctions.isDarkMode(context)
                      ? TImages.darkKGFImage
                      : TImages.ligthKGFImage,
                  title: TTexts.onBoardingTitle3,
                  subTitle: TTexts.onBoardingSubTitle3,
                ),
              ]),
          const OnboardingSkip(),
          const OnboardingDotNavigation(),
          const OnboardingNextButton()
        ],
      ),
    );
  }
}
