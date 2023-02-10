// @dart=2.9
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';

import 'package:trending_movies/config/config.dart';
import 'package:trending_movies/models/google_auth.dart';
import 'package:trending_movies/reuseable/components.dart';

import 'package:loading_animations/loading_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:trending_movies/screens/home_page.dart';
import 'package:trending_movies/screens/login.dart';
import '../../Providers/authUserProvider.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:loading_animations/loading_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../Providers/authUserProvider.dart';
import 'allmovies.dart';

//fixed the continue problem by importing the right file

//fixed the continue problem by importing the right file
//import 'registerSteps/emailStep.dart';
//import 'registerSteps/passwordStep.dart';
//import 'registerSteps/termsStep.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = "sign_up";
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FirebaseUser _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isSignIn = false;
  bool google = false;
  String errorMessage = "";
  //FirebaseAuth _auth1 = FirebaseAuth.instance;
  List states = List.generate(4, (index) => StepState.indexed);
  BuildContext openContext;
  int _currentStep = 0;
  bool isBusy = false;
  final _emailFormkey = GlobalKey<FormState>();
  final _personalInfoFormkey = GlobalKey<FormState>();
  final _passwordFormkey = GlobalKey<FormState>();
  List keys;
  String pass;
  String email;

  void initializeKeys() {
    keys = [_personalInfoFormkey, _emailFormkey, _passwordFormkey];
  }

  SnackBar _buildSnackBar() {
    return SnackBar(
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: <Widget>[
            Icon(
              Icons.warning,
              color: Colors.red,
            ),
            SizedBox(
              width: 10,
            ),
            Text(errorMessage),
          ],
        ));
  }

  Future _signUp() async {
    //FocusScope.of(openContext).unfocus();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //Map<String, dynamic> data = await jsonDecode(
    //  prefs.get(PREFS_PERSONAL_INFO),
    // );

    // WANTED TO DO ONE MORE VERIFICATION LIKE: data.keys.length
    setState(() {
      isBusy = true;
    });
    await _auth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((user) {
      return Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) => HomePage()),
          (predicate) => false);
    }).catchError((e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Error"),
            content: new Text(e.message == 'Given String is empty or null' ||
                    e.message == null
                ? 'email or password cannot be empty'
                : e.message),
            actions: <Widget>[
              // ignore: deprecated_member_use
              new FlatButton(
                child: new Text("Dismiss"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      print(e.toString());
      setState(() {
        isBusy = false;
      });

      /* return Scaffold.of(openContext).showSnackBar(SnackBar(
        action: SnackBarAction(
          textColor: APP_BAR_COLOR,
          label: "Reset password",
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context)
                .push(CupertinoPageRoute(builder: (context) => LoginScreen()));
          },
        ),
        duration: Duration(seconds: 15),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: <Widget>[
            Icon(
              Icons.warning,
              color: Colors.red,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(child: Text(errorMessage)),
          ],
        ),
      ));
    });
    return; */
    });
  }

  @override
  void initState() {
    super.initState();
    initializeKeys();
    isBusy = false;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final double widgetWidth = deviceSize.width * 0.9;
    //changed widgetHeight value
    final double widgetHeight =
        0.07 * deviceSize.height; // Change width of evrytng from here

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: deviceSize.height,
          child: Stack(
            children: <Widget>[
              // Positioned.fill(child: CustomBackground()),
              Positioned.fill(
                child: Container(
                  // color: MAIN_BACK_COLOR,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Visibility(
                            maintainSize: false,
                            maintainAnimation: false,
                            maintainState: false,
                            visible: isBusy,
                            child: SizedBox(
                              height: deviceSize.height,
                              width: deviceSize.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LoadingBouncingGrid.square(
                                    size: deviceSize.width / 4,
                                    borderSize: deviceSize.width / 8,
                                  ),
                                  Text(
                                    "Trying to sign you up\nPlease hold a sec",
                                    style: NORMAL_HEADER,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Sign Up Now",
                            style: NORMAL_HEADER,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Please sign up to continue using our app",
                            style: SMALL_DISABLED_TEXT,
                          ),
                          SizedBox(
                            height: widgetHeight,
                          ),
                          CustomRoundedButton(
                            onTap: () async {
                              FirebaseService service = new FirebaseService();
                              try {
                                await service.signInwithGoogle1();
                                Navigator.pushNamedAndRemoveUntil(context,
                                    HomePage.routeName, (route) => false);
                              } catch (e) {
                                if (e is FirebaseAuthException) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return AlertDialog(
                                        title: new Text("Error"),
                                        content: new Text(e.message),
                                        actions: <Widget>[
                                          // ignore: deprecated_member_use
                                          new FlatButton(
                                            child: new Text("Dismiss"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                              /* signInWithGoogle().then((value) {
                                if (value.user != null) {
                                  Provider.of<UserAuthProvider>(
                                    context,
                                  ).setAuthUser = value.user;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AllMovies()));
                                } else {
                                  Toast.show('Error Signing up!', context,
                                      duration: Toast.LENGTH_LONG);
                                }
                              }).catchError((err) {
                                Toast.show('Error Signing up!', context,
                                    duration: Toast.LENGTH_LONG);
                              }); */
                            },
                            radius: 20.0,
                            height: widgetHeight,
                            image: GOOGLE_IMG,
                            color: ASH_BUTTON_COLOR,
                            text: "Sign up with Google",
                          ),
                          SizedBox(
                            height: 30,
                          ),

                          Align(
                              alignment: Alignment.center,
                              child: Text("Sign up with email and password",
                                  style: SMALL_DISABLED_TEXT)),
                          SizedBox(
                            height: 30,
                          ),

                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: widgetHeight,
                              width: widgetWidth,
                              child: TextFormField(
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  onChanged: (val) {
                                    setState(() {
                                      errorMessage =
                                          ""; // clear any previous errors
                                      email = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Enter your email address",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),

                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: widgetHeight,
                              width: widgetWidth,
                              child: TextFormField(
                                obscureText: true,
                                obscuringCharacter: "*",
                                textAlign: TextAlign.center,
                                onChanged: (val) {
                                  setState(() {
                                    errorMessage = "";
                                    pass = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: "Enter you password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          /* Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                InkWell(
                                  //linked forgot password link to email entry page
                                  onTap: () {},
                                  child: Text("Forgot Password?",
                                      style: SMALL_BLUE_TEXT_STYLE),
                                ),
                              ],
                            ),
                          ), */
                          Visibility(
                            visible: !isBusy,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    errorMessage,
                                    style: ERROR_MSG_TEXTSTYLE,
                                  )),
                            ),
                          ), //ERROR MESSAGE
                          RoundedButtonWithColor(
                            text: "Sign up",
                            onPressed: () async {
                              await _signUp();
                            },
                            width: widgetWidth,
                            height: widgetHeight,
                            backgroundColor: APP_BAR_COLOR,
                          ),
                          SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Already have an account?",
                                style: SMALL_DISABLED_TEXT,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                        builder: (context) => RegisterScreen()),
                                  );
                                },
                                child: InkWell(
                                  onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => LoginScreen(),
                                      )),
                                  child: Text(
                                    "Sign in",
                                    style: SMALL_BLUE_TEXT_STYLE,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: missing_return
  Future<User> signInWithGoogle() async {
    // model.state =ViewState.Busy;
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    UserCredential authResult = await _auth.signInWithCredential(credential);
    _user = authResult.user;
    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);
    User currentUser = _auth.currentUser;
    assert(_user.uid == currentUser.uid);
    // model.state =ViewState.Idle;
    print("User Name: ${_user.displayName}");
    print("User Email ${_user.email}");
  }
}

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String> signInwithGoogle1() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
