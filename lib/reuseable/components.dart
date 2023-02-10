import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:trending_movies/config/config.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';

// STYLED CARD AS CONTAINER FOR ANY WIDGET
class CustomCard extends StatelessWidget {
  CustomCard({this.colour, this.cardChild});

  final Widget? cardChild;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(spreadRadius: 0, blurRadius: 50.0, offset: Offset(3, 5)),
        ],
      ),
      child: Center(child: cardChild),
    );
  }
}

// STYLED NUMBER INPUT FOR PHONE  NUMBERS
class PhoneInput extends StatefulWidget {
  const PhoneInput({
    this.keyboard = true,
    this.hint,
    this.value = "",
  });

  final String? hint;
  final bool keyboard;
  final String value;

  @override
  _PhoneInputState createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    textController.text = value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 4.0),
      child: TextField(
        controller: textController,
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        autocorrect: false,
        autofocus: false,
        showCursor: true,
        readOnly: !widget.keyboard,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 35.0,
          color: Colors.black,
          letterSpacing: 6,
        ),
        decoration: InputDecoration(
          labelText: widget.hint,
          labelStyle: SUBTITLE,
        ),
      ),
    );
  }
}

// STYLE THE TILE TO THE APP TOGETHER WITH ANY SLOGAN THERE MAYBE
class AppTitle extends StatelessWidget {
  const AppTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          APP_NAME,
          style: TITLE,
        ),
        Text(
          APP_SLOGAN,
          style: SUBTITLE,
        ),
      ],
    );
  }
}

// ANY TEXT TITLED TEXT WITH SUBTITLE
class SubtitledTitle extends StatelessWidget {
  const SubtitledTitle({
    @required this.title,
    this.subtitle = "",
    this.alignment = Alignment.center,
  });

  final Alignment alignment;
  final String subtitle;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
            alignment: alignment,
            child: Text(
              title!,
              style: TITLE,
            )),
        Align(
            alignment: alignment,
            child: Text(
              subtitle,
              style: SMALL,
            )),
      ],
    );
  }
}

class NumberInput extends StatefulWidget {
  const NumberInput(
      {this.info,
      @required this.buttonText,
      @required this.onSubmit,
      this.numberFieldHint = "Enter Number"});

  final String? buttonText;
  final String? info;
  final String numberFieldHint;
  final Function? onSubmit;

  @override
  _NumberInputState createState() => _NumberInputState();
}

String value = "";

class _NumberInputState extends State<NumberInput> {
  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PhoneInput(keyboard: false, hint: widget.numberFieldHint, value: value),
        Text(
          widget.info!,
          style: SUBTITLE,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 0),
          child: VirtualKeyboard(
            type: VirtualKeyboardType.Numeric,
            onKeyPress: (key) {
              switch (key.keyType) {
                case VirtualKeyboardKeyType.String:
                  setState(() {
                    value = value + key.text;
                  });
                  return;
                case VirtualKeyboardKeyType.Action:
                  if (key.action == VirtualKeyboardKeyAction.Backspace) {
                    setState(() {
                      value = value.substring(0, value.length - 1);
                    });
                  }
                  return;
              }
            },
            textColor: Colors.black,
            fontSize: 35,
            height: 250,
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 0, right: 0, top: 28.0, bottom: 0),
          child: ButtonTheme(
            minWidth: double.infinity,
            height: 50,
            child: RaisedButton(
              onPressed: () => widget.onSubmit,
              color: Colors.blueGrey,
              textColor: Colors.white,
              child: Text(
                widget.buttonText!,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//custom background design
class CustomBackground extends StatelessWidget {
  const CustomBackground({Key? key, this.backPicture}) : super(key: key);

  final backPicture;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 100,
              left: 50,
              right: 50,
              child: Container(
                  height: 250,
                  width: 150,
                  child: backPicture == null
                      ? SizedBox()
                      : Image.asset(
                          backPicture,
                          fit: BoxFit.cover,
                        ))),
          Align(
            alignment: Alignment.topLeft,
            child: RotatedBox(
              quarterTurns: 2,
              child: Container(
                  height: 150,
                  width: 200,
                  child: Image.asset(
                    "assets/images/login_bottom.png",
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
                height: 150,
                width: 200,
                child: Image.asset(
                  "assets/images/login_bottom.png",
                  fit: BoxFit.cover,
                )),
          ),
        ],
      ),
    );
  }
}

class PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: PHONE_TEXT,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          // focusedBorder: InputBorder(borderSide: BorderSide()),
          // focusColor: Colors.black,
          hintText: 'Enter your phone number',
          hintStyle: HINT_TEXT_STYLE),
    );
  }
}

