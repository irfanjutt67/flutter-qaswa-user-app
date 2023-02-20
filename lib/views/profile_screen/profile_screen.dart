import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
//
import '../../consts/consts.dart';
import '../../controller/auth_controller.dart';
import '../../controller/profile_controller.dart';
import '../../services/firebase_services.dart';
import '../../widgets_common/bg_widget.dart';
import '../../widgets_common/loading_indicator.dart';
import '../chat_screen/message_screen.dart';
import '../order_screen/order_Screen.dart';
import '../splash_screen/animated_onboarding.dart';
import '../wishlistlist_screen/wishlist_screen.dart';
import 'components/details_cardss.dart';
import 'edit_profile.dart';

class ProfileScreens extends StatefulWidget {
  const ProfileScreens({Key? key}) : super(key: key);

  @override
  State<ProfileScreens> createState() => _ProfileScreensState();
}

class _ProfileScreensState extends State<ProfileScreens> {
  var controller = Get.put(ProfileController());
  var wishlength, cartlengths, orderlength = 0;

  final _themeData = GetStorage();
  @override
  void initState() {
    super.initState();
    _themeData.writeIfNull("darkmode", false);
  }

  @override
  Widget build(BuildContext context) {
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;
    wishItemlengths();
    cartItemlength();
    orderItemlength();
    // FirestoreServices.getCounts();
    return secondbgWidget(
      child: Scaffold(
        backgroundColor: isdarkMode ? darkColor : Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: isdarkMode ? Colors.transparent : Colors.transparent,
          automaticallyImplyLeading: false,
          title: "Settings".text.fontFamily(semibold).color(whiteColor).make(),
          actions: [
            TextButton(
                onPressed: () async {
                  await Get.put(AuthController()).signoutMethod(context);
                  Get.offAll(() => const AnimatedOnboard());
                },
                child:
                    logout.text.fontFamily(semibold).color(whiteColor).make())
          ],
        ),
        body: StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicator();
            } else {
              var data = snapshot.data!.docs[0];

              return SafeArea(
                child: Column(
                  children: [
                    //user detail section
                    ListTile(
                      leading: FadeInDown(
                          delay: const Duration(milliseconds: 500),
                          animate: true,
                          child: Hero(
                            tag: data['imageUrl'],
                            child: data['imageUrl'] == ''
                                ? Image.asset(icProfile,
                                        width: 100, fit: BoxFit.fill)
                                    .box
                                    .roundedFull
                                    .clip(Clip.antiAlias)
                                    .make()
                                : CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        loadingIndicator(),
                                    imageUrl: "${data['imageUrl']}",
                                    width: 100,
                                  ).box.roundedFull.clip(Clip.antiAlias).make(),
                          )),
                      title: "${data['name']}"
                          .text
                          .color(whiteColor)
                          .fontFamily(semibold)
                          .make(),
                      subtitle:
                          "${data['email']}".text.color(whiteColor).make(),
                      trailing:
                          const Icon(Icons.edit, color: whiteColor).onTap(() {
                        controller.nameController.text = data['name'];
                        Get.to(() => EditProfileScreens(data: data));
                      }),
                    ),
                    10.heightBox,
                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      animate: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          detailsCardss(
                              count: "$wishlength".toString(),
                              title: "your wishlist",
                              width: context.screenWidth / 3.4,
                              color: isdarkMode ? fontGrey : whiteColor,
                              textColor: isdarkMode ? whiteColor : darkFontGrey,
                              titlecolor:
                                  isdarkMode ? whiteColor : darkFontGrey),
                          detailsCardss(
                              count: "$cartlengths".toString(),
                              title: "your cart",
                              width: context.screenWidth / 3.4,
                              color: isdarkMode ? fontGrey : whiteColor,
                              textColor: isdarkMode ? whiteColor : darkFontGrey,
                              titlecolor:
                                  isdarkMode ? whiteColor : darkFontGrey),
                          detailsCardss(
                              count: "$orderlength".toString(),
                              title: "your order",
                              width: context.screenWidth / 3.4,
                              color: isdarkMode ? fontGrey : whiteColor,
                              textColor: isdarkMode ? whiteColor : darkFontGrey,
                              titlecolor:
                                  isdarkMode ? whiteColor : darkFontGrey),
                        ],
                      ),
                    ),
                    10.heightBox,
                    SwitchListTile(
                      secondary: const Icon(Icons.ac_unit),
                      title: const Text(
                        "Theme",
                      ),
                      value: isdarkMode,
                      onChanged: (value) {
                        setState(() {
                          isdarkMode = value;
                        });
                        isdarkMode
                            ? Get.changeTheme(ThemeData.dark())
                            : Get.changeTheme(ThemeData.light());
                        _themeData.write('darkmode', value);
                      },
                      activeThumbImage: const AssetImage(icMoon),
                      inactiveThumbImage: const AssetImage(icSun),
                      activeColor: Colors.blue,
                      inactiveTrackColor: Colors.grey,
                    ),
                    10.heightBox,
                    // button section
                    ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return const Divider(
                                color: lightGrey,
                              );
                            },
                            itemCount: profileButtonList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return FadeInUp(
                                delay: const Duration(milliseconds: 500),
                                animate: true,
                                child: ListTile(
                                  onTap: () {
                                    switch (index) {
                                      case 0:
                                        Get.to(() => const WishlistScreen());
                                        break;
                                      case 1:
                                        Get.to(() => const OrderScreen());
                                        break;
                                      case 2:
                                        Get.to(() => const MessagesScreen());
                                        break;
                                    }
                                  },
                                  leading: Image.asset(
                                      profileButtonListicons[index],
                                      color: isdarkMode ? whiteColor : fontGrey,
                                      width: 22),
                                  title: profileButtonList[index]
                                      .text
                                      .fontFamily(bold)
                                      .color(isdarkMode
                                          ? whiteColor
                                          : darkFontGrey)
                                      .make(),
                                ),
                              );
                            })
                        .box
                        .color(isdarkMode ? darkFontGrey : whiteColor)
                        .margin(const EdgeInsets.all(12))
                        .border(color: isdarkMode ? whiteColor : whiteColor)
                        .rounded
                        .shadowSm
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .make()
                        .box
                        .color(isdarkMode
                            ? darkFontGrey
                            : Colors.lightBlue.shade50)
                        .make(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void wishItemlengths() {
    firestore
        .collection(productsCollection)
        .where('p_wishlist', arrayContains: currentUser!.uid)
        .get()
        .then((snap) {
      if (snap.docs.isNotEmpty) {
        setState(() {
          wishlength = snap.docs.length;
        });
      } else {
        setState(() {
          wishlength = 0;
        });
      }
    });
  }

  void cartItemlength() {
    firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: currentUser!.uid)
        .get()
        .then((snap) {
      if (snap.docs.isNotEmpty) {
        setState(() {
          cartlengths = snap.docs.length;
        });
      } else {
        setState(() {
          cartlengths = 0;
        });
      }
    });
  }

  void orderItemlength() {
    firestore
        .collection(ordersCollection)
        .where('order_by', isEqualTo: currentUser!.uid)
        .get()
        .then((snap) {
      if (snap.docs.isNotEmpty) {
        setState(() {
          orderlength = snap.docs.length;
        });
      } else {
        setState(() {
          orderlength = 0;
        });
      }
    });
  }
}
