import 'dart:async';

import 'package:chatbox/models/message.dart';
import 'package:chatbox/models/user.dart';
import 'package:chatbox/screens/chat_inside.dart';
import 'package:chatbox/screens/imagefilter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'dart:convert';
import 'chat_screen.dart';
 

final userReference =
    FirebaseDatabase.instance.reference().child('user_master');
final messageReference =
    FirebaseDatabase.instance.reference().child('message_master');

class WhatsAppHome extends StatefulWidget {
  WhatsAppHome();

  @override
  _WhatsAppHomeState createState() => new _WhatsAppHomeState();
}

class _WhatsAppHomeState extends State<WhatsAppHome>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Notification> notifications = [];
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 1, length: 2);
    getUserList();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> notification) async {
        setState(() {
          notifications.add(
            Notification(
              title: notification["notification"]["title"],
              body: notification["notification"]["body"],
              color: Colors.red,
            ),
          );
        });
      },
      onLaunch: (Map<String, dynamic> notification) async {
        setState(() {
          notifications.add(
            Notification(
              title: notification["notification"]["title"],
              body: notification["notification"]["body"],
              color: Colors.green,
            ),
          );
        });
      },
      onResume: (Map<String, dynamic> notification) async {
        setState(() {
          notifications.add(
            Notification(
              title: notification["notification"]["title"],
              body: notification["notification"]["body"],
              color: Colors.blue,
            ),
          );
        });
      },
    );
  }

  List<User> userList = List();
  String userId = '';
  getUserList() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    userId = pre.getString("user_id");

    userReference.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        userList = List();
        Map<dynamic, dynamic> temp = snapshot.value;
        setState(() {
          for (var key in temp.keys) {
            User e = User.fromJson(temp[key], key: key);
            if (e.userId != userId) {
              userList.add(e);
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ChatBox"),
        elevation: 0.7,
        bottom: new TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            new Tab(text: "Chat"),
            new Tab(
              text: "Contact",
            ),
          ],
        ),
        actions: <Widget>[
          new Icon(Icons.search),
          new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
          ),
          new Icon(Icons.more_vert),
        ],
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new ChatScreen(),
          new StatusScreen(userId),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          child: new Icon(
            Icons.message,
            color: Colors.white,
          ),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => WbView()))),
    );
  }
}

class StatusScreen extends StatefulWidget {
  final String userId;
  StatusScreen(this.userId);

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String tempId = '';
   _getRequests()async{
     tempId = '';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userReference.onValue,
      builder: (context, snapshot) {
        print("Home page Called");
        if (snapshot.hasData == false) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Center(child: new CircularProgressIndicator());
            default:
              return Container(
                child: Center(
                  child: Text("No"),
                ),
              );
          }
        }

        List<User> userList = List();

        Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

        for (var key in map.keys) {
          User e = User.fromJson(map[key], key: key);
          if (e.userId != widget.userId) {
            userList.add(e);
          }
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            return StreamBuilder(
                stream: messageReference
                    .orderByChild("is_seen")
                    .equalTo("0")
                    .onValue,
                builder: (context, snapshot1) {
                  print("Home page Called");
                  List<Message> messageList = List();
                  if (snapshot1.hasData == true) {
                    Map<dynamic, dynamic> temp = snapshot1.data.snapshot.value;

                    if (temp != null) {
                      for (var key in temp.keys) {
                        messageList.add(Message.fromJson(temp[key], key));
                      }
                    }
                  }

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Center(child: new CircularProgressIndicator());
                    default:
                      return ListView.separated(
                        itemCount: userList.length,
                        separatorBuilder: (c, i) {
                          return Divider(
                            color: Colors.grey.withOpacity(0.5),
                            height: 2,
                          );
                        },
                        itemBuilder: (b, i) {
                          int temp = 0;

                          if (messageList.isNotEmpty) {
                            for (int j = 0; j < messageList.length; j++) {
                              if (messageList[j].receiverId == widget.userId &&
                                  messageList[j].senderId ==
                                      userList[i].userId) {
                                if (messageList[j].senderId == tempId) {
                                  print("enjoy");
                                } else {
                                  Message isDel = messageList[j];
                                  isDel.isDelivered = "1";
                                  messageReference
                                      .child(isDel.messageId)
                                      .update(isDel.toJson());
                                  temp++;
                                }
                              }
                            }
                          }

                          return ListTile(
                            onTap: () {
                             tempId =userList[i].userId;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                            name: userList[i],
                                          ))).then((val)=>val?_getRequests():null);
                            },
                            leading: CircleAvatar(
                              child:
                                  Text(userList[i].userName[0].toUpperCase()),
                            ),
                            title: Text(userList[i].userName),
                            subtitle: Text(userList[i].userContact),
                            trailing: temp == 0
                                ? Offstage()
                                : CircleAvatar(
                                    child: Text(temp.toString()),
                                    backgroundColor: Colors.amber,
                                    maxRadius: 15,
                                  ),
                          );
                        },
                      );
                  }
                });
        }
      },
    );
  }
}
// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

Notification notificationFromJson(String str) =>
    Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
  String title;
  String body;
  Color color;

  Notification({
    this.title,
    this.body,
    this.color,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => new Notification(
        title: json["title"],
        body: json["body"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "color": color,
      };
}

class WbView extends StatefulWidget {
  WbView({Key key}) : super(key: key);

  _WbViewState createState() => _WbViewState();
}
//chirag.jogani203@gmail.com pass:chirag123
class _WbViewState extends State<WbView> {
   final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title:Text("Enjoy flutter with me"),),
      body: WebView(
        initialUrl: "http://www.thefuchsiaos.tech",
        javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },

      ),
    );
  }
}