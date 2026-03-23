import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/correspondence.dart';
import '../providers/correspondence_provider.dart';
import '../utils/csv_exporter.dart';
import 'form_widget.dart';

class TableWidget extends StatefulWidget {
  const TableWidget({super.key});

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  final _searchGuideCodeController = TextEditingController();
  final _searchCertificateController = TextEditingController();
  final _searchDepartmentController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CorrespondenceProvider>(context);
    final filteredRecords = provider.searchAndFilter(
      guideCode: _searchGuideCodeController.text.isEmpty ? null : _searchGuideCodeController.text,
      certificateNumber: _searchCertificateController.text.isEmpty ? null : _searchCertificateController.text,
      senderDepartment: _searchDepartmentController.text.isEmpty ? null : _searchDepartmentController.text,
      startDate: _startDate,
      endDate: _endDate,
    );

    return Column(
      children: [
        // Filtros
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Filtros', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchGuideCodeController,
                        decoration: const InputDecoration(labelText: 'Buscar por Código de Guía'),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _searchCertificateController,
                        decoration: const InputDecoration(labelText: 'Buscar por Certificado Nº'),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _searchDepartmentController,
                        decoration: const InputDecoration(labelText: 'Buscar por Depto. Remitente'),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => _startDate = picked);
                          }
                        },
                        child: Text(_startDate == null ? 'Fecha Inicio' : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _endDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => _endDate = picked);
                          }
                        },
                        child: Text(_endDate == null ? 'Fecha Fin' : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => CsvExporter.exportToCsv(filteredRecords),
                      child: const Text('Exportar CSV'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Tabla
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Fecha')),
                DataColumn(label: Text('Hora')),
                DataColumn(label: Text('Depto. Remitente')),
                DataColumn(label: Text('Código de Guía')),
                DataColumn(label: Text('Certificado Nº')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: filteredRecords.map((record) => DataRow(
                cells: [
                  DataCell(Text('${record.date.day}/${record.date.month}/${record.date.year}')),
                  DataCell(Text('${record.time.hour}:${record.time.minute.toString().padLeft(2, '0')}')),
                  DataCell(Text(record.senderDepartment)),
                  DataCell(Text(record.guideCode)),
                  DataCell(Text(record.certificateNumber)),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editRecord(context, record),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteRecord(context, record.id),
                      ),
                    ],
                  )),
                ],
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }

  void _editRecord(BuildContext context, Correspondence record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Registro'),
        content: SizedBox(
          width: 600,
          child: FormWidget(record: record),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _deleteRecord(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: const Text('¿Está seguro de que desea eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<CorrespondenceProvider>(context, listen: false).deleteRecord(id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registro eliminado correctamente')),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchGuideCodeController.dispose();
    _searchCertificateController.dispose();
    _searchDepartmentController.dispose();
    super.dispose();
  }
}
