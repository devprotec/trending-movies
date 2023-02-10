// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:trending_movies/Providers/intro_preference.dart';
import 'package:trending_movies/screens/allmovies.dart';
import 'package:trending_movies/config/config.dart';
import 'package:trending_movies/screens/favourates.dart';
import 'package:trending_movies/screens/home_page.dart';
import 'package:trending_movies/screens/login.dart';
import 'package:trending_movies/screens/signinpage.dart';
import 'Providers/authUserProvider.dart';
import 'Providers/bottomNav_provider.dart';
import 'Providers/network_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simple_connectivity/simple_connectivity.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

const debug = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: debug);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
// MediationTestSuite.launch(MainActivity.this);

  var con = await Connectivity().checkConnectivity();
  bool status = false;
  if (con == ConnectivityResult.mobile || con == ConnectivityResult.wifi) {
    status = true;
  } else {
    status = false;
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: APP_BAR_COLOR, // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness.light, //status barIcon Brightness
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: APP_BAR_COLOR //navigation bar icon
      ));
  bool introstatus = await IntroPreferences.getBoolValuesSF();
  runApp(introstatus == true ? MyApp(connection: status) : Start());
}

class Start extends StatelessWidget {
  // Making list of pages needed to pass in IntroViewsFlutter constructor.
  final pages = [
    PageViewModel(
      pageColor: const Color(0xFF03A9F4),
      // iconImageAssetPath: 'assets/air-hostess.png',
      bubble: Image.asset('assets/images/google.png'),
      body: const Text(
        'Hassle-free  booking  of  flight  tickets  with  full  refund  on  cancellation',
      ),
      title: const Text(
        'Flights',
      ),
      titleTextStyle:
          const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      mainImage: Image.asset(
        'assets/images/invite-img.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
    ),
    PageViewModel(
      pageColor: const Color(0xFF8BC34A),
      iconImageAssetPath: 'assets/images/girl_with_laptop.png',
      body: const Text(
        'We  work  for  the  comfort ,  enjoy  your  stay  at  our  beautiful  hotels',
      ),
      title: const Text('Hotels'),
      mainImage: Image.asset(
        'assets/images/invite-img.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle:
          const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageBackground: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            stops: [0.0, 1.0],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            tileMode: TileMode.repeated,
            colors: [
              Colors.orange,
              Colors.pinkAccent,
            ],
          ),
        ),
      ),
      iconImageAssetPath: 'assets/images/courses.jpg',
      body: const Text(
        'Easy  cab  booking  at  your  doorstep  with  cashless  payment  system',
      ),
      title: const Text('Cabs'),
      mainImage: Image.asset(
        'assets/images/girl_with_laptop.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle:
          const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IntroViews Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          pageButtonTextSize: 14.0,
          showNextButton: true,
          showBackButton: true,
          showSkipButton: false,
          onTapDoneButton: () async {
            var con = await Connectivity().checkConnectivity();
            bool status = false;
            if (con == ConnectivityResult.mobile ||
                con == ConnectivityResult.wifi) {
              status = true;
            } else {
              status = false;
            }
            // Use Navigator.pushReplacement if you want to dispose the latest route
            // so the user will not be able to slide back to the Intro Views.
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => MyApp(
                          connection: status,
                        )));
            IntroPreferences.addBoolToSF(true);
            IntroPreferences.getBoolValuesSF();
          },
          pageButtonTextStyles: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final bool connection;

  const MyApp({Key key, this.connection}) : super(key: key);
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserAuthProvider(),
        ),
        /*   ChangeNotifierProvider(
          create: (_) => EditProfileProvider(),
        ),*/
        ChangeNotifierProvider(
          create: (_) => BottomNavProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NetworkProvider(this.connection),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
          routes: {
            HomePage.routeName: (context) => HomePage(),

            Favourates.routeName: (context) => Favourates(),
            RegisterScreen.routeName: (context) => RegisterScreen(),
            LoginScreen.routeName: (context) => LoginScreen(),
            //  PascoPage.routeName: (context) => PascoPage(),
          }),
    );
  }
}

class AppBase extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
      child: IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AllMovies()));
          },
          icon: Icon(Icons.home)),
    )));
  }
}
