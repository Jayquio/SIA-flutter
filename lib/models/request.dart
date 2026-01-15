class InstrumentRequest {
  int id;
  String instrumentName;
  String purpose;
  String status;
  DateTime dateRequested;

  InstrumentRequest({
    required this.id,
    required this.instrumentName,
    required this.purpose,
    required this.status,
    required this.dateRequested,
  });
}
