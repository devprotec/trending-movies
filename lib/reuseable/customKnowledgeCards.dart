import 'package:flutter/material.dart';

class CustomKnowledgeCards extends StatelessWidget {
  final int? i;
  final int? currentPage;
  final String? info;
  final String? header;
  final Color? currentPageColor;
  final Color? otherPagesColor;

  CustomKnowledgeCards(
      {Key? key,
      this.i,
      this.currentPage,
      this.info,
      this.header,
      this.currentPageColor,
      this.otherPagesColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: i == currentPage ? 50 : 80, horizontal: 10.0),
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: i == currentPage ? 1 : 0,
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(header!,
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white)),
                SizedBox(
                  height: info == null ? 0 : 30,
                ),
                info != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          child: Text(
                            info!,
                            maxLines: 15,
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 16,
                                letterSpacing: 1.0,
                                color: Colors.white),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: i == currentPage ? currentPageColor : otherPagesColor,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 7,
                      spreadRadius: 5,
                      color: currentPage == i
                          ? Colors.grey.withOpacity(0.6)
                          : Colors.transparent)
                ]),
          ),
        ),
      ),
    );
  }
}
