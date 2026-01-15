import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatelessWidget {
  const BarcodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode / QR'),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          facing: CameraFacing.back,
        ),

        /// ✅ FIXED CALLBACK SIGNATURE
        onDetect: (BarcodeCapture capture) {
          if (capture.barcodes.isEmpty) return;

          final String? code = capture.barcodes.first.rawValue;

          if (code == null) return;

          /// Return scanned value to previous screen
          Navigator.pop(context, code);
        },
      ),
    );
  }
}
