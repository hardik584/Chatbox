// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

// class User {
//   String userKey;
//   String userId;
//   String userName;
//   String userContact;
//   String userProfileUrl;
//   String userToken;

//   User(
//       {this.userProfileUrl,
//       this.userKey,
//       this.userId,
//       this.userName,
//       this.userContact,
//       this.userToken});

//   factory User.fromJson(Map<dynamic, dynamic> json, String key) => new User(
//       userName: json["user_name"],
//       userContact: json["user_contact"],
//       userToken: json["user_token"],
//       userId: json["user_id"],
//       userProfileUrl:
//           json["user_profile_url"] == null ? null : json["user_profile_url"],
//       userKey: key);

//   Map<String, dynamic> toJson() => {
//         "user_name": userName,
//         "user_contact": userContact,
//         "user_token": userToken,
//         "user_id": userId,
//         "user_profile_url": userProfileUrl,
//       };
//   @override
//   String toString() {
//     return "  $userKey $userId";
//   }
// }

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String userKey;
    String userContact;
    String userId;
    String userName;
    String userToken;

    User({
        this.userContact,
        this.userId,
        this.userName,
        this.userToken,
        this.userKey
    });

    factory User.fromJson(Map<dynamic, dynamic> json,{String key}) => new User(
        userContact: json["user_contact"],
        userId: json["user_id"],
        userName: json["user_name"],
        userToken: json["user_token"],
        userKey: key

    );

    Map<String, dynamic> toJson() => {
        "user_contact": userContact,
        "user_id": userId,
        "user_name": userName,
        "user_token": userToken,
    };
}
