import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SpalshPage extends StatefulWidget {
  SpalshPage({Key key}) : super(key: key);

  _SpalshPageState createState() => _SpalshPageState();
}

class _SpalshPageState extends State<SpalshPage> {


  @override
  void initState() {
    
    super.initState();
       Timer(
        Duration(seconds: 3),
            () =>  getUserId());
  }

  getUserId() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId =  preferences.getString("user_id");
    print(userId);
    if(userId!=null)
    {
      Navigator.pushReplacementNamed(context, '/home');
    }
    else{
      Navigator.pushReplacementNamed(context, '/register');
    }
   
            // preferences.getString("user_name",name.text);
            // preferences.getString( "user_token",deviceToken,);
            // preferences.getString("user_mobile",mobile.text);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue,Colors.green]
              )
            ),
         child: Center(child: Text("ChAt BoX",style: TextStyle(fontSize: 30,color: Colors.white),)),
      ),
    );
  }
}