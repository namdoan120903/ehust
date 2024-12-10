import 'package:intl/intl.dart';
import 'package:project/model/StudentAccount.dart';

class Absence {
  String? id;
  StudentAccount? studentAccount;
  String? absenceDate;
  String? title;
  String? reason;
  String? status;
  String? fileUrl;
  String? classId;

  Absence(
      {this.id,
        this.studentAccount,
        this.absenceDate,
        this.title,
        this.reason,
        this.status,
        this.fileUrl,
        this.classId});

  Absence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentAccount = json['student_account'] != null
        ? new StudentAccount.fromJson(json['student_account'])
        : null;
    DateTime parsedDate = DateTime.parse(json['absence_date']);
    absenceDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    title = json['title'];
    reason = json['reason'];
    status = json['status'];
    fileUrl = json['file_url'];
    classId = json['class_id'];
  }
}