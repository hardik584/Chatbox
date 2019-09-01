// import 'package:chatbox/models/message.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// class Pagination extends StatefulWidget {
//   Pagination({Key key}) : super(key: key);

//   _PaginationState createState() => _PaginationState();
// }

// class _PaginationState extends State<Pagination> {
//   final messageReference = FirebaseDatabase.instance.reference();
//   bool _loadingMessage = true;
//   List<Message> msgList = [];
//   int _per_page = 20;
//   Message lastMsg;
//   ScrollController _scrollController = ScrollController();
//   bool _gettingMoreMsg = false;
//   bool _moreMsgAvailable = true;
//   @override
//   void initState() {
//     super.initState();
//     _getMsg();
//     _scrollController.addListener(() {
//       double maxScroll = _scrollController.position.maxScrollExtent;
//       double currentScroll = _scrollController.position.pixels;
//       double delta = MediaQuery.of(context).size.height * 0.25;
//       if (maxScroll - currentScroll <= delta) {
//         _getMoreMsg();
//       }
//     });
//   }

//   _getMsg() async {
//     print("init Called");
//     var a = await messageReference
//         .child('message_master')

//         .limitToLast(_per_page)
//         .once()
//         .then((onValue) {
//       setState(() {
//         _loadingMessage = true;
//       });

//       Map<dynamic, dynamic> map = onValue.value;
//       if (map != null) {
//         for (var key in map.keys) {
//           Message temp = Message.fromJson(map[key], key);

//           msgList.add(temp);
//         }
//         lastMsg = msgList[msgList.length - 1];
//         print(msgList.length);
//       }
//       setState(() {
//         _loadingMessage = false;
//       });
//     });
//   }

//   _getMoreMsg() async {
//     print("_getMoreMsg Called");
//     if (_moreMsgAvailable == false) {
//       print("No More Product");
//       return;
//     }
//     if (_gettingMoreMsg == true) {
//       return;
//     }
//     messageReference
//         .child('message_master')

//         .limitToLast(_per_page)
//         .startAt(lastMsg.messageId, key: "key")
//         .once()
//         .then((onValue) {
//       Map<dynamic, dynamic> map = onValue.value;
//       if (map.length < _per_page) {
//         _moreMsgAvailable = false;
//       }
//       if (map != null) {
//         for (var key in map.keys) {
//           Message temp = Message.fromJson(map[key], key);

//             msgList.add(temp);

//         }
//         lastMsg = msgList[msgList.length - 1];
//         print(msgList.length);
//       }
//       setState(() {
//         _gettingMoreMsg = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _loadingMessage == true
//           ? Container(
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             )
//           : Container(
//               child: msgList.length == 0
//                   ? Center(child: Text("No products to snow"))
//                   : ListView.builder(
//                       controller: _scrollController,
//                       itemCount: msgList.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(msgList[index].messageText),
//                           leading: CircleAvatar(
//                             child: Text(index.toString()),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String nextPage = "https://swapi.co/api/people";

  ScrollController _scrollController = new ScrollController();

  bool isLoading = false;

  List names = new List();

  final dio = new Dio();
  void _getMoreData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final response = await dio.get(nextPage);
      List tempList = new List();
      nextPage = response.data['next'];
      print(nextPage);
      for (int i = 0; i < response.data['results'].length; i++) {
        tempList.add(response.data['results'][i]);
      }

      setState(() {
        isLoading = false;
        names.addAll(tempList);
      });
    }
  }

  @override
  void initState() {
    this._getMoreData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      //+1 for progressbar
      itemCount: names.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == names.length) {
          return _buildProgressIndicator();
        } else {
          return new ListTile(
            title: Text((names[index]['name'])),
            onTap: () {
              print(names[index]);
            },
          );
        }
                          },
      controller: _scrollController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagination"),
      ),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
