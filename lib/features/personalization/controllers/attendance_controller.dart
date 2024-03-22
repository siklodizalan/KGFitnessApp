import 'package:get/get.dart';
import 'package:kgf_app/data/repositories/attendance/attendance_repository.dart';
import 'package:kgf_app/data/repositories/authentication/authentication_repository.dart';
import 'package:kgf_app/features/personalization/controllers/session_controller.dart';
import 'package:kgf_app/features/personalization/models/attendance_model.dart';
import 'package:kgf_app/utils/popups/loaders.dart';

class AttendanceController extends GetxController {
  static AttendanceController get instance => Get.find();

  var bringAFriend = false.obs;
  final attendanceRepository = Get.put(AttendanceRepository());
  final sessionController = SessionController.instance;

  Future<void> addNewAttendance(
      String sessionId, int date, bool bringAFriend) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      final attendance = AttendanceModel(
          id: '',
          sessionId: sessionId,
          userId: userId,
          date: date,
          bringAFriend: bringAFriend);

      await attendanceRepository.addAttendance(attendance);
      String occupied =
          await sessionController.getSessionSingleField(sessionId, "Occupied");
      int occupiedInt = int.parse(occupied) + 1;
      if (bringAFriend) {
        occupiedInt += 1;
      }
      Map<String, int> json = {'Occupied': occupiedInt};
      await sessionController.setSessionSingleField(sessionId, json);
      await TLoaders.successSnackBar(
          title: 'Congratulations!',
          message: 'Your class attendance has been marked.');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<String> getAttendanceSessionIdForUserByDate(int date) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      return await attendanceRepository.fetchAttendancesByUserIdAndDate(
          userId, date);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return '';
    }
  }

  Future<void> deleteAttendanceBySessionIdUserIdAndDate(
      String sessionId, int date, bool bringAFriend) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await attendanceRepository.removeAttendanceBySessionIdAndUserIdAndDate(
          sessionId, userId, date);

      String occupied =
          await sessionController.getSessionSingleField(sessionId, "Occupied");
      int occupiedInt = int.parse(occupied) - 1;
      if (bringAFriend) {
        occupiedInt -= 1;
      }
      Map<String, int> json = {'Occupied': occupiedInt};

      await sessionController.setSessionSingleField(sessionId, json);
      TLoaders.successSnackBar(
          title: 'Success!',
          message: 'Your class attendance has been removed.');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
