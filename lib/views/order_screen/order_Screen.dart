import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
//
import '../../consts/consts.dart';
import '../../services/firebase_services.dart';
import '../../widgets_common/loading_indicator.dart';
import 'order_detail_screen.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: isdarkMode ? Colors.transparent : Colors.transparent,
        title: "My Orders"
            .text
            .color(isdarkMode ? whiteColor : darkFontGrey)
            .fontFamily(semibold)
            .make(),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getAllOrders(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicator();
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "No orders yet!".text.color(darkFontGrey).make(),
              );
            } else {
              var data = snapshot.data!.docs;

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      Get.to(() => OrderDetails(data: data[index]));
                    },
                    leading: "${index + 1}"
                        .text
                        .fontFamily(bold)
                        .color(isdarkMode ? whiteColor : darkFontGrey)
                        .xl
                        .make(),
                    title: data[index]['order_code']
                        .toString()
                        .text
                        .color(isdarkMode ? whiteColor : redColor)
                        .fontFamily(semibold)
                        .make(),
                    subtitle: data[index]['total_amount']
                        .toString()
                        .numCurrency
                        .text
                        .color(isdarkMode ? whiteColor : fontGrey)
                        .fontFamily(bold)
                        .make(),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  );
                },
              );
            }
          }),
    );
  }
}
