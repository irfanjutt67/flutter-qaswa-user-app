import 'package:get/get.dart';
//
import '../../../consts/consts.dart';
import '../../category_screen/categories_details.dart';

Widget featuredButtons({
  String? title,
  icon,
}) {
  return Column(
    children: [
      Image.asset(icon, width: 60, fit: BoxFit.fill)
          .box
          .border(width: 1, color: redColor)
          .make(),
      5.heightBox,
      title!.text.fontFamily(semibold).color(fontGrey).make(),
    ],
  ).box.make().onTap(() {
    Get.to(() => CategoriesDetails(
          title: title,
        ));
  });
}
