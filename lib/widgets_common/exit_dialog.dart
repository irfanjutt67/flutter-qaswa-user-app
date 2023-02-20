import 'package:flutter/services.dart';
//
import '../consts/consts.dart';
import 'our_button.dart';

Widget exitDialog(context) {
  var isdarkMode = Theme.of(context).brightness == Brightness.dark;
  return AlertDialog(
    backgroundColor: isdarkMode ? darkColor : lightGrey,
    title: 'Confirm'
        .text
        .fontFamily(bold)
        .size(18)
        .color(isdarkMode ? fontGrey : darkFontGrey)
        .make(),
    content: 'Are you sure you want to exit'
        .text
        .color(isdarkMode ? fontGrey : darkFontGrey)
        .size(16)
        .make(),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          outButton(
            color: isdarkMode ? fontGrey : Colors.lightBlue.shade100,
            onPress: () {
              SystemNavigator.pop();
            },
            textColor: whiteColor,
            title: "Yes",
          ),
          outButton(
            color: isdarkMode ? fontGrey : Colors.lightBlue.shade100,
            onPress: () {
              Navigator.pop(context);
            },
            textColor: whiteColor,
            title: "No",
          ),
        ],
      )
    ],
  );
}
