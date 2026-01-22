// lib/screens/staff/handle_returns_screen.dart

import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/request.dart';

class HandleReturnsScreen extends StatefulWidget {
  const HandleReturnsScreen({super.key});

  @override
  State<HandleReturnsScreen> createState() => _HandleReturnsScreenState();
}

class _HandleReturnsScreenState extends State<HandleReturnsScreen> {
  void _markAsReturned(int index) {
    setState(() {
      requests[index].status = RequestStatus.returned;
      // Update instrument availability
      final instrument = instruments.firstWhere(
        (inst) => inst.name == requests[index].instrumentName,
      );
      if (instrument.available < instrument.quantity) {
        instrument.available++;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Instrument marked as returned!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final approvedRequests = requests.where((req) => req.status == RequestStatus.approved).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Handle Returns')),
      body: approvedRequests.isEmpty
          ? const Center(child: Text('No approved requests to return.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: approvedRequests.length,
              itemBuilder: (context, index) {
                final request = approvedRequests[index];
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
                        Text("Status: ${request.status.name}", style: const TextStyle(color: Colors.green)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => _markAsReturned(originalIndex),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          child: const Text('Mark as Returned'),
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