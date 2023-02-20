import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
//
import '../../consts/consts.dart';
import '../../controller/cart_controller.dart';
import '../../controller/product_controller.dart';
import '../../services/firebase_services.dart';
import '../../widgets_common/loading_indicator.dart';
import '../../widgets_common/our_button.dart';
import 'shipping_screen.dart';

class CartScreens extends StatefulWidget {
  const CartScreens({Key? key}) : super(key: key);

  @override
  State<CartScreens> createState() => _CartScreensState();
}

class _CartScreensState extends State<CartScreens> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    var controllers = Get.put(ProductController());
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: isdarkMode ? Colors.transparent : Colors.transparent,
          // this function automaticallyImplyLeading for able and disable back button
          automaticallyImplyLeading: false,
          title: "Shopping cart"
              .text
              .color(
                isdarkMode ? whiteColor : Colors.black,
              )
              .fontFamily(semibold)
              .make(),
        ),
        body: StreamBuilder(
            stream: FirestoreServices.getcart(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return loadingIndicator();
              } else if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: "Cart is empty"
                      .text
                      .color(
                        isdarkMode ? whiteColor : fontGrey,
                      )
                      .make(),
                );
              } else {
                var data = snapshot.data!.docs;
                controller.calculate(data);
                controller.productSnapshot = data;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(4),
                              child: ListTile(
                                iconColor: isdarkMode ? whiteColor : redColor,
                                tileColor:
                                    isdarkMode ? fontGrey : Colors.transparent,
                                leading: Image.network(
                                  '${data[index]['img']}',
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                                title:
                                    "${data[index]['title']} (x${data[index]['qty']})"
                                        .text
                                        .color(
                                          isdarkMode
                                              ? whiteColor
                                              : Colors.black,
                                        )
                                        .fontFamily(semibold)
                                        .size(16)
                                        .make(),
                                subtitle: "${data[index]['tprice']}"
                                    .numCurrency
                                    .text
                                    .color(
                                      isdarkMode ? whiteColor : redColor,
                                    )
                                    .fontFamily(semibold)
                                    .make(),
                                trailing: const Icon(
                                  Icons.delete,
                                ).onTap(() {
                                  FirestoreServices.deleteDocument(
                                      data[index].id);
                                  controllers.removeItemInCart(cartCollection);
                                }),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Total Price"
                              .text
                              .fontFamily(semibold)
                              .color(
                                isdarkMode ? whiteColor : Colors.black,
                              )
                              .make(),
                          Obx(
                            () => "${controller.totalP.value}"
                                .numCurrency
                                .text
                                .fontFamily(semibold)
                                .color(isdarkMode ? whiteColor : Colors.black)
                                .make(),
                          ),
                        ],
                      )
                          .box
                          .padding(const EdgeInsets.all(12))
                          .width(context.screenWidth - 60)
                          .color(isdarkMode ? fontGrey : lightGrey)
                          .roundedSM
                          .make(),
                      10.heightBox,
                      outButton(
                        color: redColor,
                        onPress: () {
                          Get.to(() => ShippingDetails());
                        },
                        textColor: whiteColor,
                        title: "Proceeed to shiping",
                      ).box.width(double.infinity).height(60).make(),
                    ],
                  ),
                );
              }
            }));
  }
}
