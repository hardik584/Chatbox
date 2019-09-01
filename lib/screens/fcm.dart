import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
 

 

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String textValue = 'Hello World !';
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    // firebaseMessaging.configure(
    //   onLaunch: (Map<String, dynamic> msg) {
    //     print(" onLaunch called ${(msg)}");
    //   },
    //   onResume: (Map<String, dynamic> msg) {
    //     print(" onResume called ${(msg)}");
    //   },
    //   onMessage: (Map<String, dynamic> msg) {
    //     showNotification(msg);
    //     print(" onMessage called ${(msg)}");
    //   },
    // );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    firebaseMessaging.getToken().then((token) {
      update(token);
    });
  }

  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails(
      'sdffds dsffds',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, "This is title", "this is demo", platform);
  }

  update(String token) {
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/$token').set({"token": token});
    textValue = token;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: new AppBar(
          title: new Text('Push Notification'),
        ),
        body: new Center(
          child: new Column(
            children: <Widget>[
              new Text(
                textValue,
              )
            ],
          ),
        ),
      );
  }
}
   // bottomNavigationBar: Padding(
          //   padding:
          //       const EdgeInsets.only(bottom: 8, left: 8, top: 5, right: 3),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       Container(
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(30)),
          //         width: MediaQuery.of(context).size.width / 1.2,
          //         child: TextField(
          //           controller: msg,
          //           decoration: InputDecoration(
          //               contentPadding: EdgeInsets.all(
          //                 15,
          //               ),
          //               border: InputBorder.none,
          //               hintText: "Type a message",
          //               suffixIcon: IconButton(
          //                 icon: Icon(Icons.image),
          //                 onPressed: () {
          //                   showDialog(
          //                       context: context,
          //                       builder: (context) {
          //                         return AlertDialog(
          //                           title: Column(
          //                             children: <Widget>[
          //                               ListTile(
          //                                 title: Text(
          //                                   'Camera',
          //                                   style: TextStyle(
          //                                       fontFamily: 'Poppins'),
          //                                 ),
          //                                 onTap: () async {
          //                                   Navigator.pop(context);
          //                                   var tempImage =
          //                                       await ImagePicker.pickImage(
          //                                           source: ImageSource.camera);

          //                                   sampleImage = tempImage;
          //                                   if (sampleImage != null) {
          //                                     StorageReference
          //                                         storageReference =
          //                                         FirebaseStorage.instance
          //                                             .ref()
          //                                             .child("Chatbox")
          //                                             .child(
          //                                                 "$userId${widget.name.userId}${DateTime.now()}");
          //                                     StorageUploadTask uploadTask =
          //                                         storageReference
          //                                             .putFile(sampleImage);
          //                                     await uploadTask.onComplete
          //                                         .then((s) {
          //                                       s.ref
          //                                           .getDownloadURL()
          //                                           .then((s) {
          //                                         // _uploadedFileURL =
          //                                         //     s.toString();

          //                                         Message data = Message(
          //                                             isDeleted: "0",
          //                                             isDelivered: "0",
          //                                             isSeen: "0",
          //                                             messageDate:
          //                                                 DateTime.now()
          //                                                     .toString(),
          //                                             messageText: s.toString(),
          //                                             receiverId:
          //                                                 widget.name.userId,
          //                                             senderId: userId);

          //                                         messageReference
          //                                             .push()
          //                                             .set(data.toJson());
          //                                       });
          //                                     });
          //                                   }
          //                                 },
          //                               ),
          //                               ListTile(
          //                                 title: Text(
          //                                   'Gallery',
          //                                   style: TextStyle(
          //                                       fontFamily: 'Poppins'),
          //                                 ),
          //                                 onTap: () async {
          //                                   Navigator.pop(context);
          //                                   var tempImage =
          //                                       await ImagePicker.pickImage(
          //                                           source: ImageSource.gallery,
          //                                           imageQuality: 50);

          //                                   sampleImage = tempImage;
          //                                   StorageReference storageReference =
          //                                       FirebaseStorage.instance
          //                                           .ref()
          //                                           .child("Chatbox")
          //                                           .child(
          //                                               "$userId${widget.name.userId}${DateTime.now()}");
          //                                   if (sampleImage != null) {

          //                                    // Navigator.push(context,MaterialPageRoute(builder: (context)=>PhotoFather(abc: tempImage,)));
          //                                     StorageUploadTask uploadTask =
          //                                         storageReference
          //                                             .putFile(sampleImage);
          //                                     await uploadTask.onComplete
          //                                         .then((s) {
          //                                       s.ref
          //                                           .getDownloadURL()
          //                                           .then((s) {
          //                                         // _uploadedFileURL =
          //                                         //     s.toString();

          //                                         Message data = Message(
          //                                             isDeleted: "0",
          //                                             isDelivered: "0",
          //                                             isSeen: "0",
          //                                             messageDate:
          //                                                 DateTime.now()
          //                                                     .toString(),
          //                                             messageText: s.toString(),
          //                                             receiverId:
          //                                                 widget.name.userId,
          //                                             senderId: userId);

          //                                         messageReference.push().set(
          //                                               data.toJson(),
          //                                             );
          //                                       });
          //                                     });
          //                                   }
          //                                 },
          //                               ),
          //                             ],
          //                           ),
          //                         );
          //                       });
          //                 },
          //               )),
          //         ),
          //       ),
          //       CircleAvatar(
          //         maxRadius: 22,
          //         child: IconButton(
          //           onPressed: () {
          //             if (msg.text.isNotEmpty) {
          //               Message data = Message(
          //                   isDeleted: "0",
          //                   isDelivered: "0",
          //                   isSeen: "0",
          //                   messageDate: DateTime.now().toString(),
          //                   messageText: msg.text,
          //                   receiverId: widget.name.userId,
          //                   senderId: userId);
          //               messageReference.push().set(data.toJson());
          //               setState(() {
          //                 msg = TextEditingController();
          //               });
          //             }
          //           },
          //           icon: Icon(
          //             Icons.send,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),