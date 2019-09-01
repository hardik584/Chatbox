 
import 'package:chatbox/util/clips.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
 
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
class ChatSignUpPage extends StatefulWidget {
  ChatSignUpPage({Key key}) : super(key: key);

  _ChatSignUpPageState createState() => _ChatSignUpPageState();
}

class _ChatSignUpPageState extends State<ChatSignUpPage> {
  final userReference =
      FirebaseDatabase.instance.reference().child('user_master');
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
  ]);
    _firebaseMessaging.getToken().then((onValue) {
      deviceToken = onValue;
      print(deviceToken);
    });
  }

  Future<bool> _checkinternet() async {
    var result = await Connectivity().checkConnectivity();
    bool a;
    if (result == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: "Please check your network connection.");
      a = false;
    } else if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      a = true;
    }
    return a;
  }

  var _formKey = GlobalKey<FormState>();

  String gender, deviceToken;
  var spintool = SpinKitCircle(
    color: Colors.white,
    size: 30,
  );
  static var buttonSign = Text(
    'SignUp',
    style: TextStyle(color: Colors.white),
  );
  Widget buttonText = buttonSign;
  String uid = '';
  bool buttonBool = false;
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  FocusNode fname = FocusNode();
  FocusNode femail = FocusNode();
  FocusNode fphonenumber = FocusNode();
  FocusNode fpassword = FocusNode();
  FocusNode fconfirmpassword = FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

    String phoneNo;    
    String smsOTP;    
    String verificationId;    
    String errorMessage = '';    
    FirebaseAuth _auth = FirebaseAuth.instance;    
    
    Future<void> verifyPhone() async { 
      _firebaseMessaging.getToken().then((onValue) {
      deviceToken = onValue;
      print(deviceToken);
    });   
        final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {    
            this.verificationId = verId;    
            smsOTPDialog(context).then((value) {    
            print('sign in');    
            });    
        };    
        try {    
            await _auth.verifyPhoneNumber(    
                phoneNumber: "+91"+mobile.text, // PHONE NUMBER TO SEND OTP    
                codeAutoRetrievalTimeout: (String verId) {    
                //Starts the phone number verification process for the given phone number.    
                //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.    
                this.verificationId = verId;    
                },    
                codeSent:    
                    smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.    
                timeout: const Duration(seconds: 20),    
                verificationCompleted: (AuthCredential phoneAuthCredential) {    
                print(phoneAuthCredential);    
                },    
                verificationFailed: (AuthException exceptio) {    
                print('${exceptio.message}');    
                });    
        } catch (e) {    
            handleError(e);    
        }    
    }    
    
    Future<bool> smsOTPDialog(BuildContext context) {    
        return showDialog(    
            context: context,    
            barrierDismissible: false,    
            builder: (BuildContext context) {    
                return new AlertDialog(    
                title: Text('Enter SMS Code'),    
                content: Container(    
                    height: 85,    
                    child: Column(children: [    
                    TextField(    
                        onChanged: (value) {    
                        this.smsOTP = value;    
                        },    
                    ),    
                    (errorMessage != ''    
                        ? Text(    
                            errorMessage,    
                            style: TextStyle(color: Colors.red),    
                            )    
                        : Container())    
                    ]),    
                ),    
                contentPadding: EdgeInsets.all(10),    
                actions: <Widget>[    
                    FlatButton(    
                    child: Text('Done'),    
                    onPressed: () {   
                      signIn();   
                        // _auth.currentUser().then((user) {    
                        // if (user != null) {  
                        //      signIn();    
                        //     Navigator.of(context).pop();    
                         
                        // } else {    
                        //     signIn();    
                        // }    
                        // });    
                    },    
                    )    
                ],    
                );    
        });    
    }    
    
    signIn() async {    
        try {    
            final AuthCredential credential = PhoneAuthProvider.getCredential(    
            verificationId: verificationId,    
            smsCode: smsOTP,    
            );    
            final AuthResult user = await _auth.signInWithCredential(credential) ; 
            final FirebaseUser currentUser = await _auth.currentUser();    
            assert(user.user.uid == currentUser.uid);   
             userReference.push().set({
              "user_id":currentUser.uid,
              "user_name":name.text,
              "user_token":deviceToken,
              "user_contact":mobile.text
            });
            SharedPreferences preferences = await SharedPreferences.getInstance();
            preferences.setString( "user_id",currentUser.uid);
            preferences.setString("user_name",name.text);
            preferences.setString( "user_token",deviceToken,);
            preferences.setString("user_contact",mobile.text);
            
           


            Navigator.of(context).pop();    
            Navigator.pushReplacementNamed(context, '/home' );
           
        } catch (e) {    
            handleError(e);    
        }    
    }    
    
    handleError(PlatformException error) {    
        print(error);    
        switch (error.code) {    
            case 'ERROR_INVALID_VERIFICATION_CODE':    
            FocusScope.of(context).requestFocus(new FocusNode());    
            setState(() {    
                errorMessage = 'Invalid Code';    
            });   
            print(errorMessage); 
            Navigator.of(context).pop();    
            smsOTPDialog(context).then((value) {    
              print('dksnllkanlkmcsskl');
                print('sign in');    
            });    
            break;    
            default:    
            setState(() {    
                errorMessage = error.message;    
            });    
    
            break;    
        }    
    }    

  // void setData() async {
  //   await userReference
  //       .orderByChild("userEmail")
  //       .equalTo(email.text)
  //       .once()
  //       .then((DataSnapshot snapshot) {
  //     if (snapshot.value != null) {
  //       setState(() {
  //         buttonBool = false;
  //         buttonText = buttonSign;
  //       });
  //       Scaffold.of(context).showSnackBar(SnackBar(
  //         content: Text("Email address is already registered"),
  //       ));
  //     } else {
  //       register();
  //     }
  //   });
  // }

  // Future<void> register() async {
  //   var a = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: email.text, password: password.text);

  //   uid = a.uid;
  //   User signUp = User(
  //     userId: a.uid,
  //     userToken: deviceToken,
  //     userEmail: email.text,
  //     userName: name.text,
  //     userContact: mobile.text,
  //     userGender: gender,
  //     userProfileUrl: "",
  //   );

  //   userReference.push().set(signUp.toJson()).then((_) {
  //     Fluttertoast.showToast(msg: "Your account registered successfully");
  //     Navigator.pushReplacementNamed(context, '/');
  //   });
  // }
 
 

   
 
  @override
  dispose(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                overflow: Overflow.clip,
                children: <Widget>[
                  ClipPath(
                    clipper: CustomShapeClipper(),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: double.infinity,
                      color: Colors.blue.shade300,
                      child: Center(
                        child: Offstage(),
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: CustomShapeClipper2(),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3 - 10,
                      width: double.infinity,
                      color: Colors.blue,
                      child: Center(child: Offstage()),
                    ),
                  ),
                  Positioned(
                    left: -90,
                    top: -90,
                    child: Container(
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width / 1.7,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            shape: BoxShape.circle),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.blue, shape: BoxShape.circle),
                          child: Offstage(),
                        )),
                  ),
                  Positioned(
                    right: -170,
                    top: -90,
                    child: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 1.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            shape: BoxShape.circle),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.blue, shape: BoxShape.circle),
                          child: Offstage(),
                        )),
                  ),
                  Center(
                      child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height / 3 - 50,
                          child: Text(
                            'SignUp',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          )))
                ],
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8.0),
                  child: Column(
                    
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: TextFormField(
                            validator: (String value) {
                              if (value.trim().isEmpty) {
                                return 'Please enter username';
                              } else {
                                return null;
                              }
                            },
                            controller: name,
                            textInputAction: TextInputAction.next,
                            focusNode: fname,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(context, fname, fphonenumber);
                            },
                            decoration: InputDecoration(
                                labelText: 'Name',
                                contentPadding:
                                    EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                                hintText: 'Enter your Name',
                                hintStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: TextFormField(
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Please enter phone number";
                              } else if (value.length != 10) {
                                return "Please enter valid Phone number";
                              } else {
                                return null;
                              }
                            },
                            controller: mobile,
                            focusNode: fphonenumber,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                labelText: 'Mobile No.',
                                contentPadding:
                                    EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                                hintText: 'Mobile No.',
                                hintStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0))),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, bottom: 10,left: MediaQuery.of(context).size.width/10.0,right:MediaQuery.of(context).size.width/10.0),
                child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 11,
                  child: IgnorePointer(
                    ignoring: buttonBool,
                    child: RaisedButton(
                      
                        onPressed: () {
                        
                          if (_formKey.currentState.validate() == true) {
                            _checkinternet().then((onValue) {
                              if (onValue == true) {
                                setState(() {
                                  buttonBool = true;
                                  buttonText = spintool;
                                });
                               verifyPhone();
                              }
                            });
                          }
                        },
                        color: Colors.blue,
                        child: buttonText,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0))),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 20),
                child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 12,
                  child: IgnorePointer(
                    ignoring: buttonBool,
                    child: FlatButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0))),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

 

 
 

 
    

