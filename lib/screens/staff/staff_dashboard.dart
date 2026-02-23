// lib/screens/staff/staff_dashboard.dart

import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/module_search_bar.dart';
import '../../widgets/hover_scale_card.dart';
import '../../data/dummy_data.dart';
import '../../models/request.dart';
import '../../core/constants.dart';
import '../../widgets/notification_icon.dart';

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final pendingRequests = requests.where((req) => req.status == RequestStatus.pending).length;
    final approvedRequests = requests.where((req) => req.status == RequestStatus.approved).length;
    final returnedRequests = requests.where((req) => req.status == RequestStatus.returned).length;
    final lowStockInstruments = instruments.where((inst) => inst.available <= 1).length;
    final transactionNotifications = requests.reversed.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Dashboard"),
        backgroundColor: Colors.green.shade800,
        actions: [
          const NotificationIcon(recipients: ['Staff'], types: ['request']),
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
      drawer: AppDrawer(userRole: 'Staff'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.white],
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
                      colors: [Colors.green.shade600, Colors.green.shade800],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Lab Staff!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Manage requests and maintain laboratory equipment',
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

              // Statistics Cards
              Text('Current Status',
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
                      _buildStatItem(context, 'Pending', pendingRequests.toString(), Icons.pending_actions, Colors.orange),
                      _buildStatDivider(),
                      _buildStatItem(context, 'Active', approvedRequests.toString(), Icons.inventory_2, Colors.blue),
                      _buildStatDivider(),
                      _buildStatItem(context, 'Returns', returnedRequests.toString(), Icons.assignment_return, Colors.green),
                      _buildStatDivider(),
                      _buildStatItem(context, 'Low Stock', lowStockInstruments.toString(), Icons.warning, Colors.red),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Daily Tasks
              Text('Daily Tasks',
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
                        title: 'Review Requests',
                        icon: Icons.assignment,
                        color: Colors.orange,
                        onTap: () => Navigator.pushNamed(context, '/manage_requests'),
                      ),
                      _buildActionCard(
                        context,
                        title: 'Scan QR',
                        icon: Icons.qr_code_scanner,
                        color: Colors.teal,
                        onTap: () => Navigator.pushNamed(context, '/qr_scanner', arguments: 'Staff'),
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
                        title: 'Monitor',
                        icon: Icons.inventory,
                        color: Colors.blue,
                        onTap: () => Navigator.pushNamed(context, '/view_instruments', arguments: 'Staff'),
                      ),
                      _buildActionCard(
                        context,
                        title: 'Returns',
                        icon: Icons.assignment_return,
                        color: Colors.green,
                        onTap: () => Navigator.pushNamed(context, '/handle_returns'),
                      ),
                      _buildActionCard(
                        context,
                        title: 'Maintenance',
                        icon: Icons.build,
                        color: Colors.purple,
                        onTap: () => Navigator.pushNamed(context, '/log_maintenance'),
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
                                      '${request.studentName} - ${request.instrumentName}',
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

              // Urgent Tasks
              if (pendingRequests > 0 || lowStockInstruments > 0) ...[
                const Text(
                  'Urgent Attention Required',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),

                const SizedBox(height: 16),

                if (pendingRequests > 0)
                  Card(
                    elevation: 4,
                    color: Colors.orange.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '$pendingRequests request(s) waiting for approval',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/manage_requests'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Review'),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (lowStockInstruments > 0)
                  Card(
                    elevation: 4,
                    color: Colors.red.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '$lowStockInstruments instrument(s) running low on stock',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/view_instruments', arguments: 'Staff'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Check'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],

              const SizedBox(height: 24),

              // Recent Activity
              const Text(
                'Recent Activity',
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
                  child: Column(
                    children: [
                      if (requests.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.history, color: Colors.blue),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Latest: ${requests.last.studentName} requested ${requests.last.instrumentName}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (maintenanceRecords.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.build, color: Colors.green),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Maintenance: ${maintenanceRecords.last.instrumentName} (${maintenanceRecords.last.status})',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (requests.isEmpty && maintenanceRecords.isEmpty) ...[
                        const Center(
                          child: Text(
                            'No recent activity',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
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
        return 'Pending';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.rejected:
        return 'Rejected';
      case RequestStatus.returned:
        return 'Returned';
    }
  }

}

 
