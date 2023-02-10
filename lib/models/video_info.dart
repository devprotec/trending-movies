// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoInfo {
  String id;
  String name;
  String videoLink;
  String imageLink;
  String description;
  String type;
  Timestamp date;
  String year;
  List fav;
  List pay;

  VideoInfo(this.id, this.name, this.videoLink, this.imageLink, this.type,
      this.year, this.fav, this.pay);
  //ignore Non-nullable instance field 'description' must be initialized
  VideoInfo.fromMap(DocumentSnapshot data, int index) {
    this.id = data.id;
    this.name = data.data()['name'];
    this.videoLink = data.data()['videoLink'];
    this.imageLink = data.data()['imageLink'];
    this.description = data.data()['description'];
    this.type = data.data()['type'];
    this.date = data.data()['date'];
    this.year = data.data()['year'];
    this.fav = data.data()['fav'];
    this.pay = data.data()['pay'];
  }
}