// class PhonePage extends StatefulWidget {
//   PhonePage({Key key}) : super(key: key);

//   _PhonePageState createState() => _PhonePageState();
// }

// class _PhonePageState extends State<PhonePage> {
//     String phoneNo;    
//     String smsOTP;    
//     String verificationId;    
//     String errorMessage = '';    
//     FirebaseAuth _auth = FirebaseAuth.instance;    
    
//     Future<void> verifyPhone() async {    
//         final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {    
//             this.verificationId = verId;    
//             smsOTPDialog(context).then((value) {    
//             print('sign in');    
//             });    
//         };    
//         try {    
//             await _auth.verifyPhoneNumber(    
//                 phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP    
//                 codeAutoRetrievalTimeout: (String verId) {    
//                 //Starts the phone number verification process for the given phone number.    
//                 //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.    
//                 this.verificationId = verId;    
//                 },    
//                 codeSent:    
//                     smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.    
//                 timeout: const Duration(seconds: 20),    
//                 verificationCompleted: (AuthCredential phoneAuthCredential) {    
//                 print(phoneAuthCredential);    
//                 },    
//                 verificationFailed: (AuthException exceptio) {    
//                 print('${exceptio.message}');    
//                 });    
//         } catch (e) {    
//             handleError(e);    
//         }    
//     }    
    
