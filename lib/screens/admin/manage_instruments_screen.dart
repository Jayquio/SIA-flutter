import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/instrument.dart';
import 'instrument_form_screen.dart';

class ManageInstrumentsScreen extends StatefulWidget {
  const ManageInstrumentsScreen({super.key});

  @override
  State<ManageInstrumentsScreen> createState() =>
      _ManageInstrumentsScreenState();
}

class _ManageInstrumentsScreenState extends State<ManageInstrumentsScreen> {

  void _deleteInstrument(int id) {
    setState(() {
      instruments.removeWhere((inst) => inst.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Instruments"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InstrumentFormScreen(),
                ),
              );
              setState(() {});
            },
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: instruments.length,
        itemBuilder: (context, index) {
          final Instrument inst = instruments[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(inst.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Category: ${inst.category}"),
                  Text("Available: ${inst.available}/${inst.quantity}"),
                  Text("Status: ${inst.status}"),
                  Text("Location: ${inst.location}"),
                ],
              ),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            InstrumentFormScreen(instrument: inst),
                      ),
                    ).then((_) => setState(() {}));
                  } else if (value == 'delete') {
                    _deleteInstrument(inst.id);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text("Edit")),
                  const PopupMenuItem(value: 'delete', child: Text("Delete")),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
