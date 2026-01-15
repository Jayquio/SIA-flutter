import 'package:flutter/material.dart';
import '../../widgets/stat_card.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: const [
            StatCard(title: "Total Instruments", value: "24", icon: Icons.biotech),
            StatCard(title: "Available", value: "15", icon: Icons.check_circle),
            StatCard(title: "In Use", value: "9", icon: Icons.hourglass_bottom),
            StatCard(title: "Pending Requests", value: "4", icon: Icons.list_alt),
          ],
        ),
      ),
    );
  }
}