//     Future<bool> smsOTPDialog(BuildContext context) {    
//         return showDialog(    
//             context: context,    
//             barrierDismissible: false,    
//             builder: (BuildContext context) {    
//                 return new AlertDialog(    
//                 title: Text('Enter SMS Code'),    
//                 content: Container(    
//                     height: 85,    
//                     child: Column(children: [    
//                     TextField(    
//                         onChanged: (value) {    
//                         this.smsOTP = value;    
//                         },    
//                     ),    
//                     (errorMessage != ''    
//                         ? Text(    
//                             errorMessage,    
//                             style: TextStyle(color: Colors.red),    
//                             )    
//                         : Container())    
//                     ]),    
//                 ),    
//                 contentPadding: EdgeInsets.all(10),    
//                 actions: <Widget>[    
//                     FlatButton(    
//                     child: Text('Done'),    
//                     onPressed: () {   
//                       signIn();   
//                         // _auth.currentUser().then((user) {    
//                         // if (user != null) {  
//                         //      signIn();    
//                         //     Navigator.of(context).pop();    
                         
//                         // } else {    
//                         //     signIn();    
//                         // }    
//                         // });    
//                     },    
//                     )    
//                 ],    
//                 );    
//         });    
//     }    
    
//     signIn() async {    
//         try {    
//             final AuthCredential credential = PhoneAuthProvider.getCredential(    
//             verificationId: verificationId,    
//             smsCode: smsOTP,    
//             );    
//             final FirebaseUser user = await _auth.signInWithCredential(credential);    
//             final FirebaseUser currentUser = await _auth.currentUser();    
//             assert(user.uid == currentUser.uid);    
//             Navigator.of(context).pop();    
           
//         } catch (e) {    
//             handleError(e);    
//         }    
//     }    
    
//     handleError(PlatformException error) {    
//         print(error);    
//         switch (error.code) {    
//             case 'ERROR_INVALID_VERIFICATION_CODE':    
//             FocusScope.of(context).requestFocus(new FocusNode());    
//             setState(() {    
//                 errorMessage = 'Invalid Code';    
//             });   
//             print(errorMessage); 
//             Navigator.of(context).pop();    
//             smsOTPDialog(context).then((value) {    
//               print('dksnllkanlkmcsskl');
//                 print('sign in');    
//             });    
//             break;    
//             default:    
//             setState(() {    
//                 errorMessage = error.message;    
//             });    
    
//             break;    
//         }    
//     }    
    
//     @override    
//     Widget build(BuildContext context) {    
//         return Scaffold(    
//             appBar: AppBar(    
//             title: Text('widget.title'),    
//             ),    
//             body: Center(    
//             child: Column(    
//                 mainAxisAlignment: MainAxisAlignment.center,    
//                 children: <Widget>[    
//                 Padding(    
//                     padding: EdgeInsets.all(10),    
//                     child: TextField(    
//                     decoration: InputDecoration(    
//                         hintText: 'Enter Phone Number Eg. +910000000000'),    
//                     onChanged: (value) {    
//                         this.phoneNo = value;    
//                     },    
//                     ),    
//                 ),    
//                 (errorMessage != ''    
//                     ? Text(    
//                         errorMessage,    
//                         style: TextStyle(color: Colors.red),    
//                         )    
//                     : Container()),    
//                 SizedBox(    
//                     height: 10,    
//                 ),    
//                 RaisedButton(    
//                     onPressed: () {    
//                     verifyPhone();    
//                     },    
//                     child: Text('Verify'),    
//                     textColor: Colors.white,    
//                     elevation: 7,    
//                     color: Colors.blue,    
//                 )    
//                 ],    
//             ),    
//             ),    
//         );    
//     }    
// }    