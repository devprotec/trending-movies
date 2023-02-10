import 'package:flutter/material.dart';
import 'package:trending_movies/config/config.dart';

// ignore: must_be_immutable
class TermsTemplate extends StatelessWidget {
  final String? data;
  final String? title;
  TermsTemplate({this.title, this.data});
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: APP_BAR_COLOR,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          title!,
          style: APP_BAR_TEXTSTYLE,
        ),
        centerTitle: true,
      ),
      body: Theme(
        data: ThemeData(
          highlightColor: Colors.blue[300],
        ),
        child: Scrollbar(
          controller: _scrollController,
          isAlwaysShown: true,
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      data!,
                      style: PARAGRAPH_TEXTSTYLE,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
