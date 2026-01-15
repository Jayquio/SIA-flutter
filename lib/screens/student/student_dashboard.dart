import 'package:flutter/material.dart';
import 'request_instrument_screen.dart';
import 'my_requests_screen.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 6,
              child: ListTile(
                leading: const Icon(Icons.add_box, size: 36),
                title: const Text("Request Instrument",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle:
                    const Text("Submit a new instrument borrowing request"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RequestInstrumentScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 6,
              child: ListTile(
                leading: const Icon(Icons.list_alt, size: 36),
                title: const Text("My Requests",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("View request status"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MyRequestsScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
