import 'StudentAccount.dart';

class Class {
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
      {this.classId="",
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
    classId = json['class_id'];
    className = json['class_name'];
    attachedCode = json['attached_code'];
    classType = json['class_type'];
    lecturerName = json['lecturer_name'];
    studentCount = json['student_count'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    if (json['student_accounts'] != null) {
      studentAccounts = <StudentAccount>[];
      json['student_accounts'].forEach((v) {
        studentAccounts!.add(new StudentAccount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['class_id'] = this.classId;
    data['class_name'] = this.className;
    data['attached_code'] = this.attachedCode;
    data['class_type'] = this.classType;
    data['lecturer_name'] = this.lecturerName;
    data['student_count'] = this.studentCount;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['status'] = this.status;
    if (this.studentAccounts != null) {
      data['student_accounts'] =
          this.studentAccounts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Class && other.classId == classId;
  }

  @override
  int get hashCode => classId.hashCode;
}