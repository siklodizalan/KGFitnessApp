import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kgf_app/data/repositories/authentication/authentication_repository.dart';
import 'package:kgf_app/data/repositories/user/user_repository.dart';
import 'package:kgf_app/features/authentication/screens/login/login.dart';
import 'package:kgf_app/features/personalization/models/user_model.dart';
import 'package:kgf_app/features/personalization/screens/profile/widgets/re_authenticate_user_login_form.dart';
import 'package:kgf_app/utils/constants/image_strings.dart';
import 'package:kgf_app/utils/constants/sizes.dart';
import 'package:kgf_app/utils/helpers/network_manager.dart';
import 'package:kgf_app/utils/popups/full_screen_loader.dart';
import 'package:kgf_app/utils/popups/loaders.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final hidePassword = false.obs;
  final imageUploading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  Future<String> getUserSingleField(String userId, String fieldName) async {
    try {
      return await userRepository.fetchUserSingleField(userId, fieldName);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'User not found!', message: e.toString());
      return '';
    }
  }

  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      await fetchUserRecord();

      if (user.value.id.isEmpty) {
        if (userCredentials != null) {
          final nameParts =
              UserModel.nameParts(userCredentials.user!.displayName ?? '');

          final user = UserModel(
            id: userCredentials.user!.uid,
            firstName: nameParts[0],
            lastName:
                nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
            email: userCredentials.user!.email ?? '',
            phoneNumber: userCredentials.user!.phoneNumber ?? '',
            profilePicture: userCredentials.user!.photoURL ?? '',
          );

          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      TLoaders.warningSnackBar(
        title: 'Data not saved.',
        message:
            'Something went wrong while saving your information. You can re-save your data in your Profile.',
      );
    }
  }

  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: 'Delete Account',
      middleText:
          'Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently.',
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Delete'),
        ),
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Text('Cancel'),
      ),
    );
  }

  void deleteUserAccount() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Processing...', TImages.docerAnimation);

      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          TFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password') {
          TFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Processing...', TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
              verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      TFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        imageUploading.value = true;

        final imageUrl =
            await userRepository.uploadImage('Users/Images/Profile/', image);

        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();

        TLoaders.successSnackBar(
            title: 'Congratulations!',
            message: 'Your Profile Picture has been updated!');
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Oh Snap!', message: 'Something went wrong $e');
    } finally {
      imageUploading.value = false;
    }
  }
}
