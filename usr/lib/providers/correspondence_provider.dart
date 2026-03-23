import 'package:flutter/material.dart';
import '../models/correspondence.dart';

class CorrespondenceProvider with ChangeNotifier {
  List<Correspondence> _records = [];
  List<Correspondence> get records => _records;

  void addRecord(Correspondence record) {
    if (_records.any((r) => r.guideCode == record.guideCode)) {
      throw Exception('Error: código de guía duplicado');
    }
    _records.add(record);
    notifyListeners();
  }

  void updateRecord(String id, Correspondence updatedRecord) {
    final index = _records.indexWhere((r) => r.id == id);
    if (index != -1) {
      if (_records.any((r) => r.guideCode == updatedRecord.guideCode && r.id != id)) {
        throw Exception('Error: código de guía duplicado');
      }
      _records[index] = updatedRecord;
      notifyListeners();
    }
  }

  void deleteRecord(String id) {
    _records.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  List<Correspondence> searchAndFilter({
    String? guideCode,
    String? certificateNumber,
    String? senderDepartment,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _records.where((record) {
      if (guideCode != null && !record.guideCode.contains(guideCode)) return false;
      if (certificateNumber != null && !record.certificateNumber.contains(certificateNumber)) return false;
      if (senderDepartment != null && !record.senderDepartment.contains(senderDepartment)) return false;
      if (startDate != null && record.date.isBefore(startDate)) return false;
      if (endDate != null && record.date.isAfter(endDate)) return false;
      return true;
    }).toList();
  }

  List<Correspondence> get sortedRecords {
    final sorted = List<Correspondence>.from(_records);
    sorted.sort((a, b) {
      final dateCompare = a.date.compareTo(b.date);
      if (dateCompare != 0) return dateCompare;
      return a.time.hour * 60 + a.time.minute - (b.time.hour * 60 + b.time.minute);
    });
    return sorted;
  }
}