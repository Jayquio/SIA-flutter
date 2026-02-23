class Instrument {
  final String name;
  final String category;
  final int quantity;
  int available;
  final String status;
  final String condition;
  final String location;
  final String lastMaintenance;
  final String? imageAsset;

  Instrument({
    required this.name,
    required this.category,
    required this.quantity,
    required this.available,
    required this.status,
    required this.condition,
    required this.location,
    required this.lastMaintenance,
    this.imageAsset,
  });
}
