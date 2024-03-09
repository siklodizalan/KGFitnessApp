import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kgf_app/features/personalization/models/session_model.dart';

class SessionRepository extends GetxController {
  static SessionRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<SessionModel>> fetchSessions() async {
    try {
      final result = await _db.collection('Sessions').get();
      return result.docs
          .map((documnetSnapshot) =>
              SessionModel.fromDocumentSnapshot(documnetSnapshot))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching the sessions. Please try again later.';
    }
  }
}