class CustomRoundedButton extends StatelessWidget {
  final text;
  final Color? color;
  final textColor;
  final icon;
  final image;
  final iconColor;
  final textSize;
  final radius;
  final double? height;
  final Function? onTap;
  const CustomRoundedButton(
      {Key? key,
      this.textColor,
      this.image,
      this.onTap,
      this.iconColor,
      this.icon,
      this.radius,
      this.text,
      this.textSize,
      this.height,
      this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      // ignore: deprecated_member_use
      child: (FlatButton(
        onPressed: () => onTap,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon == null
                ? SizedBox(
                    child: image != null
                        ? Padding(
                            padding: EdgeInsets.only(right: 5.0),
                            child: Container(
                              height: 20,
                              child: Image.asset(
                                image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : SizedBox(),
                  )
                : Icon(
                    icon,
                    color: iconColor,
                  ),
            Text(
              text,
              style: TextStyle(
                  color: textColor,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.bold,
                  fontSize: textSize != null ? textSize : 18),
            ),
          ],
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        color: color,
      )),
    );
  }
}

class CustomCodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          style: SINGLE_CODE_STYLE,
          textAlign: TextAlign.center,
          cursorColor: ASCENT_COLOR,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(),
        ),
      ),
    );
  }
}

class CustomBackIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Row(
        children: <Widget>[
          Icon(
            Icons.arrow_back_ios,
            color: ASCENT_COLOR,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "BACK",
            style: MEDIUM,
          )
        ],
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final image;
  final icon;
  final iconColor;
  final borderColor;
  final borderHighlightColor;
  final borderRadius;
  final imageSize;
  final buttonHeight;
  final buttonWidth;
  final String? text;
  final Function? onPressed;

  CustomOutlinedButton(
      {Key? key,
      this.borderRadius,
      this.imageSize,
      this.buttonWidth,
      this.buttonHeight,
      this.image,
      this.icon,
      this.text,
      this.onPressed,
      this.iconColor = Colors.black,
      this.borderColor = Colors.black,
      this.borderHighlightColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: buttonWidth,
        height: buttonHeight,
        child: OutlineButton(
          onPressed: () => onPressed,
          borderSide: BorderSide(color: borderColor),
          highlightedBorderColor: borderHighlightColor,
          child: icon == null && text != null
              ? Text(text!)
              : icon == null && text == null
                  ? (Container(
                      height: imageSize,
                      child: Image.asset(image, fit: BoxFit.cover)))
                  : Container(
                      child: Icon(
                      icon,
                      color: iconColor,
                    )),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ));
  }
}

//custom text field for filling out forms
class CustomFormTextField extends StatelessWidget {
  final double? height;
  final TextInputType? keyType;
  final IconData? icon;
  final Color? iconColor;
  final String? placeholder;
  final bool? obsecureText;
  final TextStyle? placeHolderTextStyle;
  final double? radius;

  const CustomFormTextField(
      {Key? key,
      this.height,
      this.keyType,
      this.icon,
      this.placeholder,
      this.obsecureText,
      this.placeHolderTextStyle,
      this.radius,
      this.iconColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TextField(
        keyboardType: keyType,
        obscureText: obsecureText!,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(radius!)),
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            labelStyle: placeHolderTextStyle,
            labelText: placeholder,
            prefixIcon: Icon(
              icon,
              color: iconColor,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius!))),
      ),
    );
  }
}

// class CountryDropdown extends StatefulWidget{
//   @override
//   _CountryDropdownState createState() => _CountryDropdownState();
// }

