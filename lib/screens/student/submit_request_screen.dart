// lib/screens/student/submit_request_screen.dart

import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/request.dart';
import '../../data/notification_service.dart';

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
      NotificationService.instance.add(
        NotificationItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: 'New Request Submitted',
          message: '$_studentName requested $_selectedInstrument',
          type: 'request',
          timestamp: DateTime.now().toIso8601String(),
          recipient: 'Staff',
          priority: 'medium',
        ),
      );
      NotificationService.instance.add(
        NotificationItem(
          id: 'admin_${DateTime.now().microsecondsSinceEpoch}',
          title: 'New Request',
          message: '$_studentName requested $_selectedInstrument',
          type: 'request',
          timestamp: DateTime.now().toIso8601String(),
          recipient: 'Admin',
          priority: 'low',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request submitted successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Submit Request'),
        backgroundColor: Colors.teal.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          AnimatedBuilder(
            animation: NotificationService.instance,
            builder: (context, _) {
              final count = NotificationService.instance.unreadCount;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    tooltip: 'Notifications',
                    onPressed: () => Navigator.pushNamed(context, '/notification_center'),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.teal.shade800,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create a New Request',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Provide details and select an instrument',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildFormCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Student Details'),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: _inputDecoration('Your Name', Icons.person),
                            validator: (value) => value!.isEmpty ? 'Required' : null,
                            onSaved: (value) => _studentName = value!,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFormCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Request Details'),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: _inputDecoration('Select Instrument', Icons.inventory),
                            isExpanded: true,
                            items: instruments.map((instrument) {
                              return DropdownMenuItem<String>(
                                value: instrument.name,
                                child: Text(instrument.name),
                              );
                            }).toList(),
                            validator: (value) => value == null ? 'Required' : null,
                            onChanged: (value) => _selectedInstrument = value!,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: _inputDecoration('Purpose', Icons.flag),
                            maxLines: 3,
                            validator: (value) => value!.isEmpty ? 'Required' : null,
                            onSaved: (value) => _purpose = value!,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submitRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade800,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send),
                            SizedBox(width: 12),
                            Text(
                              'Submit Request',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.teal.shade900,
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.teal.shade800),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.teal.shade800, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }
}
