import 'package:get/get.dart';
//
import '../../consts/consts.dart';
import '../../controller/auth_controller.dart';
import '../../widgets_common/applogo_widget.dart';
import '../../widgets_common/bg_widget.dart';
import '../../widgets_common/custom_textfield.dart';
import '../../widgets_common/our_button.dart';
import '../home_screen.dart/home.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;

    return bgWidget(
      child: Scaffold(
        backgroundColor: isdarkMode ? darkColor : Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(context),
              10.heightBox,
              "Login to your Account"
                  .text
                  .fontFamily(bold)
                  .white
                  .size(18)
                  .make(),
              15.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextField(
                      isPass: false,
                      hint: emailHint,
                      title: email,
                      controller: controller.emailController,
                      fillcolor: isdarkMode ? fontGrey : lightGrey,
                    ),
                    customTextField(
                      isPass: true,
                      hint: passwordlHint,
                      title: password,
                      controller: controller.passwordController,
                      fillcolor: isdarkMode ? fontGrey : lightGrey,
                    ),
                    5.heightBox,
                    controller.isLoading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          )
                        : outButton(
                            color: redColor,
                            title: login,
                            textColor: whiteColor,
                            onPress: () async {
                              controller.isLoading(true);
                              await controller
                                  .loginMethod(context: context)
                                  .then((value) {
                                if (value != null) {
                                  controller.isLoading(false);
                                  Get.off(() => const Homes());
                                  VxToast.show(context, msg: "Logged in");
                                  controller.clearfield();
                                } else {
                                  controller.isLoading(false);
                                }
                              });
                            },
                          ).box.width(context.screenWidth - 50).make(),
                    5.heightBox,
                    createNewAccount.text.white.make(),
                    5.heightBox,
                    outButton(
                      color: lightGolden,
                      title: signup,
                      textColor: redColor,
                      onPress: () {
                        Get.to(() => const SignupScreen());
                      },
                    ).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    loginWith.text.white.make(),
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          3,
                          (index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: lightGrey,
                                  radius: 25,
                                  child: Image.asset(
                                    socialIconList[index],
                                    width: 30,
                                  ),
                                ),
                              )),
                    ),
                  ],
                )
                    .box
                    .color(isdarkMode
                        ? fontGrey.withOpacity(0.2)
                        : whiteColor.withOpacity(0.2))
                    .shadowSm
                    .rounded
                    .padding(const EdgeInsets.all(16))
                    .width(context.screenWidth - 70)
                    .make(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
