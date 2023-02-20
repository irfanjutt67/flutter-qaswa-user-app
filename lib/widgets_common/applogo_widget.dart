import '../consts/consts.dart';

Widget applogoWidget(context) {
  var isdarkMode = Theme.of(context).brightness == Brightness.dark;
  return Image.asset(icdarklogo)
      .box
      .color(
          isdarkMode ? fontGrey.withOpacity(0.2) : whiteColor.withOpacity(0.2))
      .size(80, 80)
      .shadow
      .padding(const EdgeInsets.all(8))
      .rounded
      .make();
}
