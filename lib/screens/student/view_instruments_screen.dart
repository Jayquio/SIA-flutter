// lib/screens/student/view_instruments_screen.dart

import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';

class ViewInstrumentsScreen extends StatelessWidget {
  const ViewInstrumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Instruments')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: instruments.length,
        itemBuilder: (context, index) {
          final instrument = instruments[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    instrument.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("Category: ${instrument.category}"),
                  Text("Available: ${instrument.available}/${instrument.quantity}"),
                  Text("Status: ${instrument.status}"),
                  Text("Condition: ${instrument.condition}"),
                  Text("Location: ${instrument.location}"),
                  Text("Last Maintenance: ${instrument.lastMaintenance}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}