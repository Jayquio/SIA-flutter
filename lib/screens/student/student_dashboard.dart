// lib/screens/student/student_dashboard.dart

import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/module_search_bar.dart';
import '../../widgets/hover_scale_card.dart';
import '../../data/dummy_data.dart';
import '../../models/request.dart';
import '../../core/constants.dart';
import '../../widgets/notification_icon.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final myRequests = requests.where((req) => req.studentName.toLowerCase().contains('john') || req.studentName.toLowerCase().contains('maria')).toList();
    final pendingRequests = myRequests.where((req) => req.status == RequestStatus.pending).length;
    final approvedRequests = myRequests.where((req) => req.status == RequestStatus.approved).length;
    final availableInstruments = instruments.where((inst) => inst.available > 0).length;
    final transactionNotifications = myRequests.reversed.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: Colors.teal.shade800,
        actions: [
          const NotificationIcon(recipients: ['Student'], types: ['success', 'error']),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ModuleSearchController.instance.setQuery('');
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
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
              const ModuleSearchBar(),
              const SizedBox(height: 12),
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
              Text('My Requests',
                  style: TextStyle(
                    fontSize: R.text(20, w),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  )),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(context, 'Pending', pendingRequests.toString(), Icons.pending, Colors.orange),
                      _buildStatDivider(),
                      _buildStatItem(context, 'Approved', approvedRequests.toString(), Icons.check_circle, Colors.green),
                      _buildStatDivider(),
                      _buildStatItem(context, 'Total', myRequests.length.toString(), Icons.assignment, Colors.blue),
                      _buildStatDivider(),
                      _buildStatItem(context, 'Available', availableInstruments.toString(), Icons.inventory, Colors.purple),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Quick Actions
              Text('Quick Actions',
                  style: TextStyle(
                    fontSize: R.text(20, w),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  )),

              const SizedBox(height: 16),

              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = R.columns(constraints.maxWidth, xs: 3, sm: 3, md: 4, lg: 5);
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: R.tileAspect(constraints.maxWidth),
                    children: [
                      _buildActionCard(
                        context,
                        title: 'Request',
                        icon: Icons.add_circle,
                        color: Colors.green,
                        onTap: () => Navigator.pushNamed(context, '/submit_request'),
                      ),
                      _buildActionCard(
                        context,
                        title: 'Scan QR',
                        icon: Icons.qr_code_scanner,
                        color: Colors.teal,
                        onTap: () => Navigator.pushNamed(context, '/qr_scanner', arguments: 'Student'),
                      ),
                      _buildActionCard(
                        context,
                        title: 'My QR',
                        icon: Icons.qr_code_2,
                        color: Colors.indigo,
                        onTap: () => Navigator.pushNamed(context, '/user_qr'),
                      ),
                      _buildActionCard(
                        context,
                        title: 'Instruments',
                        icon: Icons.inventory,
                        color: Colors.blue,
                        onTap: () => Navigator.pushNamed(context, '/view_instruments'),
                      ),
                      _buildActionCard(
                        context,
                        title: 'Track',
                        icon: Icons.track_changes,
                        color: Colors.orange,
                        onTap: () => Navigator.pushNamed(context, '/track_status'),
                      ),
                      _buildActionCard(
                        context,
                        title: 'Notifications',
                        icon: Icons.notifications,
                        color: Colors.purple,
                        onTap: () => Navigator.pushNamed(context, '/notification_center'),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // Transaction Notifications
              const Text(
                'Transaction Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: transactionNotifications.isEmpty
                      ? const Text('No recent transactions.')
                      : Column(
                          children: transactionNotifications.map((request) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    _getStatusIcon(request.status),
                                    color: _getStatusColor(request.status),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      request.instrumentName,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Text(
                                    _getStatusText(request.status),
                                    style: TextStyle(
                                      color: _getStatusColor(request.status),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ),
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

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon, Color color) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 30,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Colors.grey.withValues(alpha: 0.1),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return HoverScaleCard(
      baseElevation: 4,
      hoverElevation: 10,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
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
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
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

 
