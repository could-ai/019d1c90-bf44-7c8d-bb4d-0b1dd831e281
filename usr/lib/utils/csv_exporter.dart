import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import '../models/correspondence.dart';

class CsvExporter {
  static void exportToCsv(List<Correspondence> records) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm');

    List<List<String>> rows = [
      ['Fecha', 'Hora', 'Depto. Remitente', 'Código de Guía', 'Certificado Nº'],
      ...records.map((record) => [
        dateFormat.format(record.date),
        timeFormat.format(DateTime(0, 0, 0, record.time.hour, record.time.minute)),
        record.senderDepartment,
        record.guideCode,
        record.certificateNumber,
      ]),
    ];

    String csv = const ListToCsvConverter().convert(rows);
    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'correspondencia.csv')
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}