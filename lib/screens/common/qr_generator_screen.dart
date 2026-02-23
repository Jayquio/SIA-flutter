import 'package:flutter/material.dart';
import '../../data/qr_code_service.dart';
import '../../data/auth_service.dart';
import '../../data/dummy_data.dart';

class QrGeneratorScreen extends StatefulWidget {
  final String userRole;
  const QrGeneratorScreen({super.key, required this.userRole});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  QrType? _selectedType;
  String? _selectedInstrument;
  String? _payload;

  @override
  void initState() {
    super.initState();
    final role = widget.userRole.toLowerCase();
    if (role == 'student') {
      _selectedType = QrType.borrow;
    } else {
      _selectedType = QrType.receive;
    }
  }

  bool get _canGenerateBorrow =>
      AuthService.instance.currentRole == UserRole.student;
  bool get _canGenerateReceiveReturn =>
      AuthService.instance.currentRole == UserRole.admin ||
      AuthService.instance.currentRole == UserRole.staff;

  @override
  Widget build(BuildContext context) {
    final roleName = AuthService.instance.currentRole.name;
    final allowed = [
      if (_canGenerateBorrow) 'Borrow',
      if (_canGenerateReceiveReturn) 'Receive',
      if (_canGenerateReceiveReturn) 'Return',
    ];
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Generate QR Code'),
            Text(
              'Role: $roleName • Allowed: ${allowed.join(", ")}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select QR Type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                ChoiceChip(
                  label: const Text('Borrow'),
                  selected: _selectedType == QrType.borrow,
                  onSelected: _canGenerateBorrow
                      ? (v) => setState(() => _selectedType = QrType.borrow)
                      : null,
                ),
                ChoiceChip(
                  label: const Text('Receive'),
                  selected: _selectedType == QrType.receive,
                  onSelected: _canGenerateReceiveReturn
                      ? (v) => setState(() => _selectedType = QrType.receive)
                      : null,
                ),
                ChoiceChip(
                  label: const Text('Return'),
                  selected: _selectedType == QrType.returnItem,
                  onSelected: _canGenerateReceiveReturn
                      ? (v) => setState(() => _selectedType = QrType.returnItem)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Instrument', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedInstrument,
              items: instruments.map((i) {
                return DropdownMenuItem<String>(
                  value: i.name,
                  child: Text(i.name),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedInstrument = v),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Select instrument',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.qr_code_2),
              label: const Text('Generate QR Code'),
            ),
            const SizedBox(height: 24),
            if (_payload != null) ...[
              const Text('Generated QR', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Center(child: QrCodeService.instance.buildQrWidget(_payload!, size: 220)),
              const SizedBox(height: 12),
              SelectableText(_payload!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
            const Spacer(),
            Card(
              elevation: 0,
              color: Colors.blue.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Access: Students—Borrow only; Admin/Staff—Receive/Return only',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generate() {
    if (_selectedType == null || _selectedInstrument == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a QR type and instrument')),
      );
      return;
    }
    try {
      final payload = QrCodeService.instance.buildPayload(
        type: _selectedType!,
        instrumentName: _selectedInstrument!,
      );
      setState(() => _payload = payload);
    } on QrPermissionException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }
}
