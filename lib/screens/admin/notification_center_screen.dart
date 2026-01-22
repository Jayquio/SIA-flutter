// lib/screens/admin/notification_center_screen.dart

import 'package:flutter/material.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Maintenance Due',
      'message': 'Microscope Olympus CX23 is due for maintenance in 3 days.',
      'type': 'warning',
      'timestamp': '2024-01-20 09:00:00',
      'recipient': 'All Staff',
      'read': false,
      'priority': 'high'
    },
    {
      'id': '2',
      'title': 'New Request Submitted',
      'message': 'Jane Student has submitted a request for Centrifuge Machine.',
      'type': 'info',
      'timestamp': '2024-01-20 10:15:30',
      'recipient': 'Staff',
      'read': false,
      'priority': 'medium'
    },
    {
      'id': '3',
      'title': 'Instrument Returned',
      'message': 'Centrifuge Machine has been returned by John Student.',
      'type': 'success',
      'timestamp': '2024-01-20 11:30:45',
      'recipient': 'Staff',
      'read': true,
      'priority': 'low'
    },
    {
      'id': '4',
      'title': 'Low Stock Alert',
      'message': 'Pipette tips are running low. Only 5 boxes remaining.',
      'type': 'warning',
      'timestamp': '2024-01-20 12:00:00',
      'recipient': 'Admin',
      'read': false,
      'priority': 'high'
    },
    {
      'id': '5',
      'title': 'System Update',
      'message': 'System maintenance scheduled for tonight at 2 AM.',
      'type': 'info',
      'timestamp': '2024-01-20 13:45:15',
      'recipient': 'All Users',
      'read': true,
      'priority': 'medium'
    },
    {
      'id': '6',
      'title': 'Overdue Return',
      'message': 'Spectrophotometer is overdue for return by Bob Student.',
      'type': 'error',
      'timestamp': '2024-01-20 14:20:30',
      'recipient': 'Staff',
      'read': false,
      'priority': 'high'
    },
  ];

  String _selectedFilter = 'All';
  bool _showUnreadOnly = false;

  List<Map<String, dynamic>> get _filteredNotifications {
    List<Map<String, dynamic>> filtered = _notifications;

    // Filter by type
    if (_selectedFilter != 'All') {
      filtered = filtered.where((notification) => notification['type'] == _selectedFilter).toList();
    }

    // Filter by read status
    if (_showUnreadOnly) {
      filtered = filtered.where((notification) => !notification['read']).toList();
    }

    return filtered;
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

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _markAsRead(String id) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n['id'] == id);
      notification['read'] = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['read'] = true;
      }
    });
  }

  void _createNewNotification() {
    // TODO: Implement create notification dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create notification feature coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n['read']).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Center'),
        actions: [
          if (unreadCount > 0)
            TextButton.icon(
              onPressed: _markAllAsRead,
              icon: const Icon(Icons.done_all, color: Colors.white),
              label: const Text('Mark All Read', style: TextStyle(color: Colors.white)),
            ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewNotification,
            tooltip: 'Create Notification',
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            _notifications.length.toString(),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const Text('Total Notifications'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            unreadCount.toString(),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          const Text('Unread'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedFilter,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: ['All', 'error', 'warning', 'success', 'info'].map((filter) {
                      return DropdownMenuItem(value: filter, child: Text(filter.toUpperCase()));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedFilter = value!),
                  ),
                ),
                const SizedBox(width: 16),
                FilterChip(
                  label: const Text('Unread Only'),
                  selected: _showUnreadOnly,
                  onSelected: (selected) => setState(() => _showUnreadOnly = selected),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Notifications List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredNotifications.length,
              itemBuilder: (context, index) {
                final notification = _filteredNotifications[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8),
                  color: notification['read'] ? Colors.white : Colors.blue.shade50,
                  child: InkWell(
                    onTap: () => _markAsRead(notification['id']),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getTypeIcon(notification['type']),
                                color: _getTypeColor(notification['type']),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notification['title'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              decoration: notification['read'] ? TextDecoration.lineThrough : null,
                                              color: notification['read'] ? Colors.grey : Colors.black,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: _getPriorityColor(notification['priority']),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            notification['priority'].toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      notification['recipient'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!notification['read'])
                                const Icon(Icons.circle, color: Colors.blue, size: 12),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            notification['message'],
                            style: TextStyle(
                              fontSize: 14,
                              color: notification['read'] ? Colors.grey : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                notification['timestamp'],
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}