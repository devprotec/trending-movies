// @dart=2.9

import 'package:flutter/material.dart';
import 'package:trending_movies/reuseable/network_error_widget.dart';
import 'package:trending_movies/screens/adventure.dart';
import 'package:trending_movies/services/cloud_firestore_services.dart';
import '../Providers/network_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/video_info.dart';
import '../reuseable/empty_items.dart';
import '../reuseable/no_connectivity_widget.dart';

class ActionMovies extends StatefulWidget {
  @override
  _ActionMoviesState createState() => _ActionMoviesState();
}

class _ActionMoviesState extends State<ActionMovies> {
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    // User user = Provider.of<UserAuthProvider>(context).authUser ??
    //   FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(
          body: networkProvider.connectionStatus
              ? actionStream()
              : Center(child: NoConnectivityWidget())),
    );
  }

  Widget actionStream() {
    return StreamBuilder(
        stream: CloudFirestoreServices.getActionsStream(),
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

            if (data.length == 0)
              return Center(
                child: EmptyWidget(
                  msg:
                      'There are no courses available. Please check back later',
                ),
              );
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return VideoCardOthers(
                      VideoInfo.fromMap(data[index], index), 'action');
                });
          } else
            return Text('has not data');
        });
  }
}
