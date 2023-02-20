import 'package:qaswa_user/consts/consts.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    getUsername();
    super.onInit();
  }

  // for bottom nav start
  var currentnavIndex = 0.obs;

  // for bottom nav end

  // for bottom nav start
  var searchController = TextEditingController();

  // for bottom nav end

  // for user chat start

  var username = '';

  getUsername() async {
    var n = await firestore
        .collection(usersCollection)
        .where('id', isEqualTo: currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.single['name'];
      }
    });
    username = n;
  }

  // for user chat end
}
