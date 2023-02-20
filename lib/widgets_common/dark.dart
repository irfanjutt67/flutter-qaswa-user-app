import '../consts/consts.dart';

class AppTheme {
  static ThemeData darktheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    canvasColor: darkColor,
  );

  static ThemeData lightheme = ThemeData(
    primarySwatch: Colors.grey,
    canvasColor: whiteColor,
    brightness: Brightness.light,
  );
}
