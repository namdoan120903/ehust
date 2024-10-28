class User {
  int? id;
  String? username;
  String? token;
  String? role;

  User(
      { this.id =0,
         this.username="",
         this.token="",
         this.role="",
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    token = json['token'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['token'] = this.token;
    data['role'] = this.role;
    return data;
  }
}