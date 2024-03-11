import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String id;
  final String sessionId;
  final String userId;
  final int date;
  final bool bringAFriend;

  AttendanceModel({
    required this.id,
    required this.sessionId,
    required this.userId,
    required this.date,
    required this.bringAFriend,
  });

  static AttendanceModel empty() => AttendanceModel(
        id: '',
        sessionId: '',
        userId: '',
        date: 0,
        bringAFriend: false,
      );

  Map<String, dynamic> toJson() {
    return {
      'SessionId': sessionId,
      'UserId': userId,
      'Date': date,
      'BringAFriend': bringAFriend,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> data) {
    return AttendanceModel(
      id: data['Id'] as String,
      sessionId: data['SessionId'] as String,
      userId: data['UserId'] as String,
      date: data['Date'] as int,
      bringAFriend: data['BringAFriend'] as bool,
    );
  }

  factory AttendanceModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return AttendanceModel(
        id: document.id,
        sessionId: data['SessionId'] ?? '',
        userId: data['UserId'] ?? '',
        date: data['Date'] ?? '',
        bringAFriend: data['BringAFriend'] ?? '',
      );
    } else {
      return AttendanceModel.empty();
    }
  }
}
