import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/correspondence.dart';
import '../providers/correspondence_provider.dart';

class FormWidget extends StatefulWidget {
  final Correspondence? record;
  final VoidCallback? onSave;

  const FormWidget({super.key, this.record, this.onSave});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _senderDepartmentController = TextEditingController();
  final _guideCodeController = TextEditingController();
  final _certificateNumberController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      _selectedDate = widget.record!.date;
      _selectedTime = widget.record!.time;
      _senderDepartmentController.text = widget.record!.senderDepartment;
      _guideCodeController.text = widget.record!.guideCode;
      _certificateNumberController.text = widget.record!.certificateNumber;
      _dateController.text = '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
      _timeController.text = '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.record == null ? 'Nuevo Registro' : 'Editar Registro',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(labelText: 'Fecha'),
                      readOnly: true,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                            _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
                          });
                        }
                      },
                      validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      decoration: const InputDecoration(labelText: 'Hora'),
                      readOnly: true,
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime ?? TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedTime = picked;
                            _timeController.text = '${picked.hour}:${picked.minute.toString().padLeft(2, '0')}';
                          });
                        }
                      },
                      validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _senderDepartmentController,
                decoration: const InputDecoration(labelText: 'Departamento Remitente'),
                validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _guideCodeController,
                decoration: const InputDecoration(labelText: 'Código de Guía'),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo obligatorio';
                  final provider = Provider.of<CorrespondenceProvider>(context, listen: false);
                  final existing = provider.records.any((r) => r.guideCode == value && r.id != widget.record?.id);
                  if (existing) return 'Código de guía duplicado';
                  return null;
                },
              ),
              TextFormField(
                controller: _certificateNumberController,
                decoration: const InputDecoration(labelText: 'Certificado Nº'),
                validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<CorrespondenceProvider>(context, listen: false);
      try {
        final record = Correspondence(
          id: widget.record?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          date: _selectedDate!,
          time: _selectedTime!,
          senderDepartment: _senderDepartmentController.text,
          guideCode: _guideCodeController.text,
          certificateNumber: _certificateNumberController.text,
        );
        if (widget.record == null) {
          provider.addRecord(record);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro guardado correctamente')),
          );
        } else {
          provider.updateRecord(widget.record!.id, record);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro actualizado correctamente')),
          );
        }
        widget.onSave?.call();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _senderDepartmentController.dispose();
    _guideCodeController.dispose();
    _certificateNumberController.dispose();
    super.dispose();
  }
}