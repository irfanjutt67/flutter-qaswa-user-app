// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:get/get.dart';
//
import '../../consts/consts.dart';
import '../../controller/profile_controller.dart';
import '../../widgets_common/bg_widget.dart';
import '../../widgets_common/custom_textfield.dart';
import '../../widgets_common/our_button.dart';

class EditProfileScreens extends StatelessWidget {
  final dynamic data;

  const EditProfileScreens({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: isdarkMode ? Colors.transparent : Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // if data image url and controller path is empty

                Hero(
                  tag: data['imageUrl'],
                  child: data['imageUrl'] == '' &&
                          controller.profileImagePath.isEmpty
                      ? Image.asset(icProfile, width: 100, fit: BoxFit.contain)
                          .box
                          .roundedFull
                          .clip(Clip.antiAlias)
                          .make()
                      // if data is not empty but controller path is empty
                      : data['imageUrl'] != '' &&
                              controller.profileImagePath.isEmpty
                          ? Image.network(data['imageUrl'],
                                  width: 100, fit: BoxFit.cover)
                              .box
                              .roundedFull
                              .clip(Clip.antiAlias)
                              .make()

                          // if both are empty
                          : Image.file(File(controller.profileImagePath.value),
                                  width: 100, fit: BoxFit.cover)
                              .box
                              .roundedFull
                              .clip(Clip.antiAlias)
                              .make(),
                ),
                10.heightBox,
                outButton(
                  color: redColor,
                  onPress: () {
                    controller.changeImage(context);
                  },
                  textColor: whiteColor,
                  title: "Change",
                ),
                const Divider(),
                20.heightBox,
                customTextField(
                    controller: controller.nameController,
                    hint: nameHint,
                    title: name,
                    isPass: false),
                10.heightBox,
                customTextField(
                    controller: controller.oldpassController,
                    hint: passwordlHint,
                    title: oldpass,
                    isPass: true),
                10.heightBox,
                customTextField(
                    controller: controller.newpassController,
                    hint: passwordlHint,
                    title: newpass,
                    isPass: true),
                20.heightBox,
                controller.isloading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor))
                    : SizedBox(
                        width: context.screenWidth - 60,
                        child: outButton(
                            color: redColor,
                            onPress: () async {
                              controller.isloading(true);

                              //if image is not selected
                              if (controller
                                  .profileImagePath.value.isNotEmpty) {
                                await controller.uploadProfileImage();
                                Get.back();
                              } else {
                                controller.profileImageLink = data['imageUrl'];
                              }

                              // check old password is same in data base
                              if (data['password'] ==
                                  controller.oldpassController.text) {
                                await controller.changeAuthPassword(
                                  email: data['email'],
                                  password: controller.oldpassController.text,
                                  newpassword:
                                      controller.newpassController.text,
                                );

                                // after check old password in data base than update
                                await controller.updateProfile(
                                    imgUrl: controller.profileImageLink,
                                    name: controller.nameController.text,
                                    password:
                                        controller.newpassController.text);
                                VxToast.show(context, msg: "Updated Profile");
                                Get.back();
                              } else if (controller
                                      .oldpassController.text.isEmptyOrNull &&
                                  controller
                                      .newpassController.text.isEmptyOrNull) {
                                await controller.updateProfile(
                                    imgUrl: controller.profileImageLink,
                                    name: controller.nameController.text,
                                    password: data['password']);
                                VxToast.show(context, msg: "updated");
                                Get.back();
                              } else {
                                VxToast.show(context,
                                    msg: "Some error occured");
                                controller.isloading(false);
                              }
                            },
                            textColor: whiteColor,
                            title: "Save"),
                      ),
              ],
            )
                .box
                .color(isdarkMode ? fontGrey : whiteColor)
                .shadowSm
                .padding(const EdgeInsets.all(16))
                .rounded
                .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
                .make(),
          ),
        ),
      ),
    );
  }
}
