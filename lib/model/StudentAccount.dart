class StudentAccount{
  String? accountId;
  String? lastName;
  String? firstName;
  String? email;
  String? studentId;

  StudentAccount(
      {this.accountId,
        this.lastName,
        this.firstName,
        this.email,
        this.studentId});

  StudentAccount.fromJson(Map<String, dynamic> json) {
    accountId = json['account_id'];
    lastName = json['last_name'];
    firstName = json['first_name'];
    email = json['email'];
    studentId = json['student_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_id'] = this.accountId;
    data['last_name'] = this.lastName;
    data['first_name'] = this.firstName;
    data['email'] = this.email;
    data['student_id'] = this.studentId;
    return data;
  }
}