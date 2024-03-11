import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kgf_app/utils/helpers/helper_functions.dart';

class SessionModel {
  SessionModel({
    required this.id,
    this.repeatId,
    required this.userId,
    required this.title,
    required this.date,
    required this.fromTime,
    required this.toTime,
    required this.minPeople,
    required this.maxPeople,
    required this.repeat,
    required this.occupied,
    this.bringAFriend = false,
  });

  String id;
  String? repeatId;
  final String userId;
  final String title;
  int date;
  final String fromTime;
  final String toTime;
  final int minPeople;
  final int maxPeople;
  final String repeat;
  int occupied;
  bool bringAFriend;

  static SessionModel empty() => SessionModel(
        id: '',
        userId: '',
        title: '',
        date: THelperFunctions.getToday().millisecondsSinceEpoch,
        fromTime: '',
        toTime: '',
        minPeople: 0,
        maxPeople: 20,
        occupied: 0,
        repeat: '',
        bringAFriend: false,
        repeatId: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'UserId': userId,
      'Title': title,
      'Date': date,
      'TimeFrom': fromTime,
      'TimeTo': toTime,
      'PeopleMin': minPeople,
      'PeopleMax': maxPeople,
      'Occupied': occupied,
      'Repeat': repeat,
      'BringAFriend': bringAFriend,
      'RepeatId': repeatId ?? '',
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> data) {
    return SessionModel(
      id: data['Id'] as String,
      userId: data['UserId'] as String,
      title: data['Title'] as String,
      date: data['Date'] as int,
      fromTime: data['TimeFrom'] as String,
      toTime: data['TimeTo'] as String,
      minPeople: data['PeopleMin'] as int,
      maxPeople: data['PeopleMax'] as int,
      occupied: data['Occupied'] as int,
      repeat: data['Repeat'] as String,
      bringAFriend: data['BringAFriend'] as bool,
      repeatId: data['RepeatId'] as String,
    );
  }

  factory SessionModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return SessionModel(
      id: data['Id'] ?? '',
      userId: data['UserId'] ?? '',
      title: data['Title'] ?? '',
      date: data['Date'] ?? '',
      fromTime: data['TimeFrom'] ?? '',
      toTime: data['TimeTo'] ?? '',
      minPeople: data['PeopleMin'] ?? '',
      maxPeople: data['PeopleMax'] ?? '',
      occupied: data['Occupied'] ?? '',
      repeat: data['Repeat'] ?? '',
      bringAFriend: data['BringAFriend'] ?? '',
      repeatId: data['RepeatId'] ?? '',
    );
  }
}
