import 'package:flutter/material.dart';
import '../../data/qr_code_service.dart';
import '../../data/auth_service.dart';

class UserQrScreen extends StatelessWidget {
  const UserQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final username = AuthService.instance.currentUsername;
    final role = AuthService.instance.currentRole.name;
    final payload = QrCodeService.instance.buildUserPayload();
    return Scaffold(
      appBar: AppBar(title: const Text('My QR')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Text('User: $username', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Role: $role', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            Center(child: QrCodeService.instance.buildQrWidget(payload, size: 240)),
            const SizedBox(height: 12),
            const Text('Show this QR to identify your account'),
            const Spacer(),
            Card(
              elevation: 0,
              color: Colors.blue.withValues(alpha: 0.06),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Payload is encoded locally and contains only your username and role.',
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
