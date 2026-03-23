import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/correspondence_provider.dart';
import '../widgets/form_widget.dart';
import '../widgets/table_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Correspondencia Certificada'),
        actions: [
          ElevatedButton.icon(
            onPressed: () => setState(() => _showForm = !_showForm),
            icon: Icon(_showForm ? Icons.list : Icons.add),
            label: Text(_showForm ? 'Ver Lista' : 'Nuevo Registro'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _showForm
            ? FormWidget(onSave: () => setState(() => _showForm = false))
            : const TableWidget(),
      ),
    );
  }
}