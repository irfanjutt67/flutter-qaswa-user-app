import '../consts/consts.dart';

Widget outButton({onPress, color, textColor, String? title}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        // ignore: deprecated_member_use
        primary: color,
        padding: const EdgeInsets.all(12.0)),
    onPressed: onPress,
    child: title!.text.color(textColor).fontFamily(bold).make(),
  );
}
