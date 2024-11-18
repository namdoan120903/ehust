class Survey {
  int? id;
  String? title;
  String? description;
  int? lecturerId;
  String? deadline;
  String? fileUrl;
  String? classId;
  bool? is_submitted;
  int? grade;


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
    lecturerId = json['lecturer_id'];
    deadline = json['deadline'];
    fileUrl = json['file_url'];
    classId = json['class_id'];
    is_submitted = json['is_submitted'];
    grade = json['grade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['lecturer_id'] = this.lecturerId;
    data['deadline'] = this.deadline;
    data['file_url'] = this.fileUrl;
    data['class_id'] = this.classId;
    data['is_submitted'] = this.is_submitted;
    data['grade'] = this.grade;
    return data;
  }
}