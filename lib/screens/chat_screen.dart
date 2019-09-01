 
import 'package:chatbox/screens/imagefilter.dart';
 
import 'package:flutter/material.dart';
import '../models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: dummyData.length,
      itemBuilder: (context, i) => new Column(
            children: <Widget>[
              new Divider(
                height: 10.0,
              ),
              new ListTile(
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ForLearn())),
                leading: new CircleAvatar(
                  foregroundColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey,
                  backgroundImage: new NetworkImage(dummyData[i].avatarUrl),
                ),
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      dummyData[i].name,
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Text(
                      dummyData[i].time,
                      style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                  ],
                ),
                subtitle: new Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    dummyData[i].message,
                    style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                  ),
                ),
              )
            ],
          ),
    );
  }
}

class ForLearn extends StatefulWidget {
  ForLearn({Key key}) : super(key: key);

  _ForLearnState createState() => _ForLearnState();
}

class _ForLearnState extends State<ForLearn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
          body:  Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              
              children: <Widget>[
                Container(
  margin: EdgeInsets.only(top: 50.0),
  padding: EdgeInsets.all(10.0),
  child: Image(
    image: AssetImage('assets/images/mimi9.gif'),
    height: 120.0,
    width: 120.0,
    fit: BoxFit.contain,
  ),
),Container(
  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10),
  child: Text(
    "NONSTOP IO TECHNOLOGIES",
    style: TextStyle(
      fontFamily: 'Rubik-Bold',
      fontSize: 26.0,
      color: Color(0xFF008482),
      shadows: [
        Shadow(
              // bottomLeft
              offset: Offset(-1.5, -1.5),
              color: Colors.black),
        Shadow(
              // bottomRight
              offset: Offset(1.5, -1.5),
              color: Colors.black),
        Shadow(
              // topRight
              offset: Offset(1.5, 1.5),
              color: Colors.black),
        Shadow(
              // topLeft
              offset: Offset(-1.5, 1.5),
              color: Colors.black),
      ],
      letterSpacing: 5.0,
      inherit: false,
    ),
    textAlign: TextAlign.center,
  ),
),

Container(
  decoration: BoxDecoration(
      border: Border.all(
        color: Color(0xFF18a096),
      ),
      borderRadius: BorderRadius.all(Radius.circular(10.0))),
  padding: EdgeInsets.all(15.0),
  child: TextFormField(
    decoration: InputDecoration(
      icon: Icon(
        Icons.email,
        size:20,
      ),
      hintText: "Email",
      hintStyle: TextStyle(
        fontFamily: 'Rubik-Regular',
        fontSize: 16.0,
        color: Colors.grey,
        inherit: false,
      ),
      errorStyle: TextStyle(
        fontFamily: 'Rubik-Light',
        fontSize: 12.0,
        color: Colors.red,
        inherit: false,
      ),
      errorMaxLines: 1,
      contentPadding: EdgeInsets.zero,
      border: InputBorder.none,
    ),
    style: TextStyle(
      fontFamily: 'Rubik-Regular',
      fontSize: 16.0,
      color: Colors.black,
      inherit: false,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 3.0,
    ),
  ),
),
InkWell(
  borderRadius: BorderRadius.all(
    Radius.circular(10.0),
  ),
  onTap: () {},
  child: Container(
    padding: EdgeInsets.all(15.0),
    child: Center(
      child: Text(
        "Login",
        style: TextStyle(
            fontFamily: "Rubik-Medium",
            fontSize: 15.0,
            color: Colors.white,
            inherit: false,
        ),
      ),
    ),
    decoration: BoxDecoration(
      color: Color(0xFF18a096),
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
    ),
  ),
)
              ],
            ),
          )
         
    );
  }
}