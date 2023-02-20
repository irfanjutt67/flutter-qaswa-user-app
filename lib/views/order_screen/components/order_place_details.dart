import '../../../consts/consts.dart';

Widget orderPlaceDetails({title1, title2, d1, d2, d1color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "$title1".text.fontFamily(semibold).color(darkFontGrey).make(),
            "$d1".text.color(d1color).fontFamily(semibold).make(),
          ],
        ),
        SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "$title2".text.fontFamily(semibold).color(darkFontGrey).make(),
              "$d2".text.color(d1color).fontFamily(semibold).make(),
            ],
          ),
        )
      ],
    ),
  );
}
