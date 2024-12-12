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

}

class LastMessage {
  String? messageId;
  Partner? sender;
  String? message;
  String? createdAt;
  int? unread;

  LastMessage({this.messageId,this.sender, this.message, this.createdAt, this.unread});

  LastMessage.fromJson(Map<String, dynamic> json) {
    sender =
    json['sender'] != null ? new Partner.fromJson(json['sender']) : null;
    message = json['message'];
    createdAt = json['created_at'];
    unread = json['unread'];
    messageId = json['message_id'];
  }

}