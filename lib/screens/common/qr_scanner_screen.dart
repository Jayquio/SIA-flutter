// lib/screens/common/qr_scanner_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/dummy_data.dart';
import '../../models/instrument.dart';
import '../../data/auth_service.dart';

class QrScannerScreen extends StatefulWidget {
  final String userRole;
  const QrScannerScreen({super.key, required this.userRole});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            icon: Icon(
              cameraController.torchEnabled ? Icons.flash_on : Icons.flash_off,
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: Icon(
              cameraController.facing == CameraFacing.front
                  ? Icons.camera_front
                  : Icons.camera_rear,
            ),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && _isScanning) {
            _isScanning = false;
            final String code = barcodes.first.rawValue ?? '';
            _handleScannedCode(code);
          }
        },
      ),
    );
  }

  void _handleScannedCode(String code) {
    String? type;
    String? name;
    if (code.startsWith('USR|')) {
      String? userId;
      String? role;
      final parts = code.substring(4).split(';');
      for (final p in parts) {
        final kv = p.split('=');
        if (kv.length == 2) {
          if (kv[0] == 'id') userId = kv[1];
          if (kv[0] == 'role') role = kv[1];
        }
      }
      final isLoginMode = widget.userRole.toLowerCase() == 'login';
      if (isLoginMode) {
        UserRole? parsedRole;
        switch ((role ?? '').toLowerCase()) {
          case 'admin':
            parsedRole = UserRole.admin;
            break;
          case 'staff':
            parsedRole = UserRole.staff;
            break;
          case 'student':
            parsedRole = UserRole.student;
            break;
        }
        if (userId == null || parsedRole == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid User QR')),
          );
          setState(() => _isScanning = true);
          return;
        }
        AuthService.instance.setUsername(userId);
        AuthService.instance.setRole(parsedRole);
        final route = parsedRole == UserRole.admin
            ? '/admin_dashboard'
            : (parsedRole == UserRole.staff ? '/staff_dashboard' : '/student_dashboard');
        Navigator.of(context).pushNamedAndRemoveUntil(route, (r) => false);
        return;
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('User QR Detected'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${userId ?? "unknown"}') ,
                Text('Role: ${role ?? "unknown"}') ,
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _isScanning = true);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }
    } else if (code.startsWith('QR|')) {
      final parts = code.substring(3).split(';');
      for (final p in parts) {
        final kv = p.split('=');
        if (kv.length == 2) {
          if (kv[0] == 'type') type = kv[1];
          if (kv[0] == 'name') name = kv[1];
        }
      }
    } else {
      name = code;
    }
    final instrument = instruments.firstWhere(
      (inst) => inst.name == (name ?? ''),
      orElse: () => Instrument(
        name: '',
        category: '',
        quantity: 0,
        available: 0,
        status: '',
        condition: '',
        location: '',
        lastMaintenance: '',
      ),
    );

    if (instrument.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Instrument not found!')),
      );
      setState(() => _isScanning = true);
      return;
    }

    final role = AuthService.instance.currentRole;
    if (type == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid QR format')),
      );
      setState(() => _isScanning = true);
      return;
    }
    if (type == 'borrow' && role != UserRole.student) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unauthorized: Only Students can use BORROW QR codes')),
      );
      setState(() => _isScanning = true);
      return;
    }
    if ((type == 'receive' || type == 'return') &&
        !(role == UserRole.admin || role == UserRole.staff)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unauthorized: Only Admin/Staff can use RECEIVE/RETURN QR codes')),
      );
      setState(() => _isScanning = true);
      return;
    }

    if (role == UserRole.student && type == 'borrow') {
      // Show instrument details and option to request
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(instrument.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Category: ${instrument.category}"),
              Text("Available: ${instrument.available}/${instrument.quantity}"),
              Text("Status: ${instrument.status}"),
              Text("Condition: ${instrument.condition}"),
              Text("Location: ${instrument.location}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            if (instrument.available > 0)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/submit_request', arguments: instrument.name);
                },
                child: const Text('Request This Instrument'),
              ),
          ],
        ),
      ).then((_) => setState(() => _isScanning = true));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(instrument.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Category: ${instrument.category}"),
              Text("Quantity: ${instrument.quantity}"),
              Text("Available: ${instrument.available}"),
              Text("Borrowed: ${instrument.quantity - instrument.available}"),
              Text("Status: ${instrument.status}"),
              Text("Condition: ${instrument.condition}"),
              Text("Location: ${instrument.location}"),
              Text("Last Maintenance: ${instrument.lastMaintenance}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            if (instrument.available > 0 && type == 'receive')
              ElevatedButton(
                onPressed: () {
                  instrument.available--;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Received (borrow processed) via QR')),
                  );
                  setState(() => _isScanning = true);
                },
                child: const Text('Receive (Borrow)'),
              ),
            if (instrument.available < instrument.quantity && type == 'return')
              OutlinedButton(
                onPressed: () {
                  instrument.available++;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Returned via QR')),
                  );
                  setState(() => _isScanning = true);
                },
                child: const Text('Return'),
              ),
          ],
        ),
      ).then((_) => setState(() => _isScanning = true));
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}