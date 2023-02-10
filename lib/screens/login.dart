// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:trending_movies/config/config.dart';
import 'package:trending_movies/models/google_auth.dart';
import 'package:trending_movies/reuseable/components.dart';
import 'package:trending_movies/screens/allmovies.dart';

import 'package:loading_animations/loading_animations.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import 'package:trending_movies/screens/home_page.dart';
import 'package:trending_movies/screens/signinpage.dart';
import '../../Providers/authUserProvider.dart';
import 'package:the_validator/the_validator.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var email = "";
  var pass = "";
  var errorMessage = "";
  var isBusy = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  //static final FacebookLogin facebookSignIn = new FacebookLogin();

  _loginNow() async {
    var validEmail = Validator.isEmail(email);
    var validPassword = Validator.isPassword(pass, minLength: 6);
    if (validEmail && !validPassword) {
      setState(() {
        errorMessage = 'Password must be 6 characters or more';
      });
    } else if (validPassword && !validEmail) {
      setState(() {
        errorMessage = 'Please input a valid email address';
      });
    } else if (!validEmail && !validPassword) {
      setState(() {
        errorMessage = "Please input valid email and password";
      });
    } else if (email.isEmpty && !validPassword) {
      setState(() {
        errorMessage = "Please input valid email and password";
      });
    } else if (!validEmail && email.isEmpty) {
      setState(() {
        errorMessage = "Please input valid email and password";
      });
    } else if (email.isEmpty && pass.isEmpty) {
      setState(() {
        errorMessage = "Please input valid email and password";
      });
    }
    setState(() {
      isBusy = true;
    });

    await _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((resp) async {
      setState(() {
        isBusy = false;
      });
      if (resp.user != null) {
        Provider.of<UserAuthProvider>(context, listen: false).setAuthUser =
            resp.user;

        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.routeName, (route) => false);
      } else {
        setState(() {
          errorMessage = 'user doesn\'t exist!';
        });
      }
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
      print(e.message);
    });
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
                                    "Try to login\nPlease hold a sec",
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
                            "Login Now",
                            style: NORMAL_HEADER,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Please Login to continue using our app",
                            style: SMALL_DISABLED_TEXT,
                          ),
                          SizedBox(
                            height: widgetHeight,
                          ),
                          CustomRoundedButton(
                            onTap: () async {
                              GoogleSignIn();
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
                                  Toast.show('Error Signing in!', context,
                                      duration: Toast.LENGTH_LONG);
                                }
                              }).catchError((err) {
                                Toast.show('Error Signing in!', context,
                                    duration: Toast.LENGTH_LONG);
                              }); */
                            },
                            radius: 20.0,
                            height: widgetHeight,
                            image: GOOGLE_IMG,
                            color: ASH_BUTTON_COLOR,
                            text: "Sign in with Google",
                          ),
                          SizedBox(
                            height: 30,
                          ),

                          Align(
                              alignment: Alignment.center,
                              child: Text("Login with email and password",
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
                          Padding(
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
                          ),
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
                            text: "Login to my account",
                            onPressed: () async {
                              await _loginNow();
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
                                "Don't have an account?",
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
                                        builder: (_) => RegisterScreen(),
                                      )),
                                  child: Text(
                                    "Register",
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
}

class RoundedButtonWithColor extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double width;
  final double height;
  final Function onPressed;
  const RoundedButtonWithColor({
    this.text,
    this.textColor,
    this.backgroundColor,
    this.width,
    this.height,
    this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: width,
        height: height,
        // ignore: deprecated_member_use
        child: FlatButton(
          color: backgroundColor != null
              ? backgroundColor
              : Color.fromRGBO(8, 87, 171, 1),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                color: textColor != null ? textColor : Colors.white,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
