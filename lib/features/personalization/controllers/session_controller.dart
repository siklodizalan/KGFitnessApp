import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kgf_app/data/repositories/authentication/authentication_repository.dart';
import 'package:kgf_app/data/repositories/session/session_repository.dart';
import 'package:kgf_app/features/personalization/controllers/user_controller.dart';
import 'package:kgf_app/features/personalization/models/session_model.dart';
import 'package:kgf_app/utils/constants/image_strings.dart';
import 'package:kgf_app/utils/constants/sizes.dart';
import 'package:kgf_app/utils/helpers/network_manager.dart';
import 'package:kgf_app/utils/popups/full_screen_loader.dart';
import 'package:kgf_app/utils/popups/loaders.dart';

class SessionController extends GetxController {
  static SessionController get instance => Get.find();

  /// Variables
  final title = TextEditingController();
  final date = TextEditingController();
  final timeFrom = TextEditingController();
  final timeTo = TextEditingController();
  final minPeople = TextEditingController();
  final maxPeople = TextEditingController();
  RxString repeat = 'No repeat'.obs;
  var bringAFriend = false.obs;
  GlobalKey<FormState> sessionFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;
  final sessionRepository = Get.put(SessionRepository());
  final userController = UserController.instance;

  Future<List<SessionModel>> getAllSessionsByDate(DateTime date) async {
    try {
      final sessions = await sessionRepository.fetchSessionsByDate(date);
      sessions.sort((a, b) => a.fromTime.compareTo(b.fromTime));
      return sessions;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Sessions not found!', message: e.toString());
      return [];
    }
  }

  Future<String> getSessionSingleField(
      String sessionId, String fieldName) async {
    try {
      return await sessionRepository.fetchSessionSingleField(
          sessionId, fieldName);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Session not found!', message: e.toString());
      return '';
    }
  }

