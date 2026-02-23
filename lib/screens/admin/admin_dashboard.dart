// lib/screens/admin/admin_dashboard.dart

import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/hover_scale_card.dart';
import '../../widgets/module_search_bar.dart';
import '../../data/dummy_data.dart';
import '../../models/request.dart';
import '../../data/notification_service.dart';
import '../../core/constants.dart';
import '../../widgets/notification_icon.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.blue.shade800,
        actions: [
          const NotificationIcon(recipients: ['Admin'], types: ['login']),
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
      drawer: AppDrawer(userRole: 'Admin'),
      body: const _AdminDashboardBody(),
    );
  }

 

 

}

 
 
class _AdminDashboardBody extends StatefulWidget {
  const _AdminDashboardBody();
  @override
  State<_AdminDashboardBody> createState() => _AdminDashboardBodyState();
}
 
class _AdminDashboardBodyState extends State<_AdminDashboardBody> {
  final TextEditingController _searchController = TextEditingController();
  bool _recentExpanded = true;
  int _notifPage = 0;
 
  @override
  void initState() {
    super.initState();
    NotificationService.instance.loadFromStorage();
    NotificationService.instance.connectWebSocket();
    NotificationService.instance.startAutoRefresh();
  }
 
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso);
      int hour = dt.hour;
      final minute = dt.minute.toString().padLeft(2, '0');
      final suffix = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;
      final hh = hour.toString().padLeft(2, '0');
      return '$hh:$minute $suffix';
    } catch (_) {
      if (iso.contains('T')) {
        final parts = iso.split('T').last.split('.');
        return parts.first;
      }
      return iso;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final totalInstruments = instruments.length;
    final availableInstruments = instruments.where((inst) => inst.available > 0).length;
    final pendingRequests = requests.where((req) => req.status == RequestStatus.pending).length;
    final approvedRequests = requests.where((req) => req.status == RequestStatus.approved).length;
    final outOfStockInstruments = instruments.where((inst) => inst.available == 0).length;
    final searchTerm = _searchController.text.toLowerCase();
 
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade50, Colors.white],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ModuleSearchBar(),
            const SizedBox(height: 12),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade800],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, Administrator!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Manage your laboratory inventory efficiently',
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
 
            Text('Quick Overview',
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
                    _buildStatItem(context, 'Total', totalInstruments.toString(), Icons.inventory, Colors.blue, '/view_instruments'),
                    _buildStatDivider(),
                    _buildStatItem(context, 'Available', availableInstruments.toString(), Icons.check_circle, Colors.green, '/view_instruments'),
                    _buildStatDivider(),
                    _buildStatItem(context, 'Pending', pendingRequests.toString(), Icons.pending, Colors.orange, '/manage_requests'),
                    _buildStatDivider(),
                    _buildStatItem(context, 'Approved', approvedRequests.toString(), Icons.check_circle, Colors.purple, '/manage_requests'),
                    _buildStatDivider(),
                    _buildStatItem(context, 'Out of Stock', outOfStockInstruments.toString(), Icons.error_outline, Colors.red, '/view_instruments'),
                  ],
                ),
              ),
            ),
 
            const SizedBox(height: 32),
 
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
                      title: 'Manage Instruments',
                      icon: Icons.inventory,
                      color: Colors.blue,
                      onTap: () => Navigator.pushNamed(context, '/manage_instruments'),
                    ),
                    _buildActionCard(
                      context,
                      title: 'Scan QR Code',
                      icon: Icons.qr_code_scanner,
                      color: Colors.teal,
                      onTap: () => Navigator.pushNamed(context, '/qr_scanner', arguments: 'Admin'),
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
                      title: 'Requests',
                      icon: Icons.assignment,
                      color: Colors.green,
                      onTap: () => Navigator.pushNamed(context, '/manage_requests'),
                    ),
                    _buildActionCard(
                      context,
                      title: 'Reports',
                      icon: Icons.report,
                      color: Colors.purple,
                      onTap: () => Navigator.pushNamed(context, '/generate_reports'),
                    ),
                    _buildActionCard(
                      context,
                      title: 'Overview',
                      icon: Icons.dashboard,
                      color: Colors.orange,
                      onTap: () => _showAllDataDialog(context),
                    ),
                  ],
                );
              },
            ),
 
            const SizedBox(height: 24),

            const SizedBox(height: 8),
 
            DebouncedSearchBar(
              controller: _searchController,
              hintText: 'Search notifications...',
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Text('Transaction Notifications',
                style: TextStyle(
                  fontSize: R.text(20, w),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: NotificationService.instance,
              builder: (context, _) {
                final base = NotificationService.instance.notifications.take(20).toList();
                final notifications = searchTerm.isEmpty
                    ? base
                    : base.where((n) =>
                        '${n.title} ${n.message}'.toLowerCase().contains(searchTerm)).toList();
                final unread = NotificationService.instance.unreadCount;
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: notifications.isEmpty
                        ? const Text('No recent transactions.')
                        : Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.receipt_long),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Transaction Logs',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (unread > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade600,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '$unread',
                                        style: const TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  const Spacer(),
                                  TextButton.icon(
                                    onPressed: () => Navigator.pushNamed(context, '/notification_center'),
                                    icon: const Icon(Icons.open_in_new),
                                    label: const Text('Open Center'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ...notifications.map((n) {
                                final time = _formatTime(n.timestamp);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundColor: _getTypeColor(n.type).withValues(alpha: 0.15),
                                          child: Icon(
                                            _getTypeIcon(n.type),
                                            color: _getTypeColor(n.type),
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                n.title,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                n.message,
                                                style: const TextStyle(fontSize: 13, color: Colors.black87),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            time,
                                            style: const TextStyle(color: Colors.blueGrey, fontSize: 11),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                  ),
                );
              },
            ),
 
            const SizedBox(height: 24),
 
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedBuilder(
                animation: NotificationService.instance,
                builder: (context, _) {
                  final pageItems = NotificationService.instance.getPaginatedNotifications(_notifPage);
                  final total = NotificationService.instance.notifications.length;
                  final totalPages = (total / 10).ceil();
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Recent Activity',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(_recentExpanded ? Icons.expand_less : Icons.expand_more),
                              onPressed: () => setState(() => _recentExpanded = !_recentExpanded),
                            ),
                          ],
                        ),
                        if (_recentExpanded) ...[
                          const SizedBox(height: 8),
                          if (pageItems.isEmpty)
                            const Text('No activity', style: TextStyle(color: Colors.grey))
                          else
                            Column(
                              children: pageItems.map((n) {
                                final time = _formatTime(n.timestamp);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        _getTypeIcon(n.type),
                                        color: _getTypeColor(n.type),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              n.title,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              n.message,
                                              style: const TextStyle(fontSize: 13),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        time,
                                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              TextButton(
                                onPressed: _notifPage > 0
                                    ? () => setState(() => _notifPage -= 1)
                                    : null,
                                child: const Text('Prev'),
                              ),
                              const SizedBox(width: 8),
                              Text('Page ${_notifPage + 1} of ${totalPages == 0 ? 1 : totalPages}'),
                              const Spacer(),
                              TextButton(
                                onPressed: (_notifPage + 1) < totalPages
                                    ? () => setState(() => _notifPage += 1)
                                    : null,
                                child: const Text('Next'),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon, Color color, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
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
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 40,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey.withValues(alpha: 0.2),
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

  Widget _reportTile(BuildContext context,
      {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  void _showAllDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('System Overview'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Instruments: ${instruments.length}'),
              Text('Total Requests: ${requests.length}'),
              Text('Maintenance Records: ${maintenanceRecords.length}'),
              const SizedBox(height: 16),
              const Text(
                'System Status: Operational',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
 
  Color _getTypeColor(String type) {
    switch (type) {
      case 'error':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'success':
        return Colors.green;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
 
  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'error':
        return Icons.error;
      case 'warning':
        return Icons.warning;
      case 'success':
        return Icons.check_circle;
      case 'info':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }
}
