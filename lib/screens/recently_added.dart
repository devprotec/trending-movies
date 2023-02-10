// @dart=2.9

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trending_movies/ads/another_download.dart';
import 'package:trending_movies/ads/paypalPayment.dart';
import 'package:trending_movies/config/config.dart';
import 'package:trending_movies/reuseable/network_error_widget.dart';
import 'package:trending_movies/screens/descriptionPage.dart';
import 'package:trending_movies/services/cloud_firestore_services.dart';
import 'package:trending_movies/screens/videopage.dart';
import '../Providers/network_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/video_info.dart';
import '../reuseable/empty_items.dart';
import '../reuseable/no_connectivity_widget.dart';
import 'allmovies.dart';
import 'login.dart';

class RecentlyAdded extends StatelessWidget {
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);

    return SafeArea(
      child: Scaffold(
          body: networkProvider.connectionStatus
              ? recentlyAddedStream()
              : Center(child: NoConnectivityWidget())),
    );
  }
}

Widget recentlyAddedStream() {
  User user = FirebaseAuth.instance.currentUser;
  int milliseconds = Timestamp.now().millisecondsSinceEpoch - 5100000000;
  return StreamBuilder(
      stream: CloudFirestoreServices.getRecentlyAdded(milliseconds),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: NetworkErrorWidget(),
            ),
          );
        }
        if (snapshot.hasData) {
          List<DocumentSnapshot> data = snapshot.data.docs;
          print(data.length);

          if (data.length == 0)
            return Center(
              child: EmptyWidget(
                msg: 'There are no movies available. Please check back later',
              ),
            );
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return VideoCardRecent(
                    VideoInfo.fromMap(data[index], index), user);
              });
        } else
          return Text('has not data');
      });
}

class VideoCardRecent extends StatefulWidget {
  final VideoInfo videoInfo;
  final User user;
  VideoCardRecent(this.videoInfo, this.user);

  @override
  _VideoCardRecentState createState() => _VideoCardRecentState();
}

class _VideoCardRecentState extends State<VideoCardRecent> {
  Color iconColor;
  bool isFav;

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      widget.videoInfo.fav.contains(FirebaseAuth.instance.currentUser.uid)
          ? isFav = true
          : isFav = false;
      isFav ? iconColor = Colors.red : iconColor = Colors.black;
    }
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    isFav ? iconColor = Colors.red : iconColor = Colors.black;

    super.setState(fn);
  }

  final SnackBar favRemovedSnackBar = SnackBar(
    content: Text('Movie removed from favourate list'),
    duration: Duration(seconds: 3),
  );

  final SnackBar notFavSnackBar = SnackBar(
      content: Text('Movie added to favourate list'),
      duration: Duration(seconds: 3));
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.blueGrey, blurRadius: 1, spreadRadius: .1),
            ]),
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
        padding: EdgeInsets.all(10),
        child: Column(children: [
          InkWell(
            child: Image.network(widget.videoInfo.imageLink),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DescriptionPage(
                        widget.videoInfo,
                      )));
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.videoInfo.name + '(${widget.videoInfo.year})',
                  style: MEDIUM_WHITE_BUTTON_TEXT_BOLD,
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (FirebaseAuth.instance.currentUser == null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    } else {
                      if (widget.videoInfo.fav
                          .contains(FirebaseAuth.instance.currentUser.uid)) {
                        List newfavList = widget.videoInfo.fav;
                        newfavList
                            .remove(FirebaseAuth.instance.currentUser.uid);
                        FirebaseFirestore.instance
                            .collection('movies')
                            .doc(widget.videoInfo.id)
                            .update({'fav': newfavList});
                        ScaffoldMessenger.of(context)
                            .showSnackBar(favRemovedSnackBar);
                        isFav = false;
                      } else {
                        List newfavList = widget.videoInfo.fav;
                        newfavList.add(FirebaseAuth.instance.currentUser.uid);
                        FirebaseFirestore.instance
                            .collection('movies')
                            .doc(widget.videoInfo.id)
                            .update({'fav': newfavList});
                        ScaffoldMessenger.of(context)
                            .showSnackBar(notFavSnackBar);
                        isFav = true;
                      }
                    }
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: iconColor,
                  )),
              IconButton(
                  onPressed: () async {
                    if (FirebaseAuth.instance.currentUser == null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    } else {
                      widget.videoInfo.pay.contains(widget.user.uid)
                          ? {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TrialPayment(
                                      videoInfo: widget.videoInfo)))
                            }
                          : showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text(
                                    'Please pay 5 USD to download. This amount this used to keep the database running. '),
                                title: Text(
                                  'Help Keep this App Runing',
                                  style: TextStyle(fontSize: 18),
                                ),
                                actions: [
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                    color: APP_BAR_COLOR,
                                    child: Text(
                                      'Sure',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PaypalPayment(
                                              onFinish: (number) async {
                                                // payment done
                                                print('order id: ' + number);
                                                List newPayList =
                                                    widget.videoInfo.pay;
                                                newPayList.add(FirebaseAuth
                                                    .instance.currentUser.uid);
                                                FirebaseFirestore.instance
                                                    .collection('movies')
                                                    .doc(widget.videoInfo.id)
                                                    .update(
                                                        {'pay': newPayList});
                                              },
                                              user: widget.user,
                                              movieInfo: widget.videoInfo,
                                            ),
                                          ));
                                    },
                                  ),
                                  Text('         '),
                                  // ignore: deprecated_member_use
                                  FlatButton(
                                    child: Text('Not now'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            );
                    }
                  },
                  icon: Icon(Icons.download))
            ],
          ),
        ]));
  }
}