  Future addNewSession() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Storing new session...', TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!sessionFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      final session = SessionModel(
        id: '',
        userId: AuthenticationRepository.instance.authUser!.uid,
        title: title.text.trim(),
        date: DateTime.parse(date.text).millisecondsSinceEpoch,
        fromTime: timeFrom.text.trim(),
        toTime: timeTo.text.trim(),
        minPeople: int.parse(minPeople.text.trim()),
        maxPeople: int.parse(maxPeople.text.trim()),
        occupied: 0,
        repeat: repeat.value,
        bringAFriend: bringAFriend.value,
      );

      if (repeat.value == 'No repeat') {
        String sessionId = await sessionRepository.addSession(session);
        session.id = sessionId;
        await sessionRepository.updateSession(session);
      } else {
        String repeatId = await sessionRepository.addRepeatSession(session);
        session.repeatId = repeatId;
        if (repeat.value == 'Every Day') {
          await repeatDaily(
              session, DateTime.fromMillisecondsSinceEpoch(session.date));
        } else if (repeat.value == 'Every Weekday') {
          await repeatWeekdays(
              session, DateTime.fromMillisecondsSinceEpoch(session.date));
        } else if (repeat.value == 'Once a Week') {
          await repeatWeekly(
              session, DateTime.fromMillisecondsSinceEpoch(session.date));
        }
      }

      refreshData.toggle();
      resetFormFields();
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
          title: 'Congratulations!',
          message: 'Your session has been saved successfully.');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: 'Session not found!', message: e.toString());
    }
  }

  void resetFormFields() {
    title.clear();
    date.clear();
    timeFrom.clear();
    timeTo.clear();
    minPeople.clear();
    maxPeople.clear();
    sessionFormKey.currentState?.reset();
  }

  Future<void> repeatWeekly(SessionModel session, DateTime targetDate) async {
    DateTime initialDate = DateTime.fromMillisecondsSinceEpoch(session.date);
    DateTime startDate = DateTime(targetDate.year, targetDate.month, 1);
    DateTime endDate = DateTime(targetDate.year, targetDate.month + 1, 1);
    if (startDate.isBefore(initialDate)) {
      startDate = initialDate;
    }

    int initialDayOfWeek = initialDate.weekday;
    SessionModel newSession = session;
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      if (date.weekday == initialDayOfWeek) {
        newSession.date = date.millisecondsSinceEpoch;
        String sessionId = await sessionRepository.addSession(newSession);
        session.id = sessionId;
        await sessionRepository.updateSession(session);
      }
    }
  }

  Future<void> repeatWeekdays(SessionModel session, DateTime targetDate) async {
    DateTime initialDate = DateTime.fromMillisecondsSinceEpoch(session.date);
    DateTime startDate = DateTime(targetDate.year, targetDate.month, 1);
    DateTime endDate = DateTime(targetDate.year, targetDate.month + 1, 1);
    if (startDate.isBefore(initialDate)) {
      startDate = initialDate;
    }

    SessionModel newSession = session;
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday) {
        newSession.date = date.millisecondsSinceEpoch;
        String sessionId = await sessionRepository.addSession(newSession);
        session.id = sessionId;
        await sessionRepository.updateSession(session);
      }
    }
  }

  Future<void> repeatDaily(SessionModel session, DateTime targetDate) async {
    DateTime initialDate = DateTime.fromMillisecondsSinceEpoch(session.date);
    DateTime startDate = DateTime(targetDate.year, targetDate.month, 1);
    DateTime endDate = DateTime(targetDate.year, targetDate.month + 1, 1);
    if (startDate.isBefore(initialDate)) {
      startDate = initialDate;
    }

    SessionModel newSession = session;
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      newSession.date = date.millisecondsSinceEpoch;
      String sessionId = await sessionRepository.addSession(newSession);
      session.id = sessionId;
      await sessionRepository.updateSession(session);
    }
  }

  void deleteSessionWarningPopup(String sessionId) async {
    SessionModel original = await sessionRepository.fetchSessionById(sessionId);
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: 'Delete Session',
      middleText:
          'Are you sure you want to delete this session permanently? This action is not reversible and all session data will be removed permanently.',
      confirm: ElevatedButton(
        onPressed: () async => original.repeat == "No repeat"
            ? deleteSession(sessionId)
            : deleteSessionChoosePopup(sessionId),
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

  void deleteSessionChoosePopup(String sessionId) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: 'Delete Session',
      middleText:
          'Do you want to remove only this session or delete all repeat sessions as well?',
      confirm: ElevatedButton(
        onPressed: () async => deleteSession(sessionId),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Delete only this'),
        ),
      ),
      cancel: ElevatedButton(
        onPressed: () async => deleteRepeatSession(sessionId),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Delete all repeat'),
        ),
      ),
    );
  }

  void deleteSession(String sessionId) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Deleting session...', TImages.docerAnimation);

      await sessionRepository.removeSession(sessionId);

      refreshData.toggle();
      TFullScreenLoader.stopLoading();
      Navigator.of(Get.context!).popUntil((route) => route.isFirst);
      TLoaders.successSnackBar(
          title: 'Success!', message: 'Session deleted successfully.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void deleteRepeatSession(String sessionId) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Deleting sessions...', TImages.docerAnimation);

      SessionModel original =
          await sessionRepository.fetchSessionById(sessionId);

      String? repeatId = original.repeatId;

      if (repeatId != null) {
        List<SessionModel> repeatSessions =
            await sessionRepository.fetchSessionsByRepeatId(repeatId);

        for (SessionModel repeatSession in repeatSessions) {
          await sessionRepository.removeSession(repeatSession.id);
        }
        await sessionRepository.removeRepeatSession(repeatId);
      }

      refreshData.toggle();
      TFullScreenLoader.stopLoading();
      Navigator.of(Get.context!).popUntil((route) => route.isFirst);
      TLoaders.successSnackBar(
          title: 'Success!', message: 'Sessions deleted successfully.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
