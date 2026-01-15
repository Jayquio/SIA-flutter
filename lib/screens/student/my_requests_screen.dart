import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Requests")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: studentRequests.length,
        itemBuilder: (context, index) {
          final req = studentRequests[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 5,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(req.instrumentName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Purpose: ${req.purpose}"),
                  Text(
                    "Status: ${req.status}",
                    style: TextStyle(
                      color: _statusColor(req.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                "${req.dateRequested.month}/${req.dateRequested.day}/${req.dateRequested.year}",
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}
