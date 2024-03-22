import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kgf_app/features/personalization/models/session_model.dart';
import 'package:kgf_app/utils/helpers/helper_functions.dart';

class SessionRepository extends GetxController {
  static SessionRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<SessionModel>> fetchSessionsByDate(DateTime date) async {
    try {
      DateTime startDate = DateTime(date.year, date.month, date.day);
      DateTime endDate = DateTime(date.year, date.month, date.day + 1);
      int startTimestamp = startDate.millisecondsSinceEpoch;
      int endTimestamp = endDate.millisecondsSinceEpoch;
      final result = await _db
          .collection('Sessions')
          .where('Date', isGreaterThanOrEqualTo: startTimestamp)
          .where('Date', isLessThan: endTimestamp)
          .get();
      return result.docs
          .map(
              (documnetSnapshot) => SessionModel.fromSnapshot(documnetSnapshot))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching the sessions. Please try again later.';
    }
  }

  Future<List<SessionModel>> fetchActiveSessionsByDate(DateTime date) async {
    try {
      DateTime startDate = DateTime(date.year, date.month, date.day);
      DateTime endDate = DateTime(date.year, date.month, date.day + 1);
      int startTimestamp = startDate.millisecondsSinceEpoch;
      int endTimestamp = endDate.millisecondsSinceEpoch;
      final result = await _db
          .collection('Sessions')
          .where('Active', isEqualTo: true)
          .where('Date', isGreaterThanOrEqualTo: startTimestamp)
          .where('Date', isLessThan: endTimestamp)
          .get();
      return result.docs
          .map(
              (documnetSnapshot) => SessionModel.fromSnapshot(documnetSnapshot))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching the sessions. Please try again later.';
    }
  }

  Future<SessionModel> fetchSessionById(String sessionId) async {
    try {
      final documentSnapshot =
          await _db.collection("Sessions").doc(sessionId).get();
      if (documentSnapshot.exists) {
        return SessionModel.fromSnapshot(documentSnapshot);
      } else {
        return SessionModel.empty();
      }
    } catch (e) {
      throw 'Something went wrong while fetching the session by id. Please try again later.';
    }
  }

  Future<SessionModel> fetchRepeatSessionById(String sessionId) async {
    try {
      final documentSnapshot =
          await _db.collection("RepeatSessions").doc(sessionId).get();
      if (documentSnapshot.exists) {
        return SessionModel.fromSnapshot(documentSnapshot);
      } else {
        return SessionModel.empty();
      }
    } catch (e) {
      throw 'Something went wrong while fetching the session by id. Please try again later.';
    }
  }

  Future<List<SessionModel>> fetchSessionsByRepeatId(String repeatId) async {
    try {
      final result = await _db
          .collection("Sessions")
          .where('RepeatId', isEqualTo: repeatId)
          .get();
      return result.docs
          .map(
              (documnetSnapshot) => SessionModel.fromSnapshot(documnetSnapshot))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching the session by repeat id. Please try again later.';
    }
  }

  Future<List<SessionModel>> fetchFutureSessionsByRepeatId(
      String repeatId) async {
    try {
      final int today = THelperFunctions.getToday().millisecondsSinceEpoch;
      final result = await _db
          .collection("Sessions")
          .where('RepeatId', isEqualTo: repeatId)
          .where('Date', isGreaterThan: today)
          .get();
      return result.docs
          .map(
              (documnetSnapshot) => SessionModel.fromSnapshot(documnetSnapshot))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching the session by repeat id. Please try again later.';
    }
  }

  Future<List<String>> fetchFutureSessionIdsByRepeatId(String repeatId) async {
    try {
      final int today = THelperFunctions.getToday().millisecondsSinceEpoch;
      final result = await _db
          .collection("Sessions")
          .where('RepeatId', isEqualTo: repeatId)
          .where('Date', isGreaterThan: today)
          .get();
      return result.docs
          .map((documnetSnapshot) => documnetSnapshot.id)
          .toList()
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching the session by repeat id. Please try again later.';
    }
  }

  Future<String> fetchSessionSingleField(
      String documentId, String fieldName) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _db.collection('Sessions').doc(documentId).get();
      if (documentSnapshot.exists) {
        dynamic fieldValue = documentSnapshot.get(fieldName);
        return fieldValue.toString();
      } else {
        return '';
      }
    } catch (e) {
      throw 'Something went wrong while fetching a single field of the session. Please try again later.';
    }
  }

  Future<void> updateSession(SessionModel session) async {
    try {
      DocumentReference sessionRef = _db.collection('Sessions').doc(session.id);

      Map<String, dynamic> sessionData = session.toJson();

      await sessionRef.update(sessionData);
    } catch (e) {
      throw 'Something went wrong while updateing the session. Please try again later.';
    }
  }

  Future<void> updateRepeatSession(SessionModel session) async {
    try {
      DocumentReference sessionRef =
          _db.collection('RepeatSessions').doc(session.id);

      Map<String, dynamic> sessionData = session.toJson();

      await sessionRef.update(sessionData);
    } catch (e) {
      throw 'Something went wrong while updateing the session. Please try again later.';
    }
  }

  Future<void> updateSessionSingleField(
      String sessionId, Map<String, dynamic> json) async {
    try {
      await _db.collection("Sessions").doc(sessionId).update(json);
    } catch (e) {
      throw 'Something went wrong while updateing the session. Please try again later.';
    }
  }

  Future<String> addRepeatSession(SessionModel session) async {
    try {
      final currentSession =
          await _db.collection('RepeatSessions').add(session.toJson());
      return currentSession.id;
    } catch (e) {
      throw 'Something went wrong while saving Session Information. Try again later.';
    }
  }

  Future<String> addSession(SessionModel session) async {
    try {
      final currentSession =
          await _db.collection('Sessions').add(session.toJson());
      return currentSession.id;
    } catch (e) {
      throw 'Something went wrong while saving Session Information. Try again later.';
    }
  }

  Future<void> removeRepeatSession(String sessionId) async {
    try {
      await _db.collection("RepeatSessions").doc(sessionId).delete();
    } catch (e) {
      throw 'Something went wrong while deleting Session Information. Try again later.';
    }
  }

  Future<void> removeSession(String sessionId) async {
    try {
      await _db.collection("Sessions").doc(sessionId).delete();
    } catch (e) {
      throw 'Something went wrong while deleting Session Information. Try again later.';
    }
  }
}
