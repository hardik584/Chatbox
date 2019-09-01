// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';

Message messageFromJson(String str,String key) => Message.fromJson(json.decode(str),key);

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
    String messageId;
    String messageText;
    String senderId;
    String receiverId;
    String messageDate;
    String isSeen;
    String isDeleted;
    String isDelivered;
    String seenBy;

    Message({
        this.messageText,
        this.senderId,
        this.receiverId,
        this.messageDate,
        this.isSeen,
        this.isDeleted,
        this.isDelivered,
        this.messageId,
        this.seenBy
    });

    factory Message.fromJson(Map<dynamic, dynamic> json,String key) => new Message(
        messageText: json["message_text"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        messageDate: json["message_date"],
        isSeen: json["is_seen"],
        isDeleted: json["is_deleted"],
        isDelivered: json["is_delivered"],
        seenBy: json["seen_by"],
        messageId: key

    );

    Map<String, dynamic> toJson() => {
        "message_text": messageText,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message_date": messageDate,
        "is_seen": isSeen,
        "is_deleted": isDeleted,
        "is_delivered": isDelivered,
        "seen_by": seenBy,
    };
}