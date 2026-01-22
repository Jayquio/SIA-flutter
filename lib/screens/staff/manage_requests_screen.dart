// lib/screens/staff/manage_requests_screen.dart

import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/request.dart';

class ManageRequestsScreen extends StatefulWidget {
  const ManageRequestsScreen({super.key});

  @override
  State<ManageRequestsScreen> createState() => _ManageRequestsScreenState();
}

class _ManageRequestsScreenState extends State<ManageRequestsScreen> {
  void _updateRequestStatus(int index, RequestStatus status) {
    setState(() {
      requests[index].status = status;
      if (status == RequestStatus.approved) {
        // Update instrument availability
        final instrument = instruments.firstWhere(
          (inst) => inst.name == requests[index].instrumentName,
        );
        if (instrument.available > 0) {
          instrument.available--;
        }
      }
    });
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.approved:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.pending:
        return Colors.orange;
      case RequestStatus.returned:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Requests")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return Card(
            elevation: 6,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.studentName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text("Instrument: ${request.instrumentName}"),
                  const SizedBox(height: 6),
                  Text("Status: ${request.status.name}",
                      style: TextStyle(color: _getStatusColor(request.status))),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _updateRequestStatus(index, RequestStatus.approved),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text("Approve"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => _updateRequestStatus(index, RequestStatus.rejected),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text("Reject"),
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
