import '../../consts/consts.dart';
import '../../controller/product_controller.dart';
import '../../widgets_common/bg_widget.dart';
import 'categories_details.dart';
import 'package:get/get.dart';

class CategoryScreens extends StatelessWidget {
  const CategoryScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;

    return secondbgWidget(
      child: Scaffold(
        backgroundColor: isdarkMode ? darkColor : Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: isdarkMode ? Colors.transparent : Colors.transparent,
          title: categories.text.fontFamily(bold).white.make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 8,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 200),
              itemBuilder: (context, index) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                categoriesImages[index],
                              ),
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                  const Color.fromARGB(255, 24, 20, 20)
                                      .withOpacity(0.4),
                                  BlendMode.darken))),
                    ),
                    10.heightBox,
                    categoriesList[index].text.semiBold.color(whiteColor).make()
                  ],
                )
                    .box
                    .white
                    .rounded
                    .clip(Clip.antiAlias)
                    .shadow
                    .make()
                    .onTap(() {
                  controller.getSubCategories(categoriesList[index]);
                  Get.to(
                    () => CategoriesDetails(title: categoriesList[index]),
                  );
                });
              }),
        ),
      ),
    );
  }
}
