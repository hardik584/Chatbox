import 'package:chatbox/models/user.dart';
import 'package:chatbox/screens/signuppage.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:chatbox/util/clips.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatLoginPage extends StatefulWidget {
  ChatLoginPage({Key key}) : super(key: key);

  _ChatLoginPageState createState() => _ChatLoginPageState();
}

class _ChatLoginPageState extends State<ChatLoginPage> {
  final userReference =
      FirebaseDatabase.instance.reference().child('user_master');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  TextEditingController mobile = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  FocusNode femail = FocusNode();
  FocusNode fpassword = FocusNode();
  bool buttonAction = false;
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

  var spintool = SpinKitCircle(
    color: Colors.white,
    size: 30,
  );
  static var buttonSign = Text(
    'Login',
    style: TextStyle(color: Colors.white),
  );
  Widget buttonText = buttonSign;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: "+91" + mobile.text, // PHONE NUMBER TO SEND OTP
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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final AuthResult user = await _auth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.user.uid == currentUser.uid);

      userReference
          .orderByChild("user_id")
          .equalTo(user.user.uid)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Map<dynamic, dynamic> user = snapshot.value;
          for (dynamic k in user.keys) {
            User temp = User.fromJson(user[k], key: k);
            preferences.setString("user_id", temp.userId);
            preferences.setString("user_contact", temp.userContact);
            preferences.setString("user_token", temp.userToken);
            preferences.setString("user_name", temp.userName);
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
        else{
          setState(() {
            buttonAction = false;
            buttonText = buttonSign; 
          });
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: "This contact not found");
          
        }
        print(snapshot.value);
      });

      // Navigator.of(context).pop();
      // Navigator.pushReplacementNamed(context, '/home' );

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

  // Future<void> signInWithEmail() async {
  //   final formstat = _formKey.currentState;
  //   var user;
  //   if (formstat.validate()) {
  //     formstat.save();

  //     try {
  //       user = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //           email: userEmail.text.toLowerCase(), password: userPassword.text);
  //       //   user.sendEmailVerification();
  //       // print("#######");
  //       // print(  user.isEmailVerified);
  //     } on PlatformException catch (error) {
  //       List<String> errors = error.toString().split(',');
  //       _scaffoldKey.currentState.showSnackBar(SnackBar(
  //         content: Text(errors[1]),
  //       ));
  //       //  Fluttertoast.showToast(
  //       //       msg: errors[1]);
  //       setState(() {
  //         buttonAction = false;
  //         buttonText = buttonSign;
  //       });
  //     } catch (e) {
  //       Fluttertoast.showToast(
  //           msg: "Incorrect Credentials", gravity: ToastGravity.BOTTOM);
  //     } finally {
  //       if (user != null) {
  //         SharedPreferences preferences = await SharedPreferences.getInstance();
  //         print(user.user.uid);
  //         userReference
  //             .orderByChild("user_id")
  //             .equalTo(user.user.uid)
  //             .once()
  //             .then((DataSnapshot snapShot) {
  //           print(snapShot.value);

  //           User abc;
  //           Map<dynamic, dynamic> user = snapShot.value;
  //           for (dynamic key in user.keys) {
  //             abc = User.fromJson(user[key], key);
  //           }

  //           preferences.setString("userId", abc.userId);

  //           preferences.setString("userContact", abc.userContact);
  //           preferences.setString("userName", abc.userName);

  //           preferences.setString("userToken", abc.userToken);
  //           preferences.setString("userKey", abc.userKey);

  //           preferences.setString("userProfileUrl", abc.userProfileUrl);

  //           Navigator.pushReplacementNamed(context, '/newsFeed');
  //           Fluttertoast.showToast(msg: "Successfully logged in");
  //         });
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                overflow: Overflow.clip,
                children: <Widget>[
                  ClipPath(
                    clipper: CustomShapeClipper(),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.6,
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
                      height: MediaQuery.of(context).size.height / 2.6 - 10,
                      width: double.infinity,
                      color: Colors.blue,
                      child: Center(child: Offstage()),
                    ),
                  ),
                  Positioned(
                    left: -90,
                    top: -90,
                    child: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 1.7,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color:   Colors.blue.shade300,
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
                    right: -120,
                    top: -100,
                    child: Container(
                        height: MediaQuery.of(context).size.height / 2.5,
                        width: MediaQuery.of(context).size.width / 1.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                           color:  Colors.blue.shade300,
                            shape: BoxShape.circle),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.blue, shape: BoxShape.circle),
                          child: Offstage(),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Center(
                        child: Image.asset(
                      'assets/images/loginimage.png',
                      width: MediaQuery.of(context).size.width / 1,
                      height: MediaQuery.of(context).size.height / 5,
                      colorBlendMode: BlendMode.colorBurn,
                    )),
                  )
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
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

                    // Padding(
                    //   padding: const EdgeInsets.only(top: 15.0),
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width / 1.2,
                    //     child: TextFormField(
                    //       validator: (String value) {
                    //         if (value.isEmpty) {
                    //           return "Please enter password";
                    //         } else if (value.length < 6) {
                    //           return "Password must have 6 character";
                    //         } else {
                    //           return null;
                    //         }
                    //       },
                    //       controller: userPassword,
                    //       obscureText: true,
                    //       textInputAction: TextInputAction.done,
                    //       focusNode: fpassword,
                    //       decoration: InputDecoration(
                    //           labelText: 'Password',
                    //           hintText: 'Enter your password',
                    //           contentPadding:
                    //               EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                    //           hintStyle: TextStyle(color: Colors.grey),
                    //           prefixIcon: Icon(
                    //             Icons.security,
                    //             color: Colors.grey,
                    //           ),
                    //           border: OutlineInputBorder(
                    //               borderRadius: BorderRadius.circular(25.0))),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 50,
                    bottom: 10,
                    left: MediaQuery.of(context).size.width / 10.0,
                    right: MediaQuery.of(context).size.width / 10.0),
                child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 12,
                  child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate() == true) {
                          _checkinternet().then((onValue) {
                            if (onValue == true) {
                              setState(() {
                                buttonAction = true;
                                buttonText = spintool;
                              });
                              verifyPhone();
                              // signInWithEmail();
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
              Padding(
                padding: EdgeInsets.only(
                  top: 5,
                ),
                child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 12,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatSignUpPage()));
                      },
                      child: Text(
                        'SignUp',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
