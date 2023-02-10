import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// APPLICATION LEVEL CONSTANTS
const String APP_NAME = "Trending Movies";
const String APP_SLOGAN = "Learn. Excel. Earn";
const String USER_PROFILE_PIC = "assets/images/default_user_avatar.png";
const DEFAULT_USER_AVATAR = "assets/images/default_user_avatar.png";
const String USER_AVATAR_FILENAME = "headshot.png";
// ignore: non_constant_identifier_names
String? USER_PROFILE_PIC_FROM_FILE;

// LocalStorage keys
const PREFS_PERSONAL_INFO = "personal_info";
const PREFS_PAYMENT_METHODS = "payment_methods";

// Database constants
const String DATABASE_NAME = "tpp.db";

// UNIVERSAL STYLING VALUES
const double BLUR = 1.50;
const double SPREAD = 1.50;

// LINKS TO IMAGES USED
const String PAST_QUESTIONS_BG = "assets/images/learning.webp";

// THEME DATA VALUES
const Color ASCENT_COLOR = Color(0xFF5A3EA4);
const Color PRIMARY_COLOR = Colors.black;
const Color MAIN_BACK_COLOR = Colors.white;
const Color ASH_BUTTON_COLOR = Color.fromRGBO(241, 242, 243, 1);
const Color LIGHT_BLUE_BUTTON_COLOR = Color.fromRGBO(95, 133, 229, 1);
const Color FACEBOOK_BLUE_COLOR = Color.fromRGBO(81, 84, 154, 1);
// ET

//APP-BAR CoLOR

const Color APP_BAR_COLOR = Color.fromRGBO(47, 154, 186, 1);

//images path
const String GETTING_STARTED_IMG = "assets/images/get_started.png";
const String FACEBOOK_IMG = "assets/images/facebook.svg";
const String GOOGLE_IMG = "assets/images/google_1.png";
const String GIRL_WITH_LAPTOP_IMG = "assets/images/girl_with_laptop.png";

const TextStyle NORMAL = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 20.0,
  color: Colors.black,
);

//normal button text
const TextStyle NORMAL_BLACK_BUTTON_TEXT = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20.0,
    color: Colors.black,
    fontFamily: "Montserrat");

const TextStyle NORMAL_WHITE_BUTTON_LABEL = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: Colors.white,
    fontFamily: "Montserrat");

const TextStyle INPUT_TEXT_STYLE = TextStyle(
  fontFamily: "Montserrat",
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

const TextStyle MEDIUM_WHITE_BUTTON_TEXT = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16.0,
    color: Colors.white,
    fontFamily: "Montserrat");

const TextStyle MEDIUM_WHITE_BUTTON_TEXT_BOLD = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
    color: Colors.black,
    fontFamily: "Montserrat");
const TextStyle TITLE = TextStyle(
    fontWeight: FontWeight.w700,
    //title fontsize tweaked from 25 to 28
    fontSize: 28.0,
    color: Colors.black,
    letterSpacing: 2,
    //raleway font family added
    fontFamily: 'Raleway');
const TextStyle SUBTITLE = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 15.0,
  color: Colors.black38,
);

//disabled text design
const TextStyle DISABLED_TEXT = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18.0,
    color: Colors.black54,
    fontFamily: 'Raleway',
    letterSpacing: 0.1);

//disabled text design
const TextStyle SMALL_DISABLED_TEXT = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 13.0,
    color: Colors.black38,
    fontFamily: 'Montserrat',
    letterSpacing: 0.1);

const TextStyle MEDIUM_DISABLED_TEXT = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16.0,
    color: Colors.black38,
    fontFamily: 'Montserrat',
    letterSpacing: 0.1);

const TextStyle SMALL_BLUE_TEXT_STYLE = TextStyle(
    color: Color.fromRGBO(8, 87, 171, 1),
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w600);

const TextStyle LABEL_TEXT_STYLE = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16.0,
    color: Colors.black54,
    fontFamily: 'Montserrat',
    letterSpacing: 0.1);

const TextStyle LABEL_TEXT_STYLE_MEDIUM = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18.0,
    color: Colors.black54,
    fontFamily: 'Montserrat',
    letterSpacing: 0.1);

const TextStyle LABEL_TEXT_STYLE_MEDIUM_BLACK = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18.0,
    color: Colors.black,
    fontFamily: 'Montserrat',
    letterSpacing: 0.1);

//Small text design
const TextStyle SMALL = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
    color: ASCENT_COLOR,
    fontFamily: 'Raleway');

//Small text design
const TextStyle SMALL_WITH_BLACK = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 13.0,
    color: Colors.black,
    fontFamily: 'Raleway');

//NORMAL HEADER
const TextStyle NORMAL_HEADER = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18.0,
    color: Colors.black,
    fontFamily: 'Montserrat');

const TextStyle MEDIUM = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: ASCENT_COLOR,
    fontFamily: 'Raleway');
const TextStyle HINT_TEXT_STYLE = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13.0,
    color: Colors.black54,
    fontFamily: 'Raleway');

const TextStyle PHONE_TEXT = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: Colors.black,
    fontFamily: 'Raleway');

const TextStyle UNDERLINED_TEXT = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: Colors.black,
    fontFamily: 'Raleway',
    decoration: TextDecoration.underline);

const TextStyle UNDERLINED_TEXT_SM = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: Colors.black,
    fontFamily: 'Montserrat',
    decoration: TextDecoration.underline);

const SINGLE_CODE_STYLE = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20.0,
    color: Colors.black,
    fontFamily: 'Raleway');

const APP_BAR_TEXTSTYLE = TextStyle(
    fontFamily: "Montserrat", fontWeight: FontWeight.w600, color: Colors.white);

//textstyle on credit card

const CREDIT_CARD_TEXTSTYLE = TextStyle(
  letterSpacing: 1.5,
  fontFamily: "Orbitron",
  color: Colors.grey,
);
const SMALL_BLUE_LABEL_TEXTSTYLE = TextStyle(
  color: Color.fromRGBO(5, 32, 127, 1),
  fontFamily: "Montserrat",
  fontSize: 13,
  fontWeight: FontWeight.w600,
);

const ERROR_MSG_TEXTSTYLE = TextStyle(
  color: Colors.redAccent,
  fontFamily: "Montserrat",
  fontSize: 13,
  fontWeight: FontWeight.w600,
);

//paragraph textstyle
const TextStyle PARAGRAPH_TEXTSTYLE = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    fontSize: 17,
    wordSpacing: 1.5);
