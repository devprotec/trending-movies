import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import '../Providers/bottomNav_provider.dart';
import '../config/config.dart';
import 'icons.dart';

class BottomNav extends StatelessWidget {
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
                    Icons.movie,
                  )
                : Icon(Icons.movie),
            // ignore: deprecated_member_use
            title: Text("All Movies"),
          ),
          BottomNavigationBarItem(
            icon: provider.index == 1
                ? _activeNav(MyIcons.recent)
                : Icon(MyIcons.recent),
            //ignore: deprecated_member_use
            title: Text("Recent"),
          ),
          BottomNavigationBarItem(
            icon: provider.index == 2
                ? _activeNav(MyIcons.horror_skull)
                : Icon(MyIcons.horror_skull),
            // ignore: deprecated_member_use
            title: Text("Horror"),
          ),
          BottomNavigationBarItem(
            icon: provider.index == 3
                ? _activeNav(MyIcons.gun)
                : Icon(MyIcons.gun),
            // ignore: deprecated_member_use
            title: Text("Action"),
          ),
          BottomNavigationBarItem(
            icon: provider.index == 4
                ? _activeNav(Icons.science)
                : Icon(Icons.science),
            // ignore: deprecated_member_use
            title: Text("Sc-Fi"),
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
