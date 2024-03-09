import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kgf_app/data/repositories/session/session_repository.dart';
import 'package:kgf_app/features/personalization/models/session_model.dart';
import 'package:kgf_app/utils/popups/loaders.dart';

class SessionController extends GetxController {
  static SessionController get instance => Get.find();

  final sessionRepository = Get.put(SessionRepository());

  /// Variables
  final title = TextEditingController();
  final date = TextEditingController();
  final timeFrom = TextEditingController();
  final timeTo = TextEditingController();
  final minPeople = TextEditingController();
  final maxPeople = TextEditingController();
  final repeat = TextEditingController();
  final bringAFriend = false.obs;
  GlobalKey<FormState> sessionFormKey = GlobalKey<FormState>();

  Future<List<SessionModel>> allSessions() async {
    try {
      final sessions = await sessionRepository.fetchSessions();
      return sessions;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Sessions not found!', message: e.toString());
      return [];
    }
  }
}
