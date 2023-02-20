import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
//
import '../../consts/consts.dart';
import '../../services/firebase_services.dart';
import '../../widgets_common/loading_indicator.dart';
import '../category_screen/items_details.dart';

class SearchScreen extends StatelessWidget {
  final String? title;
  const SearchScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: isdarkMode ? Colors.transparent : Colors.transparent,
        title: title!.text.color(isdarkMode ? whiteColor : darkFontGrey).make(),
      ),
      body: FutureBuilder(
          future: FirestoreServices.searchProducts(title),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicator();
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "No products found"
                    .text
                    .color(isdarkMode ? whiteColor : darkFontGrey)
                    .make(),
              );
            } else {
              var searchData = snapshot.data!.docs;
              var filtered = searchData
                  .where((element) => element['p_name']
                      .toString()
                      .toLowerCase()
                      .contains(title!.toLowerCase()))
                  .toList();

              return GridView(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 250),
                children: filtered
                    .mapIndexed(
                      (currentValue, index) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => loadingIndicator(),
                              imageUrl: filtered[index]['p_imgs'][0],
                              width: double.infinity,
                              height: 170,
                              fit: BoxFit.cover,
                            ),
                          ),
                          10.heightBox,
                          "${filtered[index]['p_name']}"
                              .text
                              .fontFamily(semibold)
                              .color(isdarkMode ? whiteColor : darkFontGrey)
                              .make(),
                          10.heightBox,
                          "${filtered[index]['p_price']}"
                              .text
                              .fontFamily(bold)
                              .size(12)
                              .color(isdarkMode ? whiteColor : redColor)
                              .make(),
                          10.heightBox,
                        ],
                      )
                          .box
                          .color(isdarkMode ? fontGrey : whiteColor)
                          .shadow
                          .roundedSM
                          .make()
                          .onTap(() {
                        Get.to(() => ItemsDetailsScreen(
                            title: "${filtered[index]['p_name']}",
                            data: filtered[index]));
                      }),
                    )
                    .toList(),
              );
            }
          }),
    );
  }
}
