class User {
  String? id;
  String? email;
  String? name;
  String? token;
  String? role;
  String? ho;
  String? ten;
  String? avatar;
  String? status;

  User(
      { this.id ="",
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
    avatar = json['avatar']??"";
    name = json['name'];
    status = json['status'];
  }

}