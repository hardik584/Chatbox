import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chatbox/models/message.dart';
import 'package:chatbox/models/user.dart';
import 'package:chatbox/screens/const.dart';
import 'package:chatbox/screens/imagefilter.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final User name;
  ChatPage({Key key, this.name}) : super(key: key);

  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageReference =
      FirebaseDatabase.instance.reference().child('message_master');
  List<Message> msgList = List();

  String userId = "";
  StreamSubscription<ConnectivityResult> subscription;

  bool result = true;
  bool internet = true;
  final FocusNode focusNode = new FocusNode();

  bool isShowSticker;
  List<String> imageUrl = [
    "https://firebasestorage.googleapis.com/v0/b/chatbox-ce822.appspot.com/o/Post%20Picture%2Fmimi1.gif?alt=media&token=1e490f12-2005-48cc-9c51-98739b703f61",
    "https://firebasestorage.googleapis.com/v0/b/chatbox-ce822.appspot.com/o/Post%20Picture%2Fmimi2.gif?alt=media&token=2955f127-3831-44fa-b70f-f9d8df71c586",
    "https://firebasestorage.googleapis.com/v0/b/chatbox-ce822.appspot.com/o/Post%20Picture%2Fmimi3.gif?alt=media&token=472e4384-57bb-4249-8a54-50d571caa83f",
    "https://firebasestorage.googleapis.com/v0/b/chatbox-ce822.appspot.com/o/Post%20Picture%2Fmimi4.gif?alt=media&token=05679ae7-9a1c-414a-9dea-beeac8a01054",
    "https://firebasestorage.googleapis.com/v0/b/chatbox-ce822.appspot.com/o/Post%20Picture%2Fmimi5.gif?alt=media&token=97421156-063b-4c56-b991-376384a97f20",
    "https://firebasestorage.googleapis.com/v0/b/chatbox-ce822.appspot.com/o/Post%20Picture%2Fmimi6.gif?alt=media&token=89e364ac-3aeb-4c3a-b454-ed8451386749",
    "https://firebasestorage.googleapis.com/v0/b/chatbox-ce822.appspot.com/o/Post%20Picture%2Fmimi7.gif?alt=media&token=fa2cf014-4559-4987-b749-d58754754533",
    "https://firebasestorage.googleapis.com/v0/b/chatbox-ce822.appspot.com/o/Post%20Picture%2Fmimi8.gif?alt=media&token=06cda37a-510f-4d27-b74a-21a328a8f640",
    "https://firebasestorage.googleapis.com/v0/b/chatbox-ce822.appspot.com/o/Post%20Picture%2F485173417511878678.gif?alt=media&token=73d84182-4a36-4e91-a913-0668cb6b6881"
  ];
  File sampleImage;

  double emoji = 50;
  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    isShowSticker = false;
    getUserId();
    _controller = ScrollController();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          result = false;
        });
      } else if (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile) {
        setState(() {
          result = true;
        });
      }
    });
  }

  Future<ByteData> loadAsset() async {
    return await rootBundle.load('assets/images/mimi1.gif');
  }

  sendEmoji(int a) {
    getSticker();
    Message data = Message(
        isDeleted: "0",
        isDelivered: "0",
        isSeen: "0",
        messageDate: DateTime.now().toString(),
        messageText: imageUrl[a - 1],
        receiverId: widget.name.userId,
        senderId: userId);

    messageReference.push().set(
          data.toJson(),
        );
  }

  Widget buildSticker() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => sendEmoji(1),
                  child: new Image.network(
                    imageUrl[0],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => sendEmoji(2),
                  child: new Image.network(
                    imageUrl[1],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => sendEmoji(3),
                  child: new Image.network(
                    imageUrl[2],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => sendEmoji(4),
                  child: new Image.network(
                    imageUrl[3],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => sendEmoji(5),
                  child: new Image.network(
                    imageUrl[4],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => sendEmoji(6),
                  child: new Image.network(
                    imageUrl[5],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => sendEmoji(7),
                  child: new Image.network(
                    imageUrl[6],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => sendEmoji(8),
                  child: new Image.network(
                    imageUrl[7],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => sendEmoji(9),
                  child: new Image.network(
                    imageUrl[8],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => sendEmoji(1),
                  child: new Image.network(
                    imageUrl[0],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => sendEmoji(2),
                  child: new Image.network(
                    imageUrl[1],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => sendEmoji(3),
                  child: new Image.network(
                    imageUrl[2],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => sendEmoji(1),
                  child: new Image.network(
                    imageUrl[0],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => sendEmoji(2),
                  child: new Image.network(
                    imageUrl[1],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => sendEmoji(3),
                  child: new Image.network(
                    imageUrl[2],
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: Colors.amber, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
        emoji = 50;
      });
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
      if (isShowSticker) {
        emoji = 230;
      } else {
        emoji = 50;
      }
    });
  }

  Future<bool> internetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      internet = true;

      return true;
    } else {
      internet = false;

      return false;
    }
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString("user_id");
  }

  TextEditingController msg = TextEditingController();
  ScrollNotification abc;
  ScrollController _controller;
  Future<bool> back() async {
    Navigator.pop(context, true);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 1000),
        () => _controller.jumpTo(_controller.position.maxScrollExtent));
    return WillPopScope(
      onWillPop: back,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        primary: true,
        appBar: AppBar(
          titleSpacing: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                child: Text(widget.name.userName[0]),
                backgroundColor: Color.fromRGBO(236, 229, 221, 1.0),
              ),
              SizedBox(
                width: 5,
              ),
              Text(widget.name.userName),
            ],
          ),
        ),
        body: Scaffold(
          backgroundColor: Colors.blueGrey.withOpacity(0.5),
          resizeToAvoidBottomInset: true,
          resizeToAvoidBottomPadding: true,
          body: StreamBuilder(
            stream: messageReference.onValue,
            builder: (context, snapshot) {
              print("Chat Screen Called");
              List<Message> abc = List();

              if (!snapshot.hasData) return Container();
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
              if (map != null) {
                for (var key in map.keys) {
                  Message temp = Message.fromJson(map[key], key);
                  if ((temp.senderId == userId &&
                          temp.receiverId == widget.name.userId) ||
                      (temp.senderId == widget.name.userId &&
                          temp.receiverId == userId)) {
                    abc.add(Message.fromJson(map[key], key));
                  }
                }
              }
              for (int index = 0; index < abc.length; index++) {
                if (abc[index].receiverId == userId) {
                  if (abc[index].isSeen != "1") {
                    if (abc[index].isSeen == "0" ||
                        abc[index].isDelivered == "0") {
                      Message temp = abc[index];
                      //  temp.isDelivered = "1";
                      temp.isSeen = "1";
                      temp.isDelivered = "1";

                      messageReference
                          .child(abc[index].messageId)
                          .update(temp.toJson());
                    }
                  }
                }
              }

              abc.sort((a, b) => a.messageDate.compareTo(b.messageDate));
              return ListView.builder(
                physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                controller: _controller,
                itemCount: abc.length,
                itemBuilder: (_, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: abc[index].senderId != userId
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: abc[index].senderId != userId
                            ? const EdgeInsets.only(
                                top: 8, bottom: 8, left: 8, right: 50)
                            : EdgeInsets.only(
                                top: 8, bottom: 8, left: 50, right: 8),
                        child: Container(
                            decoration: BoxDecoration(
                                color: abc[index].senderId != userId
                                    ? Color.fromRGBO(236, 229, 221, 1.0)
                                    : Color.fromRGBO(220, 248, 198, 1.0),
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: abc[index].senderId != userId
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                abc[index].messageText.contains(
                                            "https://firebasestorage.googleapis.com/v0/b/chatbox-ce822.appspot.com/o/") ==
                                        false
                                    ? Text(
                                        abc[index].messageText,
                                        style: TextStyle(fontSize: 15),
                                      )
                                    : abc[index].messageText.contains(
                                            "https://firebasestorage.googleapis.com/v0/b/chatbox-ce822.appspot.com/o/Post%20Picture")
                                        ? Image.network(
                                            abc[index].messageText,
                                            height: 200,
                                            width: 200,
                                          )
                                        : Container(
                                            height: 250,
                                            width: 250,
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Hero(
                                                        tag: abc[index]
                                                            .messageText,
                                                        child: AlertDialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  20),
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              Colors.white,
                                                          content: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 350,
                                                            child:
                                                                Image.network(
                                                              abc[index]
                                                                  .messageText,
                                                              loadingBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent
                                                                          loadingProgress) {
                                                                if (loadingProgress ==
                                                                    null)
                                                                  return child;
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    value: loadingProgress.expectedTotalBytes !=
                                                                            null
                                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                                            loadingProgress.expectedTotalBytes
                                                                        : null,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             ImagePage(
                                                //               imageurl: abc[index]
                                                //                   .messageText,
                                                //             )));
                                              },
                                              child: Material(
                                                child: Hero(
                                                  tag: abc[index].messageText,
                                                  child: Image.network(
                                                    abc[index].messageText,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes
                                                              : null,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            )),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      abc[index].messageDate.substring(0, 11) +
                                          abc[index]
                                              .messageDate
                                              .substring(11, 16),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    abc[index].senderId == userId
                                        ? abc[index].isSeen == "1"
                                            ? Icon(
                                                Icons.remove_red_eye,
                                                color: Colors.blue,
                                                size: 20,
                                              )
                                            : result == true
                                                ? abc[index].isDelivered == "0"
                                                    ? Icon(
                                                        Icons.done,
                                                        color: Colors.grey,
                                                        size: 20,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .add_to_home_screen,
                                                        color: Colors.grey,
                                                        size: 18,
                                                      )
                                                : Icon(
                                                    Icons.access_time,
                                                    color: Colors.grey,
                                                    size: 18,
                                                  )
                                        : Offstage()
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          //bottomSheet: isShowSticker ? buildSticker() : Offstage(),
          bottomNavigationBar: Container(
            child: Column(
              children: <Widget>[
                isShowSticker ? buildSticker() : Offstage(),
                Row(
                  children: <Widget>[
                    // Button send image

                    Material(
                      child: new Container(
                        margin: new EdgeInsets.symmetric(horizontal: 1.0),
                        child: new IconButton(
                          icon: new Icon(Icons.image),
                          onPressed: () {
                            setState(() {
                              emoji = 50;
                              isShowSticker = false;
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Column(
                                      children: <Widget>[
                                        ListTile(
                                          title: Text(
                                            'Camera',
                                            style: TextStyle(
                                                fontFamily: 'Poppins'),
                                          ),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            var tempImage =
                                                await ImagePicker.pickImage(
                                                    source: ImageSource.camera);

                                            sampleImage = tempImage;
                                            if (sampleImage != null) {
                                              StorageReference
                                                  storageReference =
                                                  FirebaseStorage.instance
                                                      .ref()
                                                      .child("Chatbox")
                                                      .child(
                                                          "$userId${widget.name.userId}${DateTime.now()}");
                                              StorageUploadTask uploadTask =
                                                  storageReference
                                                      .putFile(sampleImage);
                                              await uploadTask.onComplete
                                                  .then((s) {
                                                s.ref
                                                    .getDownloadURL()
                                                    .then((s) {
                                                  // _uploadedFileURL =
                                                  //     s.toString();

                                                  Message data = Message(
                                                      isDeleted: "0",
                                                      isDelivered: "0",
                                                      isSeen: "0",
                                                      messageDate:
                                                          DateTime.now()
                                                              .toString(),
                                                      messageText: s.toString(),
                                                      receiverId:
                                                          widget.name.userId,
                                                      senderId: userId);

                                                  messageReference
                                                      .push()
                                                      .set(data.toJson());
                                                });
                                              });
                                            }
                                          },
                                        ),
                                        ListTile(
                                          title: Text(
                                            'Gallery',
                                            style: TextStyle(
                                                fontFamily: 'Poppins'),
                                          ),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            var tempImage =
                                                await ImagePicker.pickImage(
                                                    source: ImageSource.gallery,
                                                    imageQuality: 50);

                                            sampleImage = tempImage;
                                            StorageReference storageReference =
                                                FirebaseStorage.instance
                                                    .ref()
                                                    .child("Chatbox")
                                                    .child(
                                                        "$userId${widget.name.userId}${DateTime.now()}");
                                            if (sampleImage != null) {
                                              // Navigator.push(context,MaterialPageRoute(builder: (context)=>PhotoFather(abc: tempImage,)));
                                              StorageUploadTask uploadTask =
                                                  storageReference
                                                      .putFile(sampleImage);
                                              await uploadTask.onComplete
                                                  .then((s) {
                                                s.ref
                                                    .getDownloadURL()
                                                    .then((s) {
                                                  // _uploadedFileURL =
                                                  //     s.toString();

                                                  Message data = Message(
                                                      isDeleted: "0",
                                                      isDelivered: "0",
                                                      isSeen: "0",
                                                      messageDate:
                                                          DateTime.now()
                                                              .toString(),
                                                      messageText: s.toString(),
                                                      receiverId:
                                                          widget.name.userId,
                                                      senderId: userId);

                                                  messageReference.push().set(
                                                        data.toJson(),
                                                      );
                                                });
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          color: primaryColor,
                        ),
                      ),
                      color: Colors.white,
                    ),
                    Material(
                      child: new Container(
                        margin: new EdgeInsets.symmetric(horizontal: 1.0),
                        child: new IconButton(
                          icon: new Icon(Icons.face),
                          onPressed: getSticker,
                          color: Color(0xff203152),
                        ),
                      ),
                      color: Colors.white,
                    ),

                    // Edit text
                    Flexible(
                      child: Container(
                        child: TextField(
                          style: TextStyle(
                              color: Color(0xff203152), fontSize: 15.0),
                          controller: msg,
                          focusNode: focusNode,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Type your message...',
                            hintStyle: TextStyle(color: Color(0xffaeaeae)),
                          ),
                        ),
                      ),
                    ),

                    // Button send message
                    Material(
                      child: new Container(
                        margin: new EdgeInsets.symmetric(horizontal: 8.0),
                        child: new IconButton(
                          icon: new Icon(Icons.send),
                          onPressed: () {
                            if (msg.text.isNotEmpty) {
                              Message data = Message(
                                  isDeleted: "0",
                                  isDelivered: "0",
                                  isSeen: "0",
                                  messageDate: DateTime.now().toString(),
                                  messageText: msg.text,
                                  receiverId: widget.name.userId,
                                  senderId: userId);
                              messageReference.push().set(data.toJson());
                              setState(() {
                                msg = TextEditingController();
                              });
                            }
                          },
                          color: Color(0xff203152),
                        ),
                      ),
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
            width: double.infinity,
            height: emoji,
            decoration: new BoxDecoration(
                border: new Border(
                    top: new BorderSide(color: Color(0xffE8E8E8), width: 0.5)),
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
