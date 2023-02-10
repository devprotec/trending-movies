// @dart=2.9

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:trending_movies/ads/another_download.dart';
import 'package:trending_movies/ads/paypalPayment.dart';
import 'package:trending_movies/config/config.dart';
import 'package:trending_movies/screens/login.dart';
import 'package:trending_movies/services/cloud_firestore_services.dart';
import '../Providers/network_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/video_info.dart';
import '../reuseable/empty_items.dart';
import '../reuseable/no_connectivity_widget.dart';
import 'descriptionPage.dart';

_AllMoviesState _allMoviesState;
final List<VideoInfo> videoList = [];
final List<VideoInfo> payList = [];

class AllMovies extends StatefulWidget {
  @override
  _AllMoviesState createState() {
    _allMoviesState = _AllMoviesState();
    return _allMoviesState;
  }
}

class _AllMoviesState extends State<AllMovies> {
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    return SafeArea(
      child: Scaffold(
          body: networkProvider.connectionStatus
              ? movieStream()
              : Center(child: NoConnectivityWidget())),
    );
  }
}

Widget movieStream() {
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
              child: Text('There was an error'),
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
                return VideoCard(VideoInfo.fromMap(data[index], index));
              });
        } else
          return Text('has not data');
      });
}

class VideoCard extends StatefulWidget {
  final VideoInfo videoInfo;
  VideoCard(this.videoInfo);

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  // COMPLETE: Add _interstitialAd
  InterstitialAd _interstitialAd;

  // COMPLETE: Add _isInterstitialAdReady
  bool _isInterstitialAdReady = false;
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

  _removeDuplicate(VideoInfo info, int count) {
    for (int i = 0; i < videoList.length; i++) {
      if (videoList[i].id == widget.videoInfo.id) {
        count++;
        if (count > 1) videoList.remove(widget.videoInfo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    videoList.add(widget.videoInfo);
    _removeDuplicate(widget.videoInfo, 0);

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            //backgroundBlendMode: BlendMode.color,
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
              print(_isInterstitialAdReady.toString());
              if (_isInterstitialAdReady) {
                print(_isInterstitialAdReady.toString());
                // _interstitialAd.load();
              }
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
                  onPressed: () {
                    if (FirebaseAuth.instance.currentUser == null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    } else {
                      widget.videoInfo.pay
                              .contains(FirebaseAuth.instance.currentUser.uid)
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
                                title: Text('Help Keep this App Runing'),
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
                                              user: FirebaseAuth
                                                  .instance.currentUser,
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

  /* @override
  void dispose() {
    // COMPLETE: Dispose a BannerAd object

    // COMPLETE: Dispose an InterstitialAd object
    _interstitialAd.dispose();

    // COMPLETE: Dispose a RewardedAd object

    super.dispose();
  } */
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";
  List<VideoInfo> names = <VideoInfo>[];
  List<VideoInfo> filteredNames = <VideoInfo>[];
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Example');

  _SearchPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    this._getNames();
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: _buildBar(context),
        body: Container(
            child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(9.0, 8.0, 9.0, 8.0),
              child: TextField(
                onChanged: (value) => _searchPressed,
                controller: _filter,
                decoration: InputDecoration(
                  labelText: "enter movie name",
                  hintText: "search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                ),
              ),
            ),
            Expanded(child: _buildList()),
          ],
        )),
      ),
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List<VideoInfo> tempList = <VideoInfo>[];
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
                .name
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            _searchText
                .toLowerCase()
                .contains(filteredNames[i].name.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return filteredNames.length == 0
            ? Center(
                child: EmptyWidget(
                  msg: 'No movie matched your search',
                ),
              )
            : SearchVideoCard(filteredNames[index]);
      },
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search Example');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  void _getNames() async {
    final List<VideoInfo> response = videoList;
    List<VideoInfo> tempList = <VideoInfo>[];
    for (int i = 0; i < response.length; i++) {
      tempList.add(response[i]);
    }

    setState(() {
      names = tempList;
      names.shuffle();
      filteredNames = names;
    });
  }
}

class SearchVideoCard extends StatefulWidget {
  final VideoInfo videoInfo;
  SearchVideoCard(this.videoInfo);

  @override
  _SearchVideoCardState createState() => _SearchVideoCardState();
}

class _SearchVideoCardState extends State<SearchVideoCard> {
  Color iconColor;
  bool isFav;

  @override
  void initState() {
    if (widget.videoInfo.pay.contains(FirebaseAuth.instance.currentUser.uid)) {
      payList.add(widget.videoInfo);
    }
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
                  onPressed: () {
                    if (FirebaseAuth.instance.currentUser == null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    } else {
                      widget.videoInfo.pay
                              .contains(FirebaseAuth.instance.currentUser.uid)
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
                                              user: FirebaseAuth
                                                  .instance.currentUser,
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

                                  // ignore: deprecated_member_use
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
