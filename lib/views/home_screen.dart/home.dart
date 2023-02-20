import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
//
import '../../consts/consts.dart';
import '../../controller/home_controller.dart';
import '../../widgets_common/exit_dialog.dart';
import '../cart_screen/cart_screen.dart';
import '../category_screen/category_screen.dart';
import '../profile_screen/profile_screen.dart';
import 'home_screen.dart';

class Homes extends StatefulWidget {
  const Homes({Key? key}) : super(key: key);

  @override
  State<Homes> createState() => _HomesState();
}

class _HomesState extends State<Homes> {
  /// for bottom nav start
  var controller = Get.put(HomeController());
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

  var navScreens = [
    const HomeScreens(),
    const CategoryScreens(),
    const CartScreens(),
    const ProfileScreens()
  ];

  @override
  Widget build(BuildContext context) {
    cartItemslength();
    DateTime backPressedTime = DateTime.now();
    var bottomNavbarItem = [
      BottomNavigationBarItem(
        icon: Image.asset(icHome, width: 26.0),
        label: home,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icCategories, width: 24.0),
        label: categories,
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
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
        label: cart,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icProfile, width: 24.0),
        label: account,
      ),
    ];
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => exitDialog(context));
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              currentIndex: controller.currentnavIndex.value,
              onTap: (index) {
                controller.currentnavIndex.value = index;
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: redColor,
              selectedLabelStyle: const TextStyle(fontFamily: semibold),
              unselectedItemColor: fontGrey,
              items: bottomNavbarItem,
            )),
        body: Column(
          children: [
            Obx(() => Expanded(
                  child: navScreens.elementAt(controller.currentnavIndex.value),
                )),

            /// for bottom nav end
          ],
        ),
      ),
    );
  }
}
