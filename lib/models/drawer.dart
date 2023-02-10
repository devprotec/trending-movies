// @dart=2.9
//import 'package:gamie/payments/main_payments.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:share/share.dart';

import 'package:trending_movies/ads/ravepay.dart';
import 'package:trending_movies/screens/downloadables.dart';
import 'package:trending_movies/screens/favourates.dart';
import 'package:trending_movies/screens/home_page.dart';
import 'package:trending_movies/screens/login.dart';
//import 'package:gamie/screens/user/course_registration.dart';
//import 'package:gamie/screens/user/user_courses.dart';
import '../config/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
//import 'package:gamie/screens/user/profilePageScreen.dart';
//import 'package:gamie/screens/Knowledge/pascoPage.dart';
//import 'package:gamie/screens/user/settingScreen.dart';
//import 'package:gamie/screens/user/inviteScreen.dart';
import 'package:provider/provider.dart';
//import '../screens/auth/gettingStartedScreen.dart';
import '../Providers/authUserProvider.dart';

class CustomDrawer extends StatelessWidget {
  //final  List<DropdownMenuItem<dynamic>> items = ;

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<UserAuthProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    return SafeArea(
        child: Theme(
            data: ThemeData(primaryColor: APP_BAR_COLOR),
            child: Drawer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                      currentAccountPicture: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            USER_PROFILE_PIC,
                            fit: BoxFit.cover,
                          )),
                      accountName: Text(
                        "",
                        style: MEDIUM_WHITE_BUTTON_TEXT,
                      ),
                      accountEmail: Text(
                        "${user != null ? user.email : ""}",
                        style: SMALL_DISABLED_TEXT,
                      )),
                  /*Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    UserCourses()));
                      },
                      leading: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.black,
                      ),
                      title: Text(
                        "Manage Courses",
                        style: NORMAL_BLACK_BUTTON_TEXT,
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),
                     ListTile(
                      onTap: () async {
                        await Navigator.of(context)
                            .popAndPushNamed(ProfilePage.routeName);
                      },
                      leading: Icon(
                        FontAwesome5.edit,
                        color: Colors.black,
                      ),
                      title: Text(
                        "Profile",
                        style: NORMAL_BLACK_BUTTON_TEXT,
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    PascoPage()));
                      },
                      leading: Icon(
                        FontAwesome.book,
                        color: Colors.black,
                      ),
                      title: Text(
                        "Past Questions",
                        style: NORMAL_BLACK_BUTTON_TEXT,
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),*/
                  ListTile(
                    //linked all payments to only one payment screen

                    onTap: () {
                      if (FirebaseAuth.instance.currentUser == null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Downloadables()));
                      }
                      // Navigator.pop(context);
                      // Navigator.of(context).push(CupertinoPageRoute(
                      //   builder: (BuildContext context) => Payments()));
                    },
                    leading: Icon(
                      Icons.attach_money,
                      color: Colors.black,
                    ),
                    title: Text(
                      "My Downlodable Movies",
                      style: NORMAL_BLACK_BUTTON_TEXT,
                    ),
                  ),
                  Divider(
                    height: 0,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      final RenderBox box = context.findRenderObject();
                      Share.share('link',
                          subject: 'message',
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size);
                    },
                    leading: Icon(
                      Icons.share,
                      color: Colors.black,
                    ),
                    title: Text(
                      "Share with Friend",
                      style: NORMAL_BLACK_BUTTON_TEXT,
                    ),
                  ),
                  Divider(
                    height: 0,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      if (FirebaseAuth.instance.currentUser == null) {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      } else {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (context) => Favourates()),
                        );
                      }
                    },
                    leading: Icon(
                      Icons.favorite,
                      color: Colors.black,
                    ),
                    title: Text(
                      "Favourites",
                      style: NORMAL_BLACK_BUTTON_TEXT,
                    ),
                  ),
                  Divider(
                    height: 0,
                  ),
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      FirebaseAuth.instance.currentUser == null
                          ? Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => LoginScreen()))
                          :
                          //removes drawer first then

                          //show dialog
                          _showAlertDialog(context);
                    },
                    leading: Icon(
                      FirebaseAuth.instance.currentUser == null
                          ? AntDesign.login
                          : AntDesign.logout,
                      color: Colors.black,
                    ),
                    title: Text(
                      FirebaseAuth.instance.currentUser == null
                          ? "Log In"
                          : 'Log Out',
                      style: NORMAL_BLACK_BUTTON_TEXT,
                    ),
                  ),
                ],
              ),
            )));
  }
}

void _showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text('Are you sure you want to log out?'),
      title: Text('Log Out'),
      actions: [
        FlatButton(
          child: Text('Yes'),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Provider.of<UserAuthProvider>(context, listen: false).reset();
            //go to getting started
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.routeName, (route) => false);
          },
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}
