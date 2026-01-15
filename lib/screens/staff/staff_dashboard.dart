import 'package:flutter/material.dart';
import 'manage_requests_screen.dart';

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Staff Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 6,
          child: ListTile(
            leading: const Icon(Icons.assignment, size: 36),
            title: const Text(
              "Manage Requests",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text("Approve or reject student requests"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ManageRequestsScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}
