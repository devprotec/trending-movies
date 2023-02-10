// @dart=2.9

//import 'dart:html';

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trending_movies/ads/another_download.dart';
//import 'package:paypal/models/invoiceModel.dart';

//import 'package:trending_movies/ads/makePayment.dart';
import 'package:trending_movies/ads/paypalPayment.dart';
import 'package:trending_movies/config/config.dart';
import 'package:trending_movies/reuseable/network_error_widget.dart';
import 'package:trending_movies/screens/descriptionPage.dart';
import 'package:trending_movies/screens/login.dart';
import 'package:trending_movies/screens/process.dart';
//import 'package:trending_movies/screens/signinpage.dart';
import 'package:trending_movies/services/cloud_firestore_services.dart';
//import 'package:trending_movies/screens/videopage.dart';
import '../Providers/authUserProvider.dart';
import '../Providers/network_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/video_info.dart';
import '../reuseable/empty_items.dart';
import '../reuseable/no_connectivity_widget.dart';
//import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:paypal/paypal.dart';

List<VideoInfo> movieList = [];

class Adventure extends StatelessWidget {
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    User user = Provider.of<UserAuthProvider>(context).authUser ??
        FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(
          body: networkProvider.connectionStatus
              ? adventureStream()
              : Center(child: NoConnectivityWidget())),
    );
  }
}

Widget adventureStream() {
  PayPal request = PayPal();
  return StreamBuilder(
      stream: CloudFirestoreServices.getMoviesStream(),
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
                return VideoCardOthers(
                    VideoInfo.fromMap(data[index], index), 'sc-fi');
              });
        } else
          return Text('has not data');
      });
}

class VideoCardOthers extends StatefulWidget {
  final VideoInfo videoInfo;
  final String type;
  VideoCardOthers(this.videoInfo, this.type);

  @override
  _VideoCardOthersState createState() => _VideoCardOthersState();
}

const int maxFailedLoadAttempts = 3;

class _VideoCardOthersState extends State<VideoCardOthers> {
  Color iconColor;
  bool isFav;
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      widget.videoInfo.fav.contains(FirebaseAuth.instance.currentUser.uid)
          ? isFav = true
          : isFav = false;
      isFav ? iconColor = Colors.red : iconColor = Colors.black;
    }

    _createInterstitialAd();
    super.initState();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId:
            //InterstitialAd.testAdUnitId,
            Platform.isAndroid ? 'ca-app-pub-2867866719230268/3320941250' : '',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState

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
    //final List<VideoInfo> movieList = [];
    movieList.add(widget.videoInfo);
    User user = Provider.of<UserAuthProvider>(context).authUser ??
        FirebaseAuth.instance.currentUser;
    return widget.videoInfo.type.toLowerCase() == widget.type
        ? Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.blueGrey, blurRadius: 1, spreadRadius: .1),
                ]),

            //color: APP_BAR_COLOR,
            margin: EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
            padding: EdgeInsets.all(10),
            child: Column(children: [
              InkWell(
                child: Image.network(widget.videoInfo.imageLink),
                onTap: () {
                  _showInterstitialAd();
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
                          if (widget.videoInfo.fav.contains(
                              FirebaseAuth.instance.currentUser.uid)) {
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
                            newfavList
                                .add(FirebaseAuth.instance.currentUser.uid);
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
                          widget.videoInfo.pay.contains(user.uid)
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
                                                builder: (context) =>
                                                    PaypalPayment(
                                                  onFinish: (number) async {
                                                    // payment done
                                                    print(
                                                        'order id: ' + number);
                                                    List newPayList =
                                                        widget.videoInfo.pay;
                                                    newPayList.add(FirebaseAuth
                                                        .instance
                                                        .currentUser
                                                        .uid);
                                                    FirebaseFirestore.instance
                                                        .collection('movies')
                                                        .doc(
                                                            widget.videoInfo.id)
                                                        .update({
                                                      'pay': newPayList
                                                    });
                                                  },
                                                  user: user,
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
            ]))
        : SizedBox.shrink();
  }

  /* static Future downloadFile(Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');

    TaskSnapshot download = await ref.writeToFile(file);
    DownloadTask task = download as DownloadTask;
    //TaskState taskState =  download.state;
    // if(TaskState.paused == download.state)
  } */
}
