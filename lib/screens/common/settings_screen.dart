// lib/screens/common/settings_screen.dart

import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final String userRole;

  const SettingsScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Settings
          Card(
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Profile Settings'),
              subtitle: const Text('Manage your account information'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to profile settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile settings coming soon!')),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Notification Settings
          Card(
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.notifications, color: Colors.orange),
              title: const Text('Notifications'),
              subtitle: const Text('Configure notification preferences'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to notification settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification settings coming soon!')),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Security Settings
          Card(
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.security, color: Colors.green),
              title: const Text('Security'),
              subtitle: const Text('Change password and security settings'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to security settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Security settings coming soon!')),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Admin-only settings
          if (userRole == 'Admin') ...[
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings, color: Colors.purple),
                title: const Text('System Administration'),
                subtitle: const Text('Advanced system configuration'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Navigate to admin settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Admin settings coming soon!')),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Staff-only settings
          if (userRole == 'Staff') ...[
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.work, color: Colors.teal),
                title: const Text('Work Preferences'),
                subtitle: const Text('Configure work schedule and preferences'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Navigate to staff settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Staff settings coming soon!')),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Student-only settings
          if (userRole == 'Student') ...[
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.school, color: Colors.indigo),
                title: const Text('Academic Settings'),
                subtitle: const Text('Manage academic preferences'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Navigate to student settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Academic settings coming soon!')),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // General Settings
          Card(
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.palette, color: Colors.pink),
              title: const Text('Appearance'),
              subtitle: const Text('Theme and display preferences'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to appearance settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Appearance settings coming soon!')),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          Card(
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.help, color: Colors.blue),
              title: const Text('Help & Support'),
              subtitle: const Text('Get help and contact support'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Navigate to help screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help & Support coming soon!')),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          Card(
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.info, color: Colors.grey),
              title: const Text('About'),
              subtitle: const Text('App version and information'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'MedLab Inventory System',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2024 JMCFI MedLab',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}