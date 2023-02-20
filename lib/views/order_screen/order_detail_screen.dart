// ignore_for_file: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;
//
import '../../consts/consts.dart';
import 'components/order_place_details.dart';
import 'components/order_status.dart';

class OrderDetails extends StatelessWidget {
  final dynamic data;
  const OrderDetails({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: isdarkMode ? Colors.transparent : Colors.transparent,
        title: "Order Details"
            .text
            .color(isdarkMode ? whiteColor : darkFontGrey)
            .fontFamily(semibold)
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              orderStatus(
                  color: redColor,
                  icon: Icons.done,
                  title: "place",
                  showDone: data['order_place'],
                  textColor: isdarkMode ? whiteColor : darkFontGrey),
              orderStatus(
                  color: Colors.blue,
                  icon: Icons.thumb_up,
                  title: "Confirmed",
                  showDone: data['order_confirm'],
                  textColor: isdarkMode ? whiteColor : darkFontGrey),
              orderStatus(
                  color: Colors.yellow,
                  icon: Icons.directions_car,
                  title: "On Delivery",
                  showDone: data['order_on_delivery'],
                  textColor: isdarkMode ? whiteColor : darkFontGrey),
              orderStatus(
                  color: Colors.purple,
                  icon: Icons.done_all_rounded,
                  title: "Delivered",
                  showDone: data['order_delivered'],
                  textColor: isdarkMode ? whiteColor : darkFontGrey),
              const Divider(),
              10.heightBox,
              Column(
                children: [
                  orderPlaceDetails(
                      d1: data['order_code'],
                      d2: data['shipping_method'],
                      title1: "Order Code",
                      title2: "Shipping Method",
                      d1color: isdarkMode ? whiteColor : redColor),
                  orderPlaceDetails(
                    d1: intl.DateFormat()
                        .add_yMd()
                        .format((data['order_date'].toDate())),
                    d2: data['payment_method'],
                    d1color: isdarkMode ? whiteColor : redColor,
                    title1: "Order Date",
                    title2: "Payment Method",
                  ),
                  orderPlaceDetails(
                      d1: "Unpaid",
                      d2: "Order Placed",
                      title1: "Payment Status",
                      title2: "Delivery Status",
                      d1color: isdarkMode ? whiteColor : redColor),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Shipping Address".text.fontFamily(semibold).make(),
                            "${data['order_by_name']}".text.make(),
                            "${data['order_by_email']}".text.make(),
                            "${data['order_by_address']}".text.make(),
                            "${data['order_by_city']}".text.make(),
                            "${data['order_by_state']}".text.make(),
                            "${data['order_by_postalcode']}".text.make(),
                            "${data['order_by_phone']}".text.make(),
                          ],
                        ),
                        SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              "Total Amount".text.fontFamily(semibold).make(),
                              10.heightBox,
                              "${data['total_amount']}"
                                  .text
                                  .size(16)
                                  .fontFamily(bold)
                                  .make(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
                  .box
                  .color(isdarkMode ? fontGrey : whiteColor)
                  .outerShadowMd
                  .make(),
              const Divider(),
              "Ordered Products"
                  .text
                  .size(16)
                  .fontFamily(semibold)
                  .color(isdarkMode ? whiteColor : darkFontGrey)
                  .makeCentered(),
              10.heightBox,
              ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(data['orders'].length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderPlaceDetails(
                          title1: data['orders'][index]['title'],
                          title2: data['orders'][index]['tprice'],
                          d1: "${data['orders'][index]['qty']}x",
                          d2: "Refundable",
                          d1color: isdarkMode ? whiteColor : redColor),
                      const Divider(),
                    ],
                  );
                }).toList(),
              )
                  .box
                  .outerShadowMd
                  .margin(const EdgeInsets.only(bottom: 4))
                  .color(isdarkMode ? fontGrey : whiteColor)
                  .make(),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
