import 'package:qaswa_user/consts/consts.dart';

class FirestoreServices {
  static getUser(uid) {
    // create User data

    return firestore
        .collection(usersCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  // get products according to category

  static getCategoryProducts(category) {
    return firestore
        .collection(productsCollection)
        .where('p_category', isEqualTo: category)
        .snapshots();
  }

  // get products according to subcategory

  static gesubcategorytProducts(title) {
    return firestore
        .collection(productsCollection)
        .where('p_subcategory', isEqualTo: title)
        .snapshots();
  }

  // get cart

  static getcart(uid) {
    return firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: uid)
        .snapshots();
  }

  // delete cart

  static deleteDocument(docId) {
    return firestore.collection(cartCollection).doc(docId).delete();
  }

// Show meassge in profile your message page

  static getAllmessage() {
    return firestore
        .collection(chatsCollection)
        .where('fromId', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  // get all chat messages

  static getChatMessages(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messageCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  // Show orders in profile your order page

  static getAllOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  // Show wishlist in profile your whishlist page

  static getAllWshlist() {
    return firestore
        .collection(productsCollection)
        .where('p_wishlist', arrayContains: currentUser!.uid)
        .snapshots();
  }
  // get All products at home Page

  static homeallproducts() {
    return firestore.collection(productsCollection).snapshots();
  }

  // get featured product method

  static getfeaturedproducts() {
    return firestore
        .collection(productsCollection)
        .where('is_featured', isEqualTo: true)
        .get();
  }

  // search method

  static searchProducts(title) {
    return firestore.collection(productsCollection).get();
  }

  static getPopularProducts(uid) {
    return firestore
        .collection(productsCollection)
        .where("vaendor_id", isEqualTo: uid)
        .orderBy('p_wishlist'.length);
  }
}
