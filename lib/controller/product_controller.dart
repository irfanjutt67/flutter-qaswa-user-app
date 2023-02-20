import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qaswa_user/consts/consts.dart';
import 'package:qaswa_user/model/category_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  var quantity = 0.obs;
  var colorIndex = 0.obs;
  var totalPrice = 0.obs;

  var subcat = [];

  var isFav = false.obs;

  List cartItems = [].obs;
  var totalQty = 0.obs;
  var numofitem = 1.obs;

  void addItemInCart(cartCollection) {
    cartItems.add(cartCollection);
    totalQty.value = totalQty.value + numofitem.value;
    numofitem.value = 1;
  }

  void removeItemInCart(cartCollection) {
    cartItems.remove(cartCollection);
    totalQty.value = totalQty.value - quantity.value;
  }

  getSubCategories(title) async {
    subcat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decoded = categoryModelFromJson(data);

    var s =
        decoded.categories.where((element) => element.name == title).toList();

    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

  increaseQuantity(totalQuantity) {
    if (quantity.value < totalQuantity) {
      quantity.value++;
    }
  }

  decreaseQuantity() {
    if (quantity > 0) {
      quantity.value--;
    }
  }

  calculateTotalPrice(price) {
    totalPrice.value = price * quantity.value;
  }

  addToCart({title, img, sellername, qty, tprice, vendorID, context}) async {
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'img': img,
      'sellername': sellername,
      'qty': qty,
      'vaendor_id': vendorID,
      'tprice': tprice,
      'added_by': currentUser!.uid,
    }).catchError((error) {
      VxToast.show(context, msg: error.toString());
    });
  }

  // reset values like qunatity, totalPrice and colors
  resetValues() {
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

  // add to wicsh list

  addToWishList(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: 'Added to wishlist');
  }

  removeFromWishList(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: 'Remove to wishlist');
  }

  // check if item is fav

  checkIffav(data) async {
    if (data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }
}
