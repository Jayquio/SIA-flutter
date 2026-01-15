import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/request.dart';

class RequestInstrumentScreen extends StatefulWidget {
  const RequestInstrumentScreen({super.key});

  @override
  State<RequestInstrumentScreen> createState() =>
      _RequestInstrumentScreenState();
}

class _RequestInstrumentScreenState extends State<RequestInstrumentScreen> {
  final _formKey = GlobalKey<FormState>();

  String instrument = 'Microscope Olympus CX23';
  final TextEditingController purpose = TextEditingController();

  void _submitRequest() {
    if (!_formKey.currentState!.validate()) return;

    studentRequests.add(
      InstrumentRequest(
        id: studentRequests.length + 1,
        instrumentName: instrument,
        purpose: purpose.text,
        status: 'Pending',
        dateRequested: DateTime.now(),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Request Instrument")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField(
                value: instrument,
                decoration:
                    const InputDecoration(labelText: "Select Instrument"),
                items: instruments
                    .map(
                      (i) => DropdownMenuItem(
                        value: i.name,
                        child: Text(i.name),
                      ),
                    )
                    .toList(),
                onChanged: (v) => instrument = v.toString(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: purpose,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Purpose of Use",
                  alignLabelWithHint: true,
                ),
                validator: (v) => v!.isEmpty ? "Purpose required" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitRequest,
                child: const Text("Submit Request"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
