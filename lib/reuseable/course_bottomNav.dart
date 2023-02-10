import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
//import 'package:gamie/Providers/course_bottomNav_provider.dart';
import 'package:provider/provider.dart';
import '../Providers/bottomNav_provider.dart';
import '../config/config.dart';

class CourseBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BottomNavProvider>(context);
    return BottomNavigationBar(
        onTap: (i) => provider.index = i,
        currentIndex: provider.index,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: provider.index == 0
                ? _activeNav(
                    Icons.note,
                  )
                : Icon(Icons.note),
            // ignore: deprecated_member_use
            title: Text("Slides"),
          ),
          BottomNavigationBarItem(
            icon: provider.index == 1
                ? _activeNav(Octicons.device_camera_video)
                : Icon(Octicons.device_camera_video),
            //ignore: deprecated_member_use
            title: Text("Videos"),
          ),
          BottomNavigationBarItem(
            icon: provider.index == 2
                ? _activeNav(Octicons.book)
                : Icon(Octicons.book),
            // ignore: deprecated_member_use
            title: Text("Books"),
          ),
          BottomNavigationBarItem(
            icon: provider.index == 3
                ? _activeNav(Octicons.question)
                : Icon(Octicons.question),
            // ignore: deprecated_member_use
            title: Text("Questions"),
          )
        ]);
  }
}

Widget _activeNav(IconData data) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: APP_BAR_COLOR.withOpacity(0.8),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30.0),
      child: Icon(data, color: Colors.white),
    ));
