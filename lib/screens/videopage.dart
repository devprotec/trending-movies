// @dart=2.9
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:trending_movies/config/config.dart';
//import 'package:gamie/screens/homeScreenNavs/learn.dart';
import 'package:video_player/video_player.dart';

_VideoItemsState __videoItemsState;

class VideoItems extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  final bool looping;
  final bool autoplay;
  //final Key key;

  VideoItems({
    @required this.videoPlayerController,
    this.looping,
    this.autoplay,
    Key key,
  }) : super(key: key);

  @override
  _VideoItemsState createState() {
    __videoItemsState = _VideoItemsState();
    return __videoItemsState;
  }
}

class _VideoItemsState extends State<VideoItems> {
  ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      autoPlay: widget.autoplay,
      looping: widget.looping,
      allowedScreenSleep: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  final String path;

  VideoScreen({this.path});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  String controllerPath;
  String string;

  @override
  void initState() {
    super.initState();
    loadURL();
    loadController();
  }

  loadURL() async {
    // string = await widget.reference.getDownloadURL();

    return string;
  }

  loadController() async {
    controllerPath = await loadURL();
    print(controllerPath + 'meee');
    return controllerPath;
  }

  @override
  Widget build(BuildContext context) {
    print(controllerPath);
    return WillPopScope(
      onWillPop: () {
        try {
          __videoItemsState._chewieController.pause();
          Navigator.of(context).pop();
          __videoItemsState.dispose();
        } on Exception catch (_) {
          return null;
        }
      },
      child: Scaffold(
          backgroundColor: Colors.blueGrey[100],
          appBar: AppBar(
            backgroundColor: APP_BAR_COLOR,
            centerTitle: true,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  try {
                    __videoItemsState._chewieController.pause();
                    Navigator.of(context).pop();
                    __videoItemsState.dispose();
                  } on Exception catch (_) {
                    return null;
                  }
                }),
            automaticallyImplyLeading: false,
            title: Text('Flutter Video Player Demo', style: APP_BAR_TEXTSTYLE),
          ),
          body: Container(
            child: VideoItems(
              videoPlayerController: VideoPlayerController.network(widget.path),
              looping: false,
              autoplay: false,
            ),
          )),
    );
  }
}
