import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/instrument.dart';
import '../common/barcode_scanner_screen.dart';

class InstrumentFormScreen extends StatefulWidget {
  final Instrument? instrument;

  const InstrumentFormScreen({super.key, this.instrument});

  @override
  State<InstrumentFormScreen> createState() => _InstrumentFormScreenState();
}

class _InstrumentFormScreenState extends State<InstrumentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController name;
  late TextEditingController category;
  late TextEditingController quantity;
  late TextEditingController available;
  late TextEditingController location;

  String status = 'Available';
  String condition = 'Good';

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.instrument?.name ?? '');
    category = TextEditingController(text: widget.instrument?.category ?? '');
    quantity = TextEditingController(
        text: widget.instrument?.quantity.toString() ?? '');
    available = TextEditingController(
        text: widget.instrument?.available.toString() ?? '');
    location = TextEditingController(text: widget.instrument?.location ?? '');
    status = widget.instrument?.status ?? 'Available';
    condition = widget.instrument?.condition ?? 'Good';
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.instrument == null) {
      instruments.add(
        Instrument(
          id: DateTime.now().millisecondsSinceEpoch,
          name: name.text,
          category: category.text,
          quantity: int.parse(quantity.text),
          available: int.parse(available.text),
          status: status,
          condition: condition,
          location: location.text,
        ),
      );
    } else {
      widget.instrument!
        ..name = name.text
        ..category = category.text
        ..quantity = int.parse(quantity.text)
        ..available = int.parse(available.text)
        ..status = status
        ..condition = condition
        ..location = location.text;
    }

    Navigator.pop(context);
  }

  /// 🔍 Opens barcode / QR scanner
  Future<void> _scanCode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BarcodeScannerScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        name.text = result; // For now, place scanned code in name field
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.instrument == null ? "Add Instrument" : "Edit Instrument",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              /// 🔹 Instrument Name + Scan Button
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: name,
                      decoration: const InputDecoration(
                        labelText: "Instrument Name / Code",
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    tooltip: "Scan Barcode / QR",
                    onPressed: _scanCode,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: category,
                decoration: const InputDecoration(labelText: "Category"),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: quantity,
                decoration:
                    const InputDecoration(labelText: "Total Quantity"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: available,
                decoration:
                    const InputDecoration(labelText: "Available Quantity"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: status,
                decoration: const InputDecoration(labelText: "Status"),
                items: const [
                  DropdownMenuItem(
                      value: 'Available', child: Text('Available')),
                  DropdownMenuItem(value: 'In-Use', child: Text('In-Use')),
                  DropdownMenuItem(
                      value: 'Under Maintenance',
                      child: Text('Under Maintenance')),
                ],
                onChanged: (v) => status = v!,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: condition,
                decoration: const InputDecoration(labelText: "Condition"),
                items: const [
                  DropdownMenuItem(
                      value: 'Excellent', child: Text('Excellent')),
                  DropdownMenuItem(value: 'Good', child: Text('Good')),
                  DropdownMenuItem(value: 'Fair', child: Text('Fair')),
                  DropdownMenuItem(
                      value: 'Needs Repair',
                      child: Text('Needs Repair')),
                ],
                onChanged: (v) => condition = v!,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: location,
                decoration: const InputDecoration(labelText: "Location"),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _save,
                child: const Text("Save Instrument"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
