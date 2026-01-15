import '../models/instrument.dart';
import '../models/request.dart';
import '../models/maintenance.dart';

/// GLOBAL instrument list
List<Instrument> instruments = [
  Instrument(
    id: 1,
    name: 'Microscope Olympus CX23',
    category: 'Microscopy',
    quantity: 5,
    available: 3,
    status: 'Available',
    condition: 'Good',
    location: 'Lab Room A',
  ),
];

/// GLOBAL student requests
List<InstrumentRequest> studentRequests = [];


List<MaintenanceLog> maintenanceLogs = [
  MaintenanceLog(
    id: 1,
    instrumentName: 'Centrifuge Machine',
    issue: 'Abnormal vibration',
    actionTaken: 'Bearing replacement',
    status: 'Completed',
    date: DateTime.now(),
  ),
];