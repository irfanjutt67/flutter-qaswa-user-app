import '../../../consts/consts.dart';

Widget detailsCardss({width, String? count, String? title, color,textColor,titlecolor}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      count!.text.fontFamily(bold).size(16).color(textColor).make(),
      5.heightBox,
      title!.text.color(titlecolor).make(),
    ],
  )
      .box
      .color(color)
      .rounded
      .height(80)
      .width(width)
      .padding(const EdgeInsets.all(4))
      .make();
}
