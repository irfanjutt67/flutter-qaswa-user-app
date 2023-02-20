import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
//
import '../../consts/consts.dart';
import '../../widgets_common/bg_widget.dart';
import '../../widgets_common/loading_indicator.dart';
import '../../controller/product_controller.dart';
import '../../services/firebase_services.dart';
import 'items_details.dart';

class CategoriesDetails extends StatefulWidget {
  final String? title;
  const CategoriesDetails({Key? key, required this.title}) : super(key: key);

  @override
  State<CategoriesDetails> createState() => _CategoriesDetailsState();
}

class _CategoriesDetailsState extends State<CategoriesDetails> {
  @override
  void initState() {
    switchCategory(widget.title);
    super.initState();
  }

  switchCategory(title) {
    if (controller.subcat.contains(title)) {
      productsMethod = FirestoreServices.gesubcategorytProducts(title);
    } else {
      productsMethod = FirestoreServices.getCategoryProducts(title);
    }
  }

  var controller = Get.put(ProductController());
  dynamic productsMethod;

  @override
  Widget build(BuildContext context) {
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;
    return secondbgWidget(
      child: Scaffold(
          backgroundColor: isdarkMode ? darkColor : Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor:
                isdarkMode ? Colors.transparent : Colors.transparent,
            title: widget.title!.text.fontFamily(bold).white.make(),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                      controller.subcat.length,
                      (index) => "${controller.subcat[index]}"
                              .text
                              .fontFamily(semibold)
                              .color((isdarkMode ? whiteColor : darkFontGrey))
                              .makeCentered()
                              .box
                              .color((isdarkMode ? fontGrey : whiteColor))
                              .size(120, 40)
                              .rounded
                              .margin(const EdgeInsets.symmetric(horizontal: 4))
                              .make()
                              .onTap(() {
                            switchCategory("${controller.subcat[index]}");
                            setState(() {});
                          })),
                ),
              ),
              20.heightBox,
              StreamBuilder(
                stream: productsMethod,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return loadingIndicator();
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: "No products found!"
                            .text
                            .color((isdarkMode ? whiteColor : darkFontGrey))
                            .makeCentered(),
                      ),
                    );
                  } else {
                    var data = snapshot.data!.docs;
                    // items Container
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  mainAxisExtent: 250),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        loadingIndicator(),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    imageUrl: "${data[index]['p_imgs'][0]}",
                                    width: double.infinity,
                                    height: 170,
                                    fit: BoxFit.cover,
                                    fadeOutDuration: const Duration(seconds: 1),
                                    fadeInDuration: const Duration(seconds: 3),
                                  ),
                                ),
                                10.heightBox,
                                "${data[index]['p_name']}"
                                    .text
                                    .fontFamily(semibold)
                                    .color((isdarkMode
                                        ? whiteColor
                                        : darkFontGrey))
                                    .make(),
                                10.heightBox,
                                "${data[index]['p_price']}"
                                    .numCurrency
                                    // for shoe crruncy start
                                    // .numCurrencyWithLocale()
                                    // for shoe crruncy End
                                    .text
                                    .fontFamily(bold)
                                    .size(12)
                                    .color((isdarkMode ? whiteColor : redColor))
                                    .make(),
                                10.heightBox,
                              ],
                            )
                                .box
                                .color((isdarkMode ? fontGrey : whiteColor))
                                .shadow
                                .roundedSM
                                .make()
                                .onTap(() {
                              controller.checkIffav(data[index]);
                              Get.to(
                                () => ItemsDetailsScreen(
                                  title: "${data[index]['p_name']}",

                                  //for data forword to next screen
                                  data: data[index],
                                ),
                              );
                            });
                          }),
                    );
                  }
                },
              ),
            ],
          )),
    );
  }
}
