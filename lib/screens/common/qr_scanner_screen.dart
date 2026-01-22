// lib/screens/common/qr_scanner_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/dummy_data.dart';
import '../../models/instrument.dart';

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
    // Assume QR contains instrument name
    final instrument = instruments.firstWhere(
      (inst) => inst.name == code,
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

    if (widget.userRole == 'Student') {
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
      // For admin/staff, just show details
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
              Text("Status: ${instrument.status}"),
              Text("Condition: ${instrument.condition}"),
              Text("Location: ${instrument.location}"),
              Text("Last Maintenance: ${instrument.lastMaintenance}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
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