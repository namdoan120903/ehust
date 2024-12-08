import 'package:intl/intl.dart';

class Survey {
  int? id;
  String? title;
  String? description;
  int? lecturerId;
  String? deadline;
  String? fileUrl;
  String? classId;
  bool? is_submitted;
  String? grade;


  Survey(
      {this.id=0,
        this.title="",
        this.description="",
        this.lecturerId=0,
        this.deadline="",
        this.fileUrl="",
        this.classId="",
      this.is_submitted });

  Survey.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    lecturerId = json['lecturer_id'] is String
        ? int.tryParse(json['lecturer_id']) // Nếu là String thì chuyển sang int
        : json['lecturer_id'];
    deadline = json['deadline'];
    fileUrl = json['file_url'];
    classId = json['class_id'];
    is_submitted = json['is_submitted'];
    grade = json['grade'];
  }

}