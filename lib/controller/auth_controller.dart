import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qaswa_user/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
//

class AuthController extends GetxController {
  var isLoading = false.obs;

  // text Controller for login
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Login method
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  // SignIn method

  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  // storing data method in firebase

  storeUserData({name, password, email}) async {
    DocumentReference store =
        firestore.collection(usersCollection).doc(currentUser!.uid);
    store.set(
      {
        'id': currentUser!.uid,
        'name': name,
        'password': password,
        'email': email,
        'imageUrl': '',
        'cart_count': "00",
        'order_count': "00",
        'wishlist_count': "00",
      },
    );
  }

  clearfield() {
    emailController.clear();
    passwordController.clear();
  }

  // SignOut method

  Future signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
