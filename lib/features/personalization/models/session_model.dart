import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kgf_app/utils/helpers/helper_functions.dart';

class SessionModel {
  SessionModel({
    required this.id,
    required this.title,
    required this.date,
    required this.fromTime,
    required this.toTime,
    required this.minPeople,
    required this.maxPeople,
    required this.repeat,
    this.bringAFriend = false,
  });

  String id;
  final String title;
  final DateTime date;
  final TimeOfDay fromTime;
  final TimeOfDay toTime;
  final int minPeople;
  final int maxPeople;
  final String repeat;
  bool bringAFriend;

  static SessionModel empty() => SessionModel(
        id: '',
        title: '',
        date: THelperFunctions.getToday(),
        fromTime: const TimeOfDay(hour: 0, minute: 0),
        toTime: const TimeOfDay(hour: 0, minute: 0),
        minPeople: 0,
        maxPeople: 20,
        repeat: '',
        bringAFriend: false,
      );

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Title': title,
      'Date': date,
      'TimeFrom': fromTime,
      'TimeTo': toTime,
      'PeopleMin': minPeople,
      'PeopleMax': maxPeople,
      'Repeat': repeat,
      'BringAFriend': bringAFriend,
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> data) {
    return SessionModel(
      id: data['Id'] as String,
      title: data['Title'] as String,
      date: data['Date'] as DateTime,
      fromTime: data['TimeFrom'] as TimeOfDay,
      toTime: data['TimeTo'] as TimeOfDay,
      minPeople: data['PeopleMin'] as int,
      maxPeople: data['PeopleMax'] as int,
      repeat: data['Repeat'] as String,
      bringAFriend: data['BringAFriend'] as bool,
    );
  }

  factory SessionModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return SessionModel(
      id: snapshot.id,
      title: data['Title'] ?? '',
      date: data['Date'] ?? '',
      fromTime: data['TimeFrom'] ?? '',
      toTime: data['TimeTo'] ?? '',
      minPeople: data['PeopleMin'] ?? '',
      maxPeople: data['PeopleMax'] ?? '',
      repeat: data['Repeat'] ?? '',
      bringAFriend: data['BringAFriend'] ?? '',
    );
  }
}
