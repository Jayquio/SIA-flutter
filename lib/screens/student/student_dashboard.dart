// lib/screens/student/student_dashboard.dart

import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../data/dummy_data.dart';
import '../../models/request.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final myRequests = requests.where((req) => req.studentName.toLowerCase().contains('john') || req.studentName.toLowerCase().contains('maria')).toList();
    final pendingRequests = myRequests.where((req) => req.status == RequestStatus.pending).length;
    final approvedRequests = myRequests.where((req) => req.status == RequestStatus.approved).length;
    final availableInstruments = instruments.where((inst) => inst.available > 0).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: Colors.teal.shade800,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: AppDrawer(userRole: 'Student'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade600, Colors.teal.shade800],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Student!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Access laboratory instruments for your research',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // My Requests Overview
              const Text(
                'My Requests',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Pending',
                      value: pendingRequests.toString(),
                      icon: Icons.pending,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Approved',
                      value: approvedRequests.toString(),
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Total Requests',
                      value: myRequests.length.toString(),
                      icon: Icons.assignment,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Available Items',
                      value: availableInstruments.toString(),
                      icon: Icons.inventory,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildActionCard(
                    context,
                    title: 'Request Instrument',
                    icon: Icons.add_circle,
                    color: Colors.green,
                    onTap: () => Navigator.pushNamed(context, '/submit_request'),
                  ),
                  _buildActionCard(
                    context,
                    title: 'Scan QR to Request',
                    icon: Icons.qr_code_scanner,
                    color: Colors.teal,
                    onTap: () => Navigator.pushNamed(context, '/qr_scanner', arguments: 'Student'),
                  ),
                  _buildActionCard(
                    context,
                    title: 'View Instruments',
                    icon: Icons.inventory,
                    color: Colors.blue,
                    onTap: () => Navigator.pushNamed(context, '/view_instruments'),
                  ),
                  _buildActionCard(
                    context,
                    title: 'Track My Requests',
                    icon: Icons.track_changes,
                    color: Colors.orange,
                    onTap: () => Navigator.pushNamed(context, '/track_status'),
                  ),
                  _buildActionCard(
                    context,
                    title: 'Lab Guidelines',
                    icon: Icons.info,
                    color: Colors.purple,
                    onTap: () => _showGuidelinesDialog(context),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Requests
              if (myRequests.isNotEmpty) ...[
                const Text(
                  'Recent Requests',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 16),

                ...myRequests.take(3).map((request) => Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          _getStatusIcon(request.status),
                          color: _getStatusColor(request.status),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                request.instrumentName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Status: ${_getStatusText(request.status)}',
                                style: TextStyle(
                                  color: _getStatusColor(request.status),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (request.status == RequestStatus.approved)
                          ElevatedButton(
                            onPressed: () => _showReturnDialog(context, request),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            ),
                            child: const Text('Return'),
                          ),
                      ],
                    ),
                  ),
                )),
              ],

              const SizedBox(height: 24),

              // Important Notices
              const Text(
                'Important Notices',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              Card(
                elevation: 4,
                color: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.announcement, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
                            'Lab Usage Guidelines',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Return instruments promptly after use\n• Handle equipment with care\n• Report any damage immediately\n• Follow safety protocols at all times',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Icons.pending;
      case RequestStatus.approved:
        return Icons.check_circle;
      case RequestStatus.rejected:
        return Icons.cancel;
      case RequestStatus.returned:
        return Icons.assignment_return;
    }
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Colors.orange;
      case RequestStatus.approved:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.returned:
        return Colors.blue;
    }
  }

  String _getStatusText(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return 'Pending Approval';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.rejected:
        return 'Rejected';
      case RequestStatus.returned:
        return 'Returned';
    }
  }

  void _showGuidelinesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Laboratory Guidelines'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('• Always handle instruments with care'),
              Text('• Return equipment to its proper location'),
              Text('• Report any damage or malfunction immediately'),
              Text('• Follow safety protocols and wear appropriate PPE'),
              Text('• Do not use instruments without proper training'),
              Text('• Respect lab schedules and time limits'),
              Text('• Clean equipment before and after use'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }

  void _showReturnDialog(BuildContext context, Request request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Return Instrument'),
        content: Text('Are you sure you want to return "${request.instrumentName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // In a real app, this would update the request status
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Instrument returned successfully!')),
              );
              Navigator.pop(context);
            },
            child: const Text('Return'),
          ),
        ],
      ),
    );
  }
}
