// lib/widgets/app_drawer.dart

import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String userRole;

  const AppDrawer({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'MedLab Inventory',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (userRole == 'Admin') ...[
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pushNamed(context, '/admin_dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text("Manage Instruments"),
              onTap: () {
                Navigator.pushNamed(context, '/manage_instruments');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("User Management"),
              onTap: () {
                Navigator.pushNamed(context, '/user_management');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text("Manage Requests"),
              onTap: () {
                Navigator.pushNamed(context, '/manage_requests');
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text("Generate Reports"),
              onTap: () {
                Navigator.pushNamed(context, '/generate_reports');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Transaction Logs"),
              onTap: () {
                Navigator.pushNamed(context, '/transaction_logs');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notification Center"),
              onTap: () {
                Navigator.pushNamed(context, '/notification_center');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pushNamed(context, '/settings', arguments: userRole);
              },
            ),
          ],
          if (userRole == 'Staff') ...[
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text("Monitor Inventory"),
              onTap: () {
                Navigator.pushNamed(context, '/view_instruments', arguments: 'Staff');
              },
            ),
            ListTile(
              leading: Icon(Icons.build),
              title: const Text("Log Maintenance"),
              onTap: () {
                Navigator.pushNamed(context, '/log_maintenance');
              },
            ),
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text("Approve Requests"),
              onTap: () {
                Navigator.pushNamed(context, '/manage_requests');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_return),
              title: const Text("Handle Returns"),
              onTap: () {
                Navigator.pushNamed(context, '/handle_returns');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pushNamed(context, '/settings', arguments: userRole);
              },
            ),
          ],
          if (userRole == 'Student') ...[
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text("View Instruments"),
              onTap: () {
                Navigator.pushNamed(context, '/view_instruments', arguments: 'Student');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Submit Request"),
              onTap: () {
                Navigator.pushNamed(context, '/submit_request');
              },
            ),
            ListTile(
              leading: const Icon(Icons.track_changes),
              title: const Text("Track Status"),
              onTap: () {
                Navigator.pushNamed(context, '/track_status');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pushNamed(context, '/settings', arguments: userRole);
              },
            ),
          ],
        ],
      ),
    );
  }
}
