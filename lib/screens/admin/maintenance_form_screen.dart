import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/maintenance.dart';

class MaintenanceFormScreen extends StatefulWidget {
  const MaintenanceFormScreen({super.key});

  @override
  State<MaintenanceFormScreen> createState() =>
      _MaintenanceFormScreenState();
}

class _MaintenanceFormScreenState extends State<MaintenanceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String instrument = '';
  String status = 'Ongoing';

  final issue = TextEditingController();
  final action = TextEditingController();

  @override
  void initState() {
    super.initState();
    instrument = instruments.isNotEmpty ? instruments.first.name : '';
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    maintenanceLogs.add(
      MaintenanceLog(
        id: DateTime.now().millisecondsSinceEpoch,
        instrumentName: instrument,
        issue: issue.text,
        actionTaken: action.text,
        status: status,
        date: DateTime.now(),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Maintenance Record")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                initialValue: instrument,
                decoration:
                    const InputDecoration(labelText: "Select Instrument"),
                items: instruments
                    .map(
                      (i) => DropdownMenuItem(
                        value: i.name,
                        child: Text(i.name),
                      ),
                    )
                    .toList(),
                onChanged: (v) => instrument = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: issue,
                decoration: const InputDecoration(labelText: "Issue Detected"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: action,
                decoration:
                    const InputDecoration(labelText: "Action Taken"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              DropdownButtonFormField<String>(
                initialValue: status,
                decoration: const InputDecoration(labelText: "Status"),
                items: const [
                  DropdownMenuItem(value: 'Ongoing', child: Text('Ongoing')),
                  DropdownMenuItem(
                      value: 'Completed', child: Text('Completed')),
                ],
                onChanged: (v) => status = v!,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: const Text("Save Record"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
