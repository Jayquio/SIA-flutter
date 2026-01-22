// lib/screens/admin/manage_requests_screen.dart

import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/request.dart';

class ManageRequestsScreen extends StatefulWidget {
  const ManageRequestsScreen({super.key});

  @override
  State<ManageRequestsScreen> createState() => _ManageRequestsScreenState();
}

class _ManageRequestsScreenState extends State<ManageRequestsScreen> {
  void _approveRequest(int index) {
    setState(() {
      requests[index].status = RequestStatus.approved;
      // Update instrument availability
      final instrument = instruments.firstWhere(
        (inst) => inst.name == requests[index].instrumentName,
      );
      if (instrument.available > 0) {
        instrument.available--;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request approved!')),
    );
  }

  void _rejectRequest(int index) {
    setState(() {
      requests[index].status = RequestStatus.rejected;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request rejected!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingRequests = requests.where((req) => req.status == RequestStatus.pending).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Requests')),
      body: pendingRequests.isEmpty
          ? const Center(child: Text('No pending requests.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pendingRequests.length,
              itemBuilder: (context, index) {
                final request = pendingRequests[index];
                final originalIndex = requests.indexOf(request);
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.studentName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text("Instrument: ${request.instrumentName}"),
                        Text("Purpose: ${request.purpose}"),
                        Text("Status: ${request.status.name}", style: const TextStyle(color: Colors.orange)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => _approveRequest(originalIndex),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              child: const Text('Approve'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () => _rejectRequest(originalIndex),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('Reject'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}