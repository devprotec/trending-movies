// @dart=2.9

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:trending_movies/ads/makePayment.dart';
import 'package:trending_movies/ads/paypalPayment.dart';
import 'package:trending_movies/config/config.dart';
import 'package:trending_movies/reuseable/network_error_widget.dart';
import 'package:trending_movies/screens/descriptionPage.dart';
import 'package:trending_movies/screens/login.dart';
import 'package:trending_movies/screens/signinpage.dart';
import 'package:trending_movies/services/cloud_firestore_services.dart';
import 'package:trending_movies/screens/videopage.dart';
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

import 'home_page.dart';

int length;

class Favourates extends StatefulWidget {
  static String routeName = 'fourates';

  @override
  _FavouratesState createState() => _FavouratesState();
}

const int maxFailedLoadAttempts = 3;

class _FavouratesState extends State<Favourates> {
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
  bool _loadingAnchoredBanner = false;

  @override
  void initState() {
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
        adUnitId: InterstitialAd.testAdUnitId,
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

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _anchoredBanner?.dispose();
  }

  Widget build(BuildContext context) {
    if (!_loadingAnchoredBanner) {
      _loadingAnchoredBanner = true;
      _createAnchoredBanner(context);
    }
    final networkProvider = Provider.of<NetworkProvider>(context);
    User user = Provider.of<UserAuthProvider>(context).authUser ??
        FirebaseAuth.instance.currentUser;
    return WillPopScope(
      onWillPop: () => Navigator.pushNamedAndRemoveUntil(
          context, HomePage.routeName, (route) => false),
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, HomePage.routeName, (route) => false);
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              centerTitle: true,
              title: Text(
                'Favourites',
                style: APP_BAR_TEXTSTYLE,
              ),
              backgroundColor: APP_BAR_COLOR,
            ),
            body: networkProvider.connectionStatus
                ? Column(children: [
                    if (_anchoredBanner != null)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: AdWidget(ad: _anchoredBanner)),
                      ),
                    Expanded(child: adventureStream())
                  ])
                : Center(child: NoConnectivityWidget())),
      ),
    );
  }
}

Widget adventureStream() {
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
          length = data.length;

          if (data.length == 0)
            return Center(
              child: EmptyWidget(
                msg: 'There are no movies available. Please check back later',
              ),
            );
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return VideoCardFav(VideoInfo.fromMap(data[index], index));
              });
        } else
          return Text('has not data');
      });
}

class VideoCardFav extends StatefulWidget {
  final VideoInfo videoInfo;
  VideoCardFav(this.videoInfo);

  @override
  _VideoCardFavState createState() => _VideoCardFavState();
}

class _VideoCardFavState extends State<VideoCardFav> {
  Color iconColor;
  bool isFav;

  final SnackBar favRemovedSnackBar = SnackBar(
    content: Text('Movie removed from favourate list'),
    duration: Duration(seconds: 3),
  );

  final SnackBar notFavSnackBar = SnackBar(
      content: Text('Movie added to favourate list'),
      duration: Duration(seconds: 3));

  @override
  void initState() {
    if (!widget.videoInfo.fav.contains(FirebaseAuth.instance.currentUser.uid)) {
      length--;
      print(length);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserAuthProvider>(context).authUser ??
        FirebaseAuth.instance.currentUser;
    return widget.videoInfo.fav.contains(user.uid)
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
                        length--;
                      },
                      icon: Icon(Icons.favorite, color: Colors.red)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaypalPayment(
                                onFinish: (number) async {
                                  // payment done
                                  print('order id: ' + number);
                                },
                                user: user,
                                movieInfo: widget.videoInfo,
                              ),
                            ));
                      },
                      icon: Icon(Icons.download))
                ],
              ),
            ]))
        : length == 0
            ? EmptyWidget(
                msg: 'Your favourite list is empty',
              )
            : SizedBox.shrink();
  }
}
