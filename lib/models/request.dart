enum RequestStatus { pending, approved, rejected, returned }

class Request {
  final String studentName;
  final String instrumentName;
  final String purpose;
  RequestStatus status;

  Request({
    required this.studentName,
    required this.instrumentName,
    required this.purpose,
    required this.status,
  });
}
