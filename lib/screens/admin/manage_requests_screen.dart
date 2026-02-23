// lib/screens/admin/manage_requests_screen.dart

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
  int _page = 0;
  final int _perPage = 10;

  void _approveRequest(int index) {
    setState(() {
      requests[index].status = RequestStatus.approved;
      // Update instrument availability
      final instrument = instruments.firstWhere(
        (inst) => inst.name == requests[index].instrumentName,
      );
      if (instrument.available > 0) {
        instrument.available--;
      }
    });
    NotificationService.instance.add(
      NotificationItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: 'Request Approved',
        message: '${requests[index].studentName} approved for ${requests[index].instrumentName}.',
        type: 'success',
        timestamp: DateTime.now().toIso8601String(),
        recipient: 'Staff',
        priority: 'medium',
      ),
    );
    NotificationService.instance.add(
      NotificationItem(
        id: 'student_${DateTime.now().microsecondsSinceEpoch}',
        title: 'Request Approved',
        message: 'Your request for ${requests[index].instrumentName} has been approved.',
        type: 'success',
        timestamp: DateTime.now().toIso8601String(),
        recipient: 'Student',
        priority: 'medium',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request approved!')),
    );
  }

  void _rejectRequest(int index) {
    setState(() {
      requests[index].status = RequestStatus.rejected;
    });
    NotificationService.instance.add(
      NotificationItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: 'Request Rejected',
        message: '${requests[index].studentName} rejected for ${requests[index].instrumentName}.',
        type: 'error',
        timestamp: DateTime.now().toIso8601String(),
        recipient: 'Staff',
        priority: 'high',
      ),
    );
    NotificationService.instance.add(
      NotificationItem(
        id: 'student_${DateTime.now().microsecondsSinceEpoch}',
        title: 'Request Rejected',
        message: 'Your request for ${requests[index].instrumentName} has been rejected.',
        type: 'error',
        timestamp: DateTime.now().toIso8601String(),
        recipient: 'Student',
        priority: 'high',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request rejected!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final searchTerm = _searchController.text.toLowerCase();
    final pendingRequests = requests.where((req) => req.status == RequestStatus.pending).where((req) {
      if (searchTerm.isEmpty) return true;
      return req.studentName.toLowerCase().contains(searchTerm) ||
          req.instrumentName.toLowerCase().contains(searchTerm) ||
          req.purpose.toLowerCase().contains(searchTerm) ||
          req.status.name.toLowerCase().contains(searchTerm);
    }).toList();
    final totalPages = (pendingRequests.length / _perPage).ceil();
    final start = (_page * _perPage).clamp(0, pendingRequests.length);
    final end = (start + _perPage).clamp(0, pendingRequests.length);
    final pageItems = pendingRequests.sublist(start, end);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Requests')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: DebouncedSearchBar(
              controller: _searchController,
              hintText: 'Search requests...',
              onChanged: (value) => setState(() {
                _page = 0;
              }),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: pendingRequests.isEmpty
                        ? const Center(child: Text('No pending requests.'))
                        : ListView.builder(
                            key: ValueKey(pageItems.length),
                            padding: const EdgeInsets.all(16),
                            itemCount: pageItems.length,
                            itemBuilder: (context, index) {
                              final request = pageItems[index];
                              final originalIndex = requests.indexOf(request);
                              return _HoverListCard(
                                margin: const EdgeInsets.only(bottom: 12),
                                onTap: () => _showRequestDetails(request),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.orange.shade100,
                                            child: const Icon(Icons.assignment, color: Colors.orange),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              request.studentName,
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Text(
                                              'Pending',
                                              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(color: Colors.black),
                                          children: _highlightSpans(request.instrumentName, _searchController.text.toLowerCase()),
                                        ),
                                      ),
                                      Text("Purpose: ${request.purpose}"),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => _approveRequest(originalIndex),
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                            child: const Text('Approve'),
                                          ),
                                          const SizedBox(width: 12),
                                          ElevatedButton(
                                            onPressed: () => _rejectRequest(originalIndex),
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                            child: const Text('Reject'),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Page ${_page + 1} of ${totalPages == 0 ? 1 : totalPages}', style: TextStyle(fontSize: R.text(12, w))),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: _page > 0 ? () => setState(() => _page--) : null,
                        child: const Text('Prev'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: (_page + 1) < totalPages ? () => setState(() => _page++) : null,
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
              ],
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
  List<TextSpan> _highlightSpans(String text, String term) {
    if (term.isEmpty) return [const TextSpan(text: 'Instrument: '), TextSpan(text: text)];
    final lowerText = text.toLowerCase();
    final idx = lowerText.indexOf(term);
    if (idx < 0) return [const TextSpan(text: 'Instrument: '), TextSpan(text: text)];
    return [
      const TextSpan(text: 'Instrument: '),
      TextSpan(text: text.substring(0, idx)),
      TextSpan(
        text: text.substring(idx, idx + term.length),
        style: const TextStyle(backgroundColor: Color(0xFFFFF59D)),
      ),
      TextSpan(text: text.substring(idx + term.length)),
    ];
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
            elevation: _hover ? 8 : 4,
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
