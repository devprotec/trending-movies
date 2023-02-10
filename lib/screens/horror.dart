// @dart=2.9

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:trending_movies/config/config.dart';
import 'package:trending_movies/reuseable/network_error_widget.dart';
import 'package:trending_movies/screens/adventure.dart';
import 'package:trending_movies/screens/allmovies.dart';
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

class Horror extends StatefulWidget {
  @override
  _HorrorState createState() => _HorrorState();
}

class _HorrorState extends State<Horror> {
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    // User user = Provider.of<UserAuthProvider>(context).authUser ??
    //   FirebaseAuth.instance.currentUser;
    return SafeArea(
        child: Scaffold(
            body: networkProvider.connectionStatus
                ? horrorStream()
                : Center(child: NoConnectivityWidget())));
  }
}

Widget horrorStream() {
  var enrolledIds = <String>[];
  return StreamBuilder(
      stream: CloudFirestoreServices.getHorrorStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              //child: NetworkErrorWidget(),
              child: Text('There was an error'),
            ),
          );
        }
        if (snapshot.hasData) {
          List<DocumentSnapshot> data = snapshot.data.docs;
          print(data.length);
          // List<VideoInfo> videoList = data.cast();
          if (data.length == 0)
            return Center(
              child: EmptyWidget(
                msg: 'There are no movies available. Please check back later',
              ),
            );
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                //   if (enrolledIds.contains(data[index].id))
                //     return Container();
                return VideoCardOthers(
                    VideoInfo.fromMap(data[index], index), 'horror');
              });
        } else
          return Text('has not data');
      });
}
