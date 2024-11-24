class StudentAttendance {
  final String id;
  final String name;
  final String accountId;
  String attendanceStatus = "NOT_ABSENCE";

  StudentAttendance({
    required this.accountId,
    required this.id,
    required this.name,
  });
}
