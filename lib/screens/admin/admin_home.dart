import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'manage_instruments_screen.dart';
import 'maintenance_screen.dart';



class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _index = 0;

  final screens = const [
    AdminDashboard(),
    ManageInstrumentsScreen(),
    MaintenanceScreen(),
    Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
       items: const [
  BottomNavigationBarItem(
      icon: Icon(Icons.dashboard), label: 'Dashboard'),
  BottomNavigationBarItem(
      icon: Icon(Icons.biotech), label: 'Instruments'),
  BottomNavigationBarItem(
      icon: Icon(Icons.build), label: 'Maintenance'),
  BottomNavigationBarItem(
      icon: Icon(Icons.person), label: 'Profile'),
],
      ),
    );
  }
}
