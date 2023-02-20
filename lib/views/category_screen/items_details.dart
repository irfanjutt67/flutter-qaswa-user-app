import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
//
import '../../consts/consts.dart';
import '../../controller/product_controller.dart';
import '../../widgets_common/loading_indicator.dart';
import '../../widgets_common/our_button.dart';
import '../cart_screen/cart_screen.dart';
import '../chat_screen/chat_screen.dart';

class ItemsDetailsScreen extends StatefulWidget {
  final String? title;
  final dynamic data;
  const ItemsDetailsScreen({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  State<ItemsDetailsScreen> createState() => _ItemsDetailsScreenState();
}

class _ItemsDetailsScreenState extends State<ItemsDetailsScreen> {
  var controller = Get.put(ProductController());

  var lengths = 0;
  void cartItemslength() {
    firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: currentUser!.uid)
        .get()
        .then((snap) {
      if (snap.docs.isNotEmpty) {
        setState(() {
          lengths = snap.docs.length;
        });
      } else {
        setState(() {
          lengths = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;
    cartItemslength();

    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: isdarkMode ? Colors.transparent : Colors.transparent,
          leading: IconButton(
              color: (isdarkMode ? whiteColor : darkFontGrey),
              onPressed: () {
                controller.resetValues();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back)),
          title: widget.title!.text
              .color(isdarkMode ? whiteColor : darkFontGrey)
              .fontFamily(bold)
              .make(),
          actions: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: badges.Badge(
                badgeAnimation: const badges.BadgeAnimation.slide(
                  animationDuration: Duration(seconds: 1),
                  colorChangeAnimationDuration: Duration(seconds: 1),
                  loopAnimation: false,
                  curve: Curves.fastOutSlowIn,
                  colorChangeAnimationCurve: Curves.easeInCubic,
                ),
                badgeContent: "$lengths".text.white.make(),
                child: Image.asset(icCart, width: 24.0).onTap(() {
                  Get.to(() => const CartScreens());
                }),
              ),
            ),
            Obx(
              () => IconButton(
                  onPressed: () {
                    if (controller.isFav.value) {
                      controller.removeFromWishList(widget.data.id, context);
                    } else {
                      controller.addToWishList(widget.data.id, context);
                    }
                  },
                  icon: Icon(Icons.favorite_outlined,
                      color: controller.isFav.value ? redColor : fontGrey)),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // swiper section

                      VxSwiper.builder(
                          autoPlay: true,
                          height: 350,
                          aspectRatio: 16 / 9,

                          // for show next and previous img
                          // viewportFraction: 0.8,

                          // for show full img
                          viewportFraction: 1.0,
                          itemCount: widget.data['p_imgs'].length,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              placeholder: (context, url) => loadingIndicator(),
                              imageUrl: widget.data["p_imgs"][index],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          }),
                      10.heightBox,

                      //title and details section

                      Row(
                        children: [
                          "Name: "
                              .text
                              .fontFamily(bold)
                              .color(isdarkMode ? whiteColor : darkFontGrey)
                              .size(16)
                              .make(),
                          widget.title!.text
                              .size(16)
                              .color(isdarkMode ? whiteColor : darkFontGrey)
                              .fontFamily(semibold)
                              .make(),
                        ],
                      ),
                      10.heightBox,

                      // rating

                      VxRating(
                        value: double.parse(widget.data['p_rating']),
                        onRatingUpdate: (value) {},
                        normalColor: textfieldGrey,
                        selectionColor: golden,
                        size: 25,
                        isSelectable: false,
                        count: 5,
                        maxRating: 5,
                      ),
                      10.heightBox,
                      Row(
                        children: [
                          "Rs: "
                              .text
                              .fontFamily(bold)
                              .color(isdarkMode ? whiteColor : darkFontGrey)
                              .size(16)
                              .make(),
                          "${widget.data['p_price']}"
                              .numCurrency
                              .text
                              .color(isdarkMode ? whiteColor : redColor)
                              .fontFamily(bold)
                              .size(16)
                              .make(),
                        ],
                      ),
                      10.heightBox,
                      Row(
                        children: [
                          "Brand: "
                              .text
                              .fontFamily(bold)
                              .color(isdarkMode ? whiteColor : darkFontGrey)
                              .size(16)
                              .make(),
                          "${widget.data['p_brand']}"
                              .text
                              .color(isdarkMode ? whiteColor : darkFontGrey)
                              .fontFamily(bold)
                              .size(16)
                              .make(),
                        ],
                      ),
                      10.heightBox,
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Seller".text.white.fontFamily(semibold).make(),
                                5.heightBox,
                                "${widget.data['p_seller']}"
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                              ],
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.message_rounded, color: fontGrey),
                          ).onTap(() {
                            Get.to(() => const ChatScreen(), arguments: [
                              widget.data['p_seller'],
                              widget.data['vaendor_id']
                            ]);
                          })
                        ],
                      )
                          .box
                          .height(60)
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .color(isdarkMode ? fontGrey : textfieldGrey)
                          .make(),

                      //color section
                      20.heightBox,
                      Obx(
                        () => Column(
                          children: [
                            //quantity section
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Quantity: "
                                      .text
                                      .color(textfieldGrey)
                                      .make(),
                                ),
                                Obx(
                                  () => Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            controller.decreaseQuantity();
                                            if (controller.quantity.value > 3) {
                                              controller.calculateTotalPrice(
                                                  int.parse(widget.data[
                                                      'p_discountprice']));
                                            } else {
                                              controller.calculateTotalPrice(
                                                  int.parse(
                                                      widget.data['p_price']));
                                            }
                                          },
                                          icon: const Icon(Icons.remove)),
                                      controller.quantity.value.text
                                          .size(16)
                                          .color(isdarkMode
                                              ? whiteColor
                                              : darkFontGrey)
                                          .fontFamily(bold)
                                          .make(),
                                      IconButton(
                                          onPressed: () {
                                            controller.increaseQuantity(
                                              int.parse(
                                                  widget.data['p_quantity']),
                                            );
                                            if (controller.quantity.value > 3) {
                                              controller.calculateTotalPrice(
                                                  int.parse(widget.data[
                                                      'p_discountprice']));
                                            } else {
                                              controller.calculateTotalPrice(
                                                  int.parse(
                                                      widget.data['p_price']));
                                            }
                                          },
                                          icon: const Icon(Icons.add)),
                                      10.widthBox,
                                      "(${widget.data['p_quantity']} available)"
                                          .text
                                          .color(textfieldGrey)
                                          .make(),
                                    ],
                                  ),
                                ),
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  "NOTE: Discount of ${widget.data['p_discountprice']} PKR will be applied when you order more than Three items of the this product"
                                      .text
                                      .make(),
                            ),
                            10.heightBox,
                            //Total section
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Total: "
                                      .text
                                      .color(textfieldGrey)
                                      .make(),
                                ),
                                "${controller.totalPrice.value}"
                                    .numCurrency
                                    .text
                                    .color(isdarkMode ? whiteColor : redColor)
                                    .size(16)
                                    .fontFamily(bold)
                                    .make(),
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),
                          ],
                        )
                            .box
                            .color(isdarkMode ? fontGrey : whiteColor)
                            .shadowSm
                            .make(),
                      ),

                      // description section
                      10.heightBox,

                      "Description"
                          .text
                          .color(isdarkMode ? whiteColor : darkFontGrey)
                          .size(16)
                          .fontFamily(semibold)
                          .make(),
                      10.heightBox,
                      "${widget.data['p_desc']}"
                          .text
                          .color(isdarkMode ? whiteColor : darkFontGrey)
                          .make(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: outButton(
                color: redColor,
                onPress: () {
                  controller.addItemInCart(cartCollection);
                  // controller.addnotification("Notification");
                  if (controller.quantity.value > 0) {
                    controller.addToCart(
                      context: context,
                      vendorID: widget.data['vaendor_id'],
                      img: widget.data['p_imgs'][0],
                      qty: controller.quantity.value,
                      sellername: widget.data['p_seller'],
                      title: widget.data['p_name'],
                      tprice: controller.totalPrice.value,
                    );
                    VxToast.show(context, msg: "Added to cart");
                  } else {
                    VxToast.show(context, msg: "Minimum 1 product is required");
                  }
                },
                textColor: whiteColor,
                title: "Add to cart",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
