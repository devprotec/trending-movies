// @dart=2.9
import 'dart:io';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:provider/provider.dart';
import 'package:trending_movies/Providers/network_provider.dart';
import 'package:trending_movies/ads/ad_helper.dart';

import 'package:trending_movies/config/config.dart';
import 'package:trending_movies/models/drawer.dart';
import 'package:trending_movies/screens/adventure.dart';
import 'package:trending_movies/screens/allmovies.dart';
import 'package:trending_movies/screens/horror.dart';
import 'package:trending_movies/screens/recently_added.dart';

import '../reuseable/bottomNav.dart';
import '../Providers/bottomNav_provider.dart';
import 'package:connectivity_widget/connectivity_widget.dart';

import 'action.dart';

//import 'package:double_back_to_close_app/double_back_to_close_app.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  static String routeName = "home_screen";

  @override
  _HomePageState createState() => _HomePageState();
}

const int maxFailedLoadAttempts = 3;

class _HomePageState extends State<HomePage> {
  /* BannerAd _bannerAd;
  // COMPLETE: Add _bannerAd

  // COMPLETE: Add _isBannerAdReady
  bool _isBannerAdReady = false;

  // COMPLETE: Add _interstitialAd
  InterstitialAd _interstitialAd;

  // COMPLETE: Add _isInterstitialAdReady
  bool _isInterstitialAdReady = false;
 */

  final RequestConfiguration req =
      RequestConfiguration(testDeviceIds: ["5EDA851B5D1E23B5C999D0530646F659"]);

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
    super.initState();

    _createRewardedAd();
    _createInterstitialAd();

    // COMPLETE: Initialize _bannerAd
    /* _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );  */

    //_bannerAd.load();

    // COMPLETE: Initialize _interstitialAd
    /*  _interstitialAd = InterstitialAd(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
          ad.dispose();
        },
        onAdClosed: (_) {
          //  _moveToHome();
        },
      ),
    ); */
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

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _anchoredBanner?.dispose();
  }

  List<Widget> _navbody = [
    AllMovies(),
    //SearchPage(),
    RecentlyAdded(),
    Horror(),
    ActionMovies(),
    Adventure(),
    // SearchPage(),
  ];

  Widget _buildHome(int index) => (_navbody[index]);

  @override
  Widget build(BuildContext context) {
    if (!_loadingAnchoredBanner) {
      _loadingAnchoredBanner = true;
      _createAnchoredBanner(context);
    }
    final net = Provider.of<NetworkProvider>(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          APP_NAME,
          style: APP_BAR_TEXTSTYLE,
        ),
        leading: Builder(
            builder: (context) => IconButton(
                  icon: IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    padding: EdgeInsets.all(0),
                    iconSize: 45,
                    icon: Icon(Icons.menu, color: Colors.white),
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                )),
        backgroundColor: APP_BAR_COLOR,
        actions: [
          IconButton(
              onPressed: () {
                _navbody[0] = SearchPage();
                final provider =
                    Provider.of<BottomNavProvider>(context, listen: false);
                provider.index = 0;
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => HomePage()));
              },
              icon: Icon(Icons.search))
        ],
      ),
      // drawer: CustomDrawer(),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(content: Text('Tab back again to leave app')),
        child: Column(children: [
          if (_anchoredBanner != null)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: AdWidget(ad: _anchoredBanner)),
            ),
          Expanded(
            child: ConnectivityWidget(
                onlineCallback: () => net.setInternet = true,
                offlineCallback: () => net.setInternet = false,
                builder: (context, snapshot) {
                  // print(snapshot);
                  return SafeArea(child: Consumer<BottomNavProvider>(
                      builder: (context, snapshot, widget) {
                    return _buildHome(snapshot.index);
                  }));
                }),
          ),
        ]),
      ),
      bottomNavigationBar: BottomNav(), drawer: CustomDrawer(),
    ));
  }
}

/* @override
  void dispose() {
    // COMPLETE: Dispose a BannerAd object
    _bannerAd.dispose();

    // COMPLETE: Dispose an InterstitialAd object
    _interstitialAd.dispose();

    // COMPLETE: Dispose a RewardedAd object

    super.dispose();
  }
}
 */
