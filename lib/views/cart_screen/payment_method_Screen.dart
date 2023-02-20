import 'package:get/get.dart';
//
import '../../consts/consts.dart';
import '../../controller/cart_controller.dart';
import '../../widgets_common/loading_indicator.dart';
import '../../widgets_common/our_button.dart';
import '../home_screen.dart/home.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;

    return Obx(
      () => Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor:
                isdarkMode ? Colors.transparent : Colors.transparent,
            title: "Choose Payment Method"
                .text
                .fontFamily(semibold)
                .color(isdarkMode ? whiteColor : darkFontGrey)
                .make(),
          ),
          bottomNavigationBar: SizedBox(
            height: 60,
            child: controller.placingorder.value
                ? loadingIndicator()
                : outButton(
                    color: redColor,
                    onPress: () async {
                      await controller.placeMyOrder(
                          orderPaymentMethod:
                              paymentMethods[controller.paymentIndex.value],
                          totalAmount: controller.totalP.value);
                      await controller.clearCart();
                      // ignore: use_build_context_synchronously
                      VxToast.show(context, msg: "Order placed successfully");

                      Get.offAll(const Homes());
                    },
                    textColor: whiteColor,
                    title: "Place my order",
                  ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Obx(
              () => Column(
                children: List.generate(paymentMethodimg.length, (index) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.asset(paymentMethodimg[index],
                          colorBlendMode: controller.paymentIndex.value == index
                              ? BlendMode.darken
                              : BlendMode.color,
                          color: controller.paymentIndex.value == index
                              ? Colors.black.withOpacity(0.4)
                              : Colors.transparent,
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover),
                      controller.paymentIndex.value == index
                          ? Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                  activeColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  value: true,
                                  onChanged: (value) {}),
                            )
                          : Container(),
                      Positioned(
                          bottom: 10,
                          right: 10,
                          child: paymentMethods[index]
                              .text
                              .fontFamily(semibold)
                              .white
                              .size(16)
                              .make()),
                    ],
                  )
                      .box
                      .margin(const EdgeInsets.only(bottom: 8))
                      .border(
                          color: controller.paymentIndex.value == index
                              ? redColor
                              : Colors.transparent,
                          width: 4)
                      .rounded
                      .clip(Clip.antiAlias)
                      .outerShadowSm
                      .make()
                      .onTap(() {
                    controller.changePaymentIndex(index);
                  });
                }),
              ),
            ),
          )),
    );
  }
}
