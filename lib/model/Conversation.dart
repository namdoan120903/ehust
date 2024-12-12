class Conversation {
  int? id;
  Partner? partner;
  LastMessage? lastMessage;
  String? createdAt;
  String? updatedAt;

  Conversation(
      {this.id,
        this.partner,
        this.lastMessage,
        this.createdAt,
        this.updatedAt});

  Conversation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    partner =
    json['partner'] != null ? new Partner.fromJson(json['partner']) : null;
    lastMessage = json['last_message'] != null
        ? new LastMessage.fromJson(json['last_message'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.partner != null) {
      data['partner'] = this.partner!.toJson();
    }
    if (this.lastMessage != null) {
      data['last_message'] = this.lastMessage!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Partner {
  int? id;
  String? name;
  String? avatar;

  Partner({this.id, this.name, this.avatar});

  Partner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    return data;
  }
}

class LastMessage {
  Partner? sender;
  String? message;
  String? createdAt;
  int? unread;

  LastMessage({this.sender, this.message, this.createdAt, this.unread});

  LastMessage.fromJson(Map<String, dynamic> json) {
    sender =
    json['sender'] != null ? new Partner.fromJson(json['sender']) : null;
    message = json['message'];
    createdAt = json['created_at'];
    unread = json['unread'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    data['unread'] = this.unread;
    return data;
  }
}