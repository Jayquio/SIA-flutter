// lib/screens/staff/manage_requests_screen.dart

import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/request.dart';
import '../../widgets/search_bar.dart';
import '../../data/notification_service.dart';
import '../../core/constants.dart';

class ManageRequestsScreen extends StatefulWidget {
  const ManageRequestsScreen({super.key});

  @override
  State<ManageRequestsScreen> createState() => _ManageRequestsScreenState();
}

class _ManageRequestsScreenState extends State<ManageRequestsScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _updateRequestStatus(int index, RequestStatus status) {
    setState(() {
      requests[index].status = status;
      if (status == RequestStatus.approved) {
        // Update instrument availability
        final instrument = instruments.firstWhere(
          (inst) => inst.name == requests[index].instrumentName,
        );
        if (instrument.available > 0) {
          instrument.available--;
        }
      }
    });
    NotificationService.instance.add(
      NotificationItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: status == RequestStatus.approved ? 'Request Approved' : 'Request Rejected',
        message: '${requests[index].studentName} ${status == RequestStatus.approved ? 'approved' : 'rejected'} for ${requests[index].instrumentName}.',
        type: status == RequestStatus.approved ? 'success' : 'error',
        timestamp: DateTime.now().toIso8601String(),
        recipient: 'Staff',
        priority: status == RequestStatus.approved ? 'medium' : 'high',
      ),
    );
    NotificationService.instance.add(
      NotificationItem(
        id: 'student_${DateTime.now().microsecondsSinceEpoch}',
        title: status == RequestStatus.approved ? 'Request Approved' : 'Request Rejected',
        message: 'Your request for ${requests[index].instrumentName} has been ${status == RequestStatus.approved ? 'approved' : 'rejected'}.',
        type: status == RequestStatus.approved ? 'success' : 'error',
        timestamp: DateTime.now().toIso8601String(),
        recipient: 'Student',
        priority: status == RequestStatus.approved ? 'medium' : 'high',
      ),
    );
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.approved:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.pending:
        return Colors.orange;
      case RequestStatus.returned:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final searchTerm = _searchController.text.toLowerCase();
    final filteredRequests = requests.where((req) {
      if (searchTerm.isEmpty) return true;
      return req.studentName.toLowerCase().contains(searchTerm) ||
          req.instrumentName.toLowerCase().contains(searchTerm) ||
          req.purpose.toLowerCase().contains(searchTerm) ||
          req.status.name.toLowerCase().contains(searchTerm);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Requests")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: DebouncedSearchBar(
              controller: _searchController,
              hintText: 'Search requests...',
              onChanged: (value) => setState(() {}),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: ListView.builder(
                key: ValueKey(filteredRequests.length),
                padding: const EdgeInsets.all(16),
                itemCount: filteredRequests.length,
                itemBuilder: (context, index) {
                  final request = filteredRequests[index];
                  final originalIndex = requests.indexOf(request);
                  return _HoverListCard(
                    margin: const EdgeInsets.only(bottom: 16),
                    onTap: () => _showRequestDetails(request),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.studentName,
                            style: TextStyle(fontSize: R.text(18, w), fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text("Instrument: ${request.instrumentName}"),
                          const SizedBox(height: 6),
                          Text(
                            "Status: ${request.status.name}",
                            style: TextStyle(color: _getStatusColor(request.status)),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: request.status == RequestStatus.pending
                                    ? () => _updateRequestStatus(originalIndex, RequestStatus.approved)
                                    : null,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: const Text("Approve"),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: request.status == RequestStatus.pending
                                    ? () => _updateRequestStatus(originalIndex, RequestStatus.rejected)
                                    : null,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text("Reject"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRequestDetails(Request request) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.instrumentName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Student: ${request.studentName}'),
            Text('Purpose: ${request.purpose}'),
            Text('Status: ${request.status.name}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _HoverListCard extends StatefulWidget {
  const _HoverListCard({
    required this.child,
    this.onTap,
    this.margin,
  });
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  State<_HoverListCard> createState() => _HoverListCardState();
}

class _HoverListCardState extends State<_HoverListCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          transform: Matrix4.diagonal3Values(_hover ? 1.01 : 1.0, _hover ? 1.01 : 1.0, 1.0),
          child: Card(
            elevation: _hover ? 8 : 6,
            child: InkWell(
              onTap: widget.onTap,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
