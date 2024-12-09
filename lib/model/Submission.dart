import 'dart:ffi';

import 'StudentAccount.dart';

class Submission{
  int? id;
  int? assignmentId;
  String? submissionTime;
  String? grade;
  String? fileUrl;
  String? textResponse;
  StudentAccount? studentAccount;

  Submission(
      {this.id,
        this.assignmentId,
        this.submissionTime,
        this.grade="",
        this.fileUrl,
        this.textResponse,
        this.studentAccount});

  Submission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assignmentId = json['assignment_id'];
    submissionTime = json['submission_time'];
    grade = json['grade'] is double ? json['grade'].toString():json['grade'];
    fileUrl = json['file_url'];
    textResponse = json['text_response'];
    studentAccount = json['student_account'] != null
        ? new StudentAccount.fromJson(json['student_account'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['assignment_id'] = this.assignmentId;
    data['submission_time'] = this.submissionTime;
    data['grade'] = this.grade;
    data['file_url'] = this.fileUrl;
    data['text_response'] = this.textResponse;
    if (this.studentAccount != null) {
      data['student_account'] = this.studentAccount!.toJson();
    }
    return data;
  }

}