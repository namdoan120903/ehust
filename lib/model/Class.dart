import 'package:intl/intl.dart';

import 'StudentAccount.dart';

class Class {
  int? id;
  String? classId;
  String? className;
  String? attachedCode;
  String? classType;
  String? lecturerName;
  String? studentCount;
  String? startDate;
  String? endDate;
  String? status;
  List<StudentAccount>? studentAccounts;

  Class(
      {this.id=0,
        this.classId="",
        this.className="",
        this.attachedCode="",
        this.classType="",
        this.lecturerName="",
        this.studentCount="",
        this.startDate="",
        this.endDate="",
        this.status="",
        this.studentAccounts});

  Class.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classId = json['class_id'];
    className = json['class_name'];
    attachedCode = json['attached_code'];
    classType = json['class_type'];
    lecturerName = json['lecturer_name'];
    studentCount = json['student_count'];
    DateTime parsedDate = DateTime.parse(json['start_date']);
    startDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    DateTime parsedDate1 = DateTime.parse(json['end_date']);
    endDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    status = json['status'];
    if (json['student_accounts'] != null) {
      studentAccounts = <StudentAccount>[];
      json['student_accounts'].forEach((v) {
        studentAccounts!.add(new StudentAccount.fromJson(v));
      });
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Class && other.classId == classId;
  }

  @override
  int get hashCode => classId.hashCode;
}