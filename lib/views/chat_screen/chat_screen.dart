import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
//
import '../../consts/consts.dart';
import '../../controller/chats_controller.dart';
import '../../services/firebase_services.dart';
import '../../widgets_common/loading_indicator.dart';
import 'component/sender_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatController());
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: isdarkMode ? Colors.transparent : Colors.transparent,
          title: "${controller.friendName}"
              .text
              .fontFamily(semibold)
              .color(isdarkMode ? whiteColor : darkFontGrey)
              .make()),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),
                      ),
                    )
                  : Expanded(
                      child: StreamBuilder(
                          stream: FirestoreServices.getChatMessages(
                              controller.chatDocId.toString()),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return loadingIndicator();
                            } else if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: "Send a message..."
                                    .text
                                    .color(
                                        isdarkMode ? whiteColor : darkFontGrey)
                                    .make(),
                              );
                            } else {
                              return ListView(
                                children: snapshot.data!.docs
                                    .mapIndexed((currentValue, index) {
                                  var data = snapshot.data!.docs[index];
                                  return Align(
                                      alignment: data['uid'] == currentUser!.uid
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: senderBubble(data));
                                }).toList(),
                              );
                            }
                          }),
                    ),
            ),
            10.heightBox,
            Row(children: [
              Expanded(
                child: TextFormField(
                    controller: controller.msgController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  isdarkMode ? textfieldGrey : darkFontGrey)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: textfieldGrey)),
                      hintText: "Type your message...",
                    )),
              ),
              IconButton(
                  onPressed: () {
                    controller.sendMsg(controller.msgController.text);
                    controller.msgController.clear();
                  },
                  icon: const Icon(Icons.send, color: redColor)),
            ])
                .box
                .height(80)
                .padding(const EdgeInsets.all(12))
                .margin(const EdgeInsets.only(bottom: 8))
                .make(),
          ],
        ),
      ),
    );
  }
}