// class _CountryDropdownState extends State<CountryDropdown> {
//   @override
//   Country _selected;
//   Widget build(BuildContext context) {
// ignore: todo
//     // TODO: implement build
//     return CountryPicker(
//           showDialingCode: true,
//           onChanged: (Country country) {
//             setState(() {
//               _selected = country;
//             });
//           },
//           selectedCountry: _selected,
//       );
//   }
// }

class DateSelection extends StatelessWidget {
  final Function? onDateChanged;
  DateSelection({Key? key, this.onDateChanged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoDatePicker(
        initialDateTime: selectedDate,
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (val) {
          onDateChanged!(val);
          selectedDate = val;
        });
  }
}

DateTime selectedDate = DateTime.now();

// ignore: must_be_immutable
class EducationLevelSelection extends StatefulWidget {
  Function? onItemChanged;
  EducationLevelSelection({this.onItemChanged});

  @override
  _EducationLevelSelectionState createState() =>
      _EducationLevelSelectionState();
}

class _EducationLevelSelectionState extends State<EducationLevelSelection> {
  List<String> educationLevels = ["Primary", "Secondary", "Tertiary"];

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
        itemExtent: 25,
        onSelectedItemChanged: (val) {
          widget.onItemChanged!(educationLevels[val]);
        },
        children: educationLevels.map((e) => Text(e)).toList());
  }
}

//created a new screen for terms and conditions
// class Terms extends StatefulWidget {
//   @override
//   _TermsState createState() => _TermsState();
// }

// class _TermsState extends State<Terms> {
//   String termsData =
//       "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           Align(
//               alignment: Alignment.centerRight,
//               child: IconButton(
//                   icon: Icon(
//                     Icons.close,
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   })),
//           Text("TERMS AND CONDITIONS", style: NORMAL_BLACK_BUTTON_TEXT),
//           SizedBox(height: 10),
//           SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     termsData,
//                     style: SMALL_WITH_BLACK,
//                   ),
//                   SizedBox(height: 25)
//                 ],
//               ),
//             ),
//           )
//         ]));
//   }
// }

// ignore: must_be_immutable
class CustomCreditCard extends StatefulWidget {
  var name;
  DateTime? expiryDate;
  String? cardNumber;
  CustomCreditCard({this.cardNumber, this.expiryDate, this.name});

  @override
  _CustomCreditCardState createState() => _CustomCreditCardState();
}

class _CustomCreditCardState extends State<CustomCreditCard> {
  List<Map<String, dynamic>> cardImage = [
    {"cardType": "mastercard", "imagePath": "assets/images/mastercard.png"},
    {"cardType": "visa card", "imagePath": "assets/images/visa_card.png"},
    {
      "cardType": "american express",
      "imagePath": "assets/images/american_express.png"
    }
  ];

  Map? _currentCard;

  // DateTime expDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    if (widget.cardNumber!.startsWith('4')) {
      _currentCard = cardImage[1];
    } else if (widget.cardNumber!.startsWith('5')) {
      _currentCard = cardImage[0];
    } else if (widget.cardNumber!.startsWith('3')) {
      _currentCard = cardImage[2];
    }
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 8,
              offset: Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Container(
              height: 60,
              child: Image.asset(
                "assets/images/sim.png",
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Container(
                  child: Text(
                "${this.widget.cardNumber == null || this.widget.cardNumber!.isEmpty ? "XXXX XXXX XXXX XXXX" : widget.cardNumber}",
                style: CREDIT_CARD_TEXTSTYLE,
              )),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Container(
                  child: Text(
                      "Expiry Date: ${widget.expiryDate!.day} - ${widget.expiryDate!.month} - ${widget.expiryDate!.year}",
                      style: CREDIT_CARD_TEXTSTYLE)),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Container(
                  child: Text(
                "${this.widget.name == null ? "" : this.widget.name}",
                style: CREDIT_CARD_TEXTSTYLE,
              )),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                children: <Widget>[
                  Container(
                      height: 45,
                      width: 60,
                      child: _currentCard == null
                          ? SizedBox()
                          : Image.asset(_currentCard!["imagePath"])),
                  Text(
                      "${_currentCard == null ? "Card Unknown" : _currentCard!["cardType"]}",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Montserrat",
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
