class StudentAttendanceRecord {
  final String attendanceId;
  final String studentId;
  String status;

  // Constructor
  StudentAttendanceRecord({
    required this.attendanceId,
    required this.studentId,
    required this.status,
  });

  // A method to convert the Attendance object to a map (useful for saving to databases or sending data)
  Map<String, dynamic> toMap() {
    return {
      'attendance_id': attendanceId,
      'student_id': studentId,
      'status': status,
    };
  }

  // A method to create an Attendance object from a map (useful for reading data from a database)
  factory StudentAttendanceRecord.fromMap(Map<String, dynamic> map) {
    return StudentAttendanceRecord(
      attendanceId: map['attendance_id'],
      studentId: map['student_id'],
      status: map['status'],
    );
  }

  @override
  String toString() {
    return 'StudentAttendanceRecord(attendance_id: $attendanceId, student_id: $studentId, status: $status)';
  }
}
