import 'package:flutter/material.dart';
import 'screens/common/login_screen.dart';
import 'screens/common/qr_scanner_screen.dart';
import 'screens/common/settings_screen.dart';
import 'screens/staff/manage_requests_screen.dart';
import 'screens/admin/manage_instruments_screen.dart';
import 'screens/admin/user_management_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/audit_logs_screen.dart';
import 'screens/admin/notification_center_screen.dart';
import 'screens/staff/staff_dashboard.dart';
import 'screens/student/student_dashboard.dart';
import 'screens/student/submit_request_screen.dart';
import 'screens/student/view_instruments_screen.dart';
import 'screens/staff/log_maintenance_screen.dart';
import 'screens/staff/handle_returns_screen.dart';
import 'screens/admin/generate_reports_screen.dart';
import 'screens/student/track_status_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedLab Inventory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/admin_dashboard': (context) => const AdminDashboard(),
        '/staff_dashboard': (context) => const StaffDashboard(),
        '/student_dashboard': (context) => const StudentDashboard(),
        '/manage_requests': (context) => const ManageRequestsScreen(),
        '/manage_instruments': (context) => const ManageInstrumentsScreen(),
        '/user_management': (context) => const UserManagementScreen(),
        '/audit_logs': (context) => const AuditLogsScreen(),
        '/notification_center': (context) => const NotificationCenterScreen(),
        '/submit_request': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String?;
          return SubmitRequestScreen(preSelectedInstrument: args);
        },
        '/view_instruments': (context) => const ViewInstrumentsScreen(),
        '/log_maintenance': (context) => const LogMaintenanceScreen(),
        '/handle_returns': (context) => const HandleReturnsScreen(),
        '/generate_reports': (context) => const GenerateReportsScreen(),
        '/track_status': (context) => const TrackStatusScreen(),
        '/qr_scanner': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String?;
          return QrScannerScreen(userRole: args ?? 'Student');
        },
        '/settings': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String?;
          return SettingsScreen(userRole: args ?? 'Student');
        },
      },
    );
  }
}
