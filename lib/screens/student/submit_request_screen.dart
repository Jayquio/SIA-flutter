// lib/screens/student/submit_request_screen.dart

import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/request.dart';

class SubmitRequestScreen extends StatefulWidget {
  final String? preSelectedInstrument;
  const SubmitRequestScreen({super.key, this.preSelectedInstrument});

  @override
  State<SubmitRequestScreen> createState() => _SubmitRequestScreenState();
}

class _SubmitRequestScreenState extends State<SubmitRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedInstrument;
  String _studentName = '';
  String _purpose = '';

  @override
  void initState() {
    super.initState();
    _selectedInstrument = widget.preSelectedInstrument ?? '';
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newRequest = Request(
        studentName: _studentName,
        instrumentName: _selectedInstrument,
        purpose: _purpose,
        status: RequestStatus.pending,
      );
      setState(() {
        requests.add(newRequest);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request submitted successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Request')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Your Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => _studentName = value!,
              ),
              const SizedBox(height: 16),
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
                decoration: const InputDecoration(labelText: 'Purpose'),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the purpose of your request';
                  }
                  return null;
                },
                onSaved: (value) => _purpose = value!,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitRequest,
                child: const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}