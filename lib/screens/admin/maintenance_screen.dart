import 'package:flutter/material.dart';
import 'package:flutter_application_inventorymanagement/screens/admin/maintenance_form_screen.dart';
import '../../data/dummy_data.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {

  Color _statusColor(String status) {
    return status == 'Completed' ? Colors.green : Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maintenance Records"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const MaintenanceFormScreen()),
              );
              setState(() {});
            },
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: maintenanceLogs.length,
        itemBuilder: (context, index) {
          final log = maintenanceLogs[index];

          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 6,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(
                log.instrumentName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Issue: ${log.issue}"),
                  Text("Action: ${log.actionTaken}"),
                  Text(
                    "Status: ${log.status}",
                    style: TextStyle(
                      color: _statusColor(log.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                "${log.date.month}/${log.date.day}/${log.date.year}",
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}
