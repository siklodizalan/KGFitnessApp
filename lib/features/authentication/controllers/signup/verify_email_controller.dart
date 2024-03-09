import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kgf_app/common/widgets/success_screen/success_screen.dart';
import 'package:kgf_app/data/repositories/authentication/authentication_repository.dart';
import 'package:kgf_app/utils/constants/image_strings.dart';
import 'package:kgf_app/utils/constants/text_strings.dart';
import 'package:kgf_app/utils/helpers/helper_functions.dart';
import 'package:kgf_app/utils/popups/loaders.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  @override
  void onInit() {
    sendEmailVerfification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  sendEmailVerfification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerfification();
      TLoaders.successSnackBar(
          title: 'Email Sent!',
          message: 'Please check your inbox and verify your email.');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  setTimerForAutoRedirect() {
    final dark = THelperFunctions.isDarkMode(Get.context!);
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(
          () => SuccessScreen(
            image: dark ? TImages.darkKGFImage : TImages.ligthKGFImage,
            title: TTexts.yourAccountCreatedTitle,
            subtitle: TTexts.yourAccountCreatedSubTitle,
            onPressed: () => AuthenticationRepository.instance.screenRedirect(),
          ),
        );
      }
    });
  }

  checkEmailVerificationStatus() async {
    final dark = THelperFunctions.isDarkMode(Get.context!);
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
        () => SuccessScreen(
          image: dark ? TImages.darkKGFImage : TImages.ligthKGFImage,
          title: TTexts.yourAccountCreatedTitle,
          subtitle: TTexts.yourAccountCreatedSubTitle,
          onPressed: () => AuthenticationRepository.instance.screenRedirect(),
        ),
      );
    }
  }
}
