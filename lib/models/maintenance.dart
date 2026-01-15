class MaintenanceLog {
  int id;
  String instrumentName;
  String issue;
  String actionTaken;
  String status;
  DateTime date;

  MaintenanceLog({
    required this.id,
    required this.instrumentName,
    required this.issue,
    required this.actionTaken,
    required this.status,
    required this.date,
  });
}
