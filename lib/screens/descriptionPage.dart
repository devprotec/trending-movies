//@dart=2.9
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:trending_movies/ads/another_download.dart';
import 'package:trending_movies/ads/paypalPayment.dart';
import 'package:trending_movies/config/config.dart';
import 'package:trending_movies/models/video_info.dart';
import 'package:trending_movies/screens/videopage.dart';

import 'login.dart';

class DescriptionPage extends StatefulWidget {
  final VideoInfo _videoInfo;
  DescriptionPage(this._videoInfo);

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

const int maxFailedLoadAttempts = 3;

class _DescriptionPageState extends State<DescriptionPage> {
  final User user = FirebaseAuth.instance.currentUser;
  Color iconColor;
  bool isFav;
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  RewardedAd _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  BannerAd _anchoredBanner;
  BannerAd _anchoredBanner1;
  bool _loadingAnchoredBanner = false;
  bool _loadingAnchoredBanner1 = false;

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      widget._videoInfo.fav.contains(FirebaseAuth.instance.currentUser.uid)
          ? isFav = true
          : isFav = false;
      isFav ? iconColor = Colors.red : iconColor = Colors.black;
    }
    _createRewardedAd();
    _createInterstitialAd();
    super.initState();
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: RewardedAd.testAdUnitId,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
    });
    _rewardedAd = null;
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId:
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

  Future<void> _createAnchoredBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    final BannerAd banner = BannerAd(
      size: size,
      request: request,
      adUnitId:
          Platform.isAndroid ? 'ca-app-pub-2867866719230268/2038761122' : '',
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _anchoredBanner = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad:' + 'something not right' + '$error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }

  Future<void> _createAnchoredBanner1(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    final BannerAd banner = BannerAd(
      size: size,
      request: request,
      adUnitId:
          Platform.isAndroid ? 'ca-app-pub-2867866719230268/2038761122' : '',
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _anchoredBanner1 = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad:' + 'something not right' + '$error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _anchoredBanner?.dispose();
    _anchoredBanner1?.dispose();
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
    if (!_loadingAnchoredBanner) {
      _loadingAnchoredBanner = true;
      _createAnchoredBanner(context);
    }
    if (!_loadingAnchoredBanner1) {
      _loadingAnchoredBanner1 = true;
      _createAnchoredBanner1(context);
    }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context)),
          centerTitle: true,
          title: Text(widget._videoInfo.name),
          backgroundColor: APP_BAR_COLOR,
        ),
        body: Column(children: [
          if (_anchoredBanner != null)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: AdWidget(ad: _anchoredBanner)),
            ),
          SingleChildScrollView(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blueGrey,
                          blurRadius: 1,
                          spreadRadius: .1),
                    ]),

                //color: APP_BAR_COLOR,
                margin: EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  InkWell(
                    child: Image.network(widget._videoInfo.imageLink),
                    onTap: () {
                      _showInterstitialAd();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => VideoScreen(
                                path: widget._videoInfo.videoLink,
                              )));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget._videoInfo.name +
                              '(${widget._videoInfo.year})',
                          style: MEDIUM_WHITE_BUTTON_TEXT_BOLD,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (FirebaseAuth.instance.currentUser == null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            } else {
                              if (widget._videoInfo.fav.contains(
                                  FirebaseAuth.instance.currentUser.uid)) {
                                List newfavList = widget._videoInfo.fav;
                                newfavList.remove(
                                    FirebaseAuth.instance.currentUser.uid);
                                FirebaseFirestore.instance
                                    .collection('movies')
                                    .doc(widget._videoInfo.id)
                                    .update({'fav': newfavList});
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(favRemovedSnackBar);
                                isFav = false;
                              } else {
                                List newfavList = widget._videoInfo.fav;
                                newfavList
                                    .add(FirebaseAuth.instance.currentUser.uid);
                                FirebaseFirestore.instance
                                    .collection('movies')
                                    .doc(widget._videoInfo.id)
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
                              widget._videoInfo.pay.contains(user.uid)
                                  ? Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => TrialPayment(
                                              videoInfo: widget._videoInfo)))
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
                                                        print('order id: ' +
                                                            number);
                                                        List newPayList = widget
                                                            ._videoInfo.pay;
                                                        newPayList.add(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                .uid);
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'movies')
                                                            .doc(widget
                                                                ._videoInfo.id)
                                                            .update({
                                                          'pay': newPayList
                                                        });
                                                      },
                                                      user: user,
                                                      movieInfo:
                                                          widget._videoInfo,
                                                    ),
                                                  ));
                                            },
                                          ),
                                          Text('         '),
                                          // ignore: deprecated_member_use
                                          FlatButton(
                                            child: Text('Not now'),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    );
                            }
                          },
                          icon: Icon(Icons.download))
                    ],
                  ),
                ])),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
            child: Text(
              'Description',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 20.0),
            child: Text(
              widget._videoInfo.description,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                wordSpacing: 2,
                fontStyle: FontStyle.normal,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          Center(
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: APP_BAR_COLOR,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VideoScreen(
                          path: widget._videoInfo.videoLink,
                        )));
              },
              child: Text(
                'Watch Now',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (_anchoredBanner1 != null)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: AdWidget(ad: _anchoredBanner1)),
            ),
        ]));
  }
}
