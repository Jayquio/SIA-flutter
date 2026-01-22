// lib/screens/admin/manage_instruments_screen.dart

import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/instrument.dart';

class ManageInstrumentsScreen extends StatefulWidget {
  const ManageInstrumentsScreen({super.key});

  @override
  State<ManageInstrumentsScreen> createState() => _ManageInstrumentsScreenState();
}

class _ManageInstrumentsScreenState extends State<ManageInstrumentsScreen> {
  late List<Instrument> _instruments;

  @override
  void initState() {
    super.initState();
    _instruments = List.from(instruments); // Copy the list
  }

  void _addInstrument() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final categoryController = TextEditingController();
        final quantityController = TextEditingController();
        final availableController = TextEditingController();
        final statusController = TextEditingController();
        final conditionController = TextEditingController();
        final locationController = TextEditingController();
        final lastMaintenanceController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Instrument'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
                TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
                TextField(controller: availableController, decoration: const InputDecoration(labelText: 'Available'), keyboardType: TextInputType.number),
                TextField(controller: statusController, decoration: const InputDecoration(labelText: 'Status')),
                TextField(controller: conditionController, decoration: const InputDecoration(labelText: 'Condition')),
                TextField(controller: locationController, decoration: const InputDecoration(labelText: 'Location')),
                TextField(controller: lastMaintenanceController, decoration: const InputDecoration(labelText: 'Last Maintenance')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newInstrument = Instrument(
                  name: nameController.text,
                  category: categoryController.text,
                  quantity: int.tryParse(quantityController.text) ?? 0,
                  available: int.tryParse(availableController.text) ?? 0,
                  status: statusController.text,
                  condition: conditionController.text,
                  location: locationController.text,
                  lastMaintenance: lastMaintenanceController.text,
                );
                setState(() {
                  _instruments.add(newInstrument);
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editInstrument(int index) {
    final instrument = _instruments[index];
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: instrument.name);
        final categoryController = TextEditingController(text: instrument.category);
        final quantityController = TextEditingController(text: instrument.quantity.toString());
        final availableController = TextEditingController(text: instrument.available.toString());
        final statusController = TextEditingController(text: instrument.status);
        final conditionController = TextEditingController(text: instrument.condition);
        final locationController = TextEditingController(text: instrument.location);
        final lastMaintenanceController = TextEditingController(text: instrument.lastMaintenance);

        return AlertDialog(
          title: const Text('Edit Instrument'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
                TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
                TextField(controller: availableController, decoration: const InputDecoration(labelText: 'Available'), keyboardType: TextInputType.number),
                TextField(controller: statusController, decoration: const InputDecoration(labelText: 'Status')),
                TextField(controller: conditionController, decoration: const InputDecoration(labelText: 'Condition')),
                TextField(controller: locationController, decoration: const InputDecoration(labelText: 'Location')),
                TextField(controller: lastMaintenanceController, decoration: const InputDecoration(labelText: 'Last Maintenance')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedInstrument = Instrument(
                  name: nameController.text,
                  category: categoryController.text,
                  quantity: int.tryParse(quantityController.text) ?? 0,
                  available: int.tryParse(availableController.text) ?? 0,
                  status: statusController.text,
                  condition: conditionController.text,
                  location: locationController.text,
                  lastMaintenance: lastMaintenanceController.text,
                );
                setState(() {
                  _instruments[index] = updatedInstrument;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteInstrument(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Instrument'),
        content: const Text('Are you sure you want to delete this instrument?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _instruments.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Instruments")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _addInstrument,
              child: const Text('Add New Instrument'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _instruments.length,
              itemBuilder: (context, index) {
                final instrument = _instruments[index];
                return Card(
                  elevation: 6,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          instrument.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text("Category: ${instrument.category}"),
                        const SizedBox(height: 6),
                        Text("Quantity: ${instrument.quantity}"),
                        const SizedBox(height: 6),
                        Text("Available: ${instrument.available}"),
                        const SizedBox(height: 6),
                        Text("Status: ${instrument.status}"),
                        const SizedBox(height: 6),
                        Text("Condition: ${instrument.condition}"),
                        const SizedBox(height: 6),
                        Text("Location: ${instrument.location}"),
                        const SizedBox(height: 6),
                        Text("Last Maintenance: ${instrument.lastMaintenance}"),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => _editInstrument(index),
                              child: const Text("Edit"),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () => _deleteInstrument(index),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
