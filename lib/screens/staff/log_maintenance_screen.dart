// lib/screens/staff/log_maintenance_screen.dart

import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/maintenance.dart';

class LogMaintenanceScreen extends StatefulWidget {
  const LogMaintenanceScreen({super.key});

  @override
  State<LogMaintenanceScreen> createState() => _LogMaintenanceScreenState();
}

class _LogMaintenanceScreenState extends State<LogMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedInstrument = '';
  String _notes = '';
  String _technician = '';
  String _type = '';
  String _status = 'Completed';

  void _logMaintenance() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newMaintenance = Maintenance(
        instrumentName: _selectedInstrument,
        technician: _technician,
        date: DateTime.now().toString().split(' ')[0], // YYYY-MM-DD format
        type: _type,
        notes: _notes,
        status: _status,
      );
      setState(() {
        maintenanceRecords.add(newMaintenance);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maintenance logged successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Maintenance')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Instrument'),
                items: instruments.map((instrument) {
                  return DropdownMenuItem<String>(
                    value: instrument.name,
                    child: Text(instrument.name),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an instrument';
                  }
                  return null;
                },
                onChanged: (value) => _selectedInstrument = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Maintenance Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter maintenance type';
                  }
                  return null;
                },
                onSaved: (value) => _type = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Maintenance Notes'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter maintenance notes';
                  }
                  return null;
                },
                onSaved: (value) => _notes = value!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Status'),
                initialValue: _status,
                items: ['Completed', 'Pending', 'In Progress'].map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Technician Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter technician name';
                  }
                  return null;
                },
                onSaved: (value) => _technician = value!,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _logMaintenance,
                child: const Text('Log Maintenance'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}