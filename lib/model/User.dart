class User {
  int? id;
  String? email;
  String? name;
  String? token;
  String? role;
  String? ho;
  String? ten;
  String? avatar;
  String? status;

  User(
      { this.id =0,
         this.email="",
         this.token="",
         this.role="",
        this.ho="",
        this.ten="",
        this.avatar="",
        this.name = "",
        this.status = ""
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    token = json['token'];
    role = json['role'];
    ho = json['ho'];
    ten = json['ten'];
    avatar = json['avatar'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['token'] = this.token;
    data['role'] = this.role;
    data['ho'] = this.ho;
    data['ten'] = this.ten;
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['status'] = this.status;

    return data;
  }
}