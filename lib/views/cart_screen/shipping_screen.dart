import 'package:get/get.dart';
//
import '../../consts/consts.dart';
import '../../controller/cart_controller.dart';
import '../../widgets_common/custom_textfield.dart';
import '../../widgets_common/our_button.dart';
import 'payment_method_Screen.dart';

class ShippingDetails extends StatelessWidget {
  ShippingDetails({Key? key}) : super(key: key);
  final shipingFormKey = GlobalKey<FormState>(); //key

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: isdarkMode ? Colors.transparent : Colors.transparent,
        title: "Shipping info"
            .text
            .fontFamily(semibold)
            .color(isdarkMode ? whiteColor : darkFontGrey)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: outButton(
          color: redColor,
          onPress: () {
            if (shipingFormKey.currentState!.validate()) {
              Get.to(() => const PaymentMethod());
            } else {
              VxToast.show(context, msg: "Please fill the form");
            }
          },
          textColor: whiteColor,
          title: "Continue",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: shipingFormKey,
          child: Column(
            children: [
              customTextField(
                  type: TextInputType.streetAddress,
                  controller: controller.addressController,
                  label: "Address",
                  hint: "Enter address",
                  fillcolor: isdarkMode ? fontGrey : lightGrey,
                  isPass: false,
                  title: "Address"),
              customTextField(
                  type: TextInputType.streetAddress,
                  controller: controller.cityController,
                  label: "City",
                  hint: "Enter City",
                  fillcolor: isdarkMode ? fontGrey : lightGrey,
                  isPass: false,
                  title: "City"),
              customTextField(
                  type: TextInputType.streetAddress,
                  controller: controller.stateController,
                  hint: "Enter State",
                  label: "State",
                  isPass: false,
                  fillcolor: isdarkMode ? fontGrey : lightGrey,
                  title: "State"),
              customTextField(
                  type: TextInputType.number,
                  controller: controller.postalcodeController,
                  hint: "Enter Postal Code",
                  label: "Postal Code",
                  fillcolor: isdarkMode ? fontGrey : lightGrey,
                  isPass: false),
              customTextField(
                  type: TextInputType.phone,
                  controller: controller.phoneController,
                  hint: "Enter Phone",
                  fillcolor: isdarkMode ? fontGrey : lightGrey,
                  label: "Phone",
                  isPass: false),
            ],
          ),
        ),
      ),
    );
  }
}
