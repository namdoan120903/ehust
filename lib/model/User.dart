class User {
  int? id;
  String? username;
  String? token;
  String? role;
  String? ho;
  String? ten;
  String? avatar;

  User(
      { this.id =0,
         this.username="",
         this.token="",
         this.role="",
        this.ho="",
        this.ten="",
        this.avatar=""
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['user_name'];
    token = json['token'];
    role = json['role'];
    ho = json['ho'];
    ten = json['ten'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['token'] = this.token;
    data['role'] = this.role;
    data['ho'] = this.ho;
    data['ten'] = this.ten;
    data['avatar'] = this.avatar;

    return data;
  }
}