import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kgf_app/data/repositories/authentication/authentication_repository.dart';
import 'package:kgf_app/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:kgf_app/utils/constants/image_strings.dart';
import 'package:kgf_app/utils/helpers/network_manager.dart';
import 'package:kgf_app/utils/popups/full_screen_loader.dart';
import 'package:kgf_app/utils/popups/loaders.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  sendPasswordResetEmail() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Processing your request...", TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!forgetPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(
          title: 'Email Sent!',
          message: 'Email Link Sent to Reset your Password.'.tr);

      Get.to(() => ResetPassword(email: email.text.trim()));
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Processing your request...", TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(
          title: 'Email Sent!',
          message: 'Email Link Sent to Reset your Password.'.tr);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
