import 'package:flutter/material.dart';

class Correspondence {
  final String id;
  final DateTime date;
  final TimeOfDay time;
  final String senderDepartment;
  final String guideCode;
  final String certificateNumber;

  Correspondence({
    required this.id,
    required this.date,
    required this.time,
    required this.senderDepartment,
    required this.guideCode,
    required this.certificateNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'senderDepartment': senderDepartment,
      'guideCode': guideCode,
      'certificateNumber': certificateNumber,
    };
  }

  factory Correspondence.fromMap(Map<String, dynamic> map) {
    return Correspondence(
      id: map['id'],
      date: DateTime.parse(map['date']),
      time: TimeOfDay(
        hour: int.parse(map['time'].split(':')[0]),
        minute: int.parse(map['time'].split(':')[1]),
      ),
      senderDepartment: map['senderDepartment'],
      guideCode: map['guideCode'],
      certificateNumber: map['certificateNumber'],
    );
  }

  Correspondence copyWith({
    String? id,
    DateTime? date,
    TimeOfDay? time,
    String? senderDepartment,
    String? guideCode,
    String? certificateNumber,
  }) {
    return Correspondence(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      senderDepartment: senderDepartment ?? this.senderDepartment,
      guideCode: guideCode ?? this.guideCode,
      certificateNumber: certificateNumber ?? this.certificateNumber,
    );
  }
}
