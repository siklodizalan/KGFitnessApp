import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kgf_app/features/personalization/models/attendance_model.dart';

class AttendanceRepository extends GetxController {
  static AttendanceRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> addAttendance(AttendanceModel attendance) async {
    try {
      final currentAttendance =
          await _db.collection('Attendances').add(attendance.toJson());
      return currentAttendance.id;
    } catch (e) {
      throw 'Something went wrong while saving class participation. Try again later.';
    }
  }

  Future<void> removeAttendanceBySessionIdAndUserIdAndDate(
      String sessionId, String userId, int date) async {
    try {
      final result = await _db
          .collection("Attendances")
          .where('SessionId', isEqualTo: sessionId)
          .where('UserId', isEqualTo: userId)
          .where('Date', isEqualTo: date)
          .get();

      for (var document in result.docs) {
        await document.reference.delete();
      }
    } catch (e) {
      throw 'Something went wrong while deleting class participation. Try again later.';
    }
  }

  Future<String> fetchAttendancesByUserIdAndDate(
      String userId, int date) async {
    try {
      final result = await _db
          .collection("Attendances")
          .where('UserId', isEqualTo: userId)
          .where('Date', isEqualTo: date)
          .get();

      final List<AttendanceModel> attendances = result.docs
          .map((documentSnapshot) =>
              AttendanceModel.fromSnapshot(documentSnapshot))
          .toList();

      if (attendances.isNotEmpty) {
        return attendances.first.sessionId;
      } else {
        return '';
      }
    } catch (e) {
      throw 'Something went wrong while fetching the class participation. Please try again later.';
    }
  }
}
