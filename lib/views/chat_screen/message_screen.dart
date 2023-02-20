import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
//
import '../../consts/consts.dart';
import '../../services/firebase_services.dart';
import '../../widgets_common/loading_indicator.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: isdarkMode ? Colors.transparent : Colors.transparent,
        title: "My Messages"
            .text
            .color(isdarkMode ? whiteColor : darkFontGrey)
            .fontFamily(semibold)
            .make(),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getAllmessage(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicator();
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "No message yet!"
                    .text
                    .color(isdarkMode ? whiteColor : darkFontGrey)
                    .make(),
              );
            } else {
              var data = snapshot.data!.docs;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext contex, int index) {
                          return ListTile(
                            onTap: () {
                              Get.to(() => const ChatScreen(), arguments: [
                                data[index]['friend_name'],
                                data[index]['toId'],
                              ]);
                            },
                            leading: const CircleAvatar(
                              backgroundColor: redColor,
                              child: Icon(
                                Icons.person,
                                color: whiteColor,
                              ),
                            ),
                            title: "${data[index]['friend_name']}"
                                .text
                                .color(isdarkMode ? whiteColor : darkFontGrey)
                                .fontFamily(semibold)
                                .make(),
                            subtitle: "${data[index]['last_msg']}".text.make(),
                          );
                        }),
                  ),
                ],
              );
            }
          }),
    );
  }
}
