import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qaswa_user/consts/consts.dart';
import 'package:qaswa_user/controller/home_controller.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var totalP = 0.obs;

  // text controller for shipping details

  var addressController = TextEditingController();
  var stateController = TextEditingController();
  var cityController = TextEditingController();
  var postalcodeController = TextEditingController();
  var phoneController = TextEditingController();

  // select payment check
  var paymentIndex = 0.obs;

  // this variable for orderplace
  late dynamic productSnapshot;
  var products = [];
  var placingorder = false.obs;
  var vendor = [];

  calculate(data) {
    totalP.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  // change payment method
  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  // place order
  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {
    placingorder(true);
    await getProductDetails();
    await firestore.collection(ordersCollection).doc().set({
      'order_code': 233981237,
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text.trim(),
      'order_by_state': stateController.text.trim(),
      'order_by_city': cityController.text.trim(),
      'order_by_postalcode': postalcodeController.text.trim(),
      'order_by_phone': phoneController.text.trim(),
      'shipping_method': "Home Delivery",
      'payment_method': orderPaymentMethod,
      'order_place': true,
      'order_confirm': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products),
      'vaendor_id': FieldValue.arrayUnion(vendor),
    });
    placingorder(false);
  }

  //get product from cart adn add in product list of order place

  getProductDetails() {
    products.clear();
    vendor.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'img': productSnapshot[i]['img'],
        'vaendor_id': productSnapshot[i]['vaendor_id'],
        'tprice': productSnapshot[i]['tprice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title'],
      });
      vendor.add(productSnapshot[i]['vaendor_id']);
    }
  }

  // clear cart after placing orders

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }
}
