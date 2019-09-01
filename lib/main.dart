import 'package:chatbox/screens/home.dart';
import 'package:chatbox/screens/loginpage.dart';
 
import 'package:chatbox/screens/signuppage.dart';
import 'package:chatbox/screens/spalshpage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
 
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
 

void main() => runApp(new FlutterChatApp());

class FlutterChatApp extends StatefulWidget {
  @override
  _FlutterChatAppState createState() => _FlutterChatAppState();
}

class _FlutterChatAppState extends State<FlutterChatApp> {
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

    firebaseMessaging.configure(
      
      onLaunch: (Map<String, dynamic> msg) {
        
        print(" onLaunch called ${(msg)}");
        return null;
      },
      onResume: (Map<String, dynamic> msg) {
        
        print(" onResume called ${(msg)}");
         return null;
      },
      onMessage: (Map<String, dynamic> msg) {
        print(" onMessage called ${(msg)}");
        showNotification(msg);
         return null;
      },
    );
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
    return new MaterialApp(
       
      debugShowCheckedModeBanner: false,
      title: "Flutter Chat App",
      
      
      initialRoute: '/',
      routes: <String,WidgetBuilder>
      {
        '/':(context)=>SpalshPage(),
        '/register':(context)=>ChatSignUpPage(),
        '/login':(context)=>ChatLoginPage(),
        '/home':(context)=>WhatsAppHome()
      },


    );
  }
}
 