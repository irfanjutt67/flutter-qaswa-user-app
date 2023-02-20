import 'package:get/get.dart';
import 'package:validation_textformfield/validation_textformfield.dart';
//
import 'package:qaswa_user/consts/consts.dart';
import 'package:qaswa_user/controller/auth_controller.dart';
import '../../widgets_common/applogo_widget.dart';
import '../../widgets_common/bg_widget.dart';
import '../../widgets_common/custom_textfield.dart';
import '../../widgets_common/our_button.dart';
import '../home_screen.dart/home.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  bool _obscureText = true;
  var controller = Get.put(AuthController());

  final formKey = GlobalKey<FormState>(); //key
  //text Controller

  var nameController = TextEditingController();
  var txtEmailCtrl = TextEditingController();
  var txtPasswordCtrl = TextEditingController();
  var txtConfPasswordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;
    return bgWidget(
      child: Scaffold(
        backgroundColor: isdarkMode ? darkColor : Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                (context.screenHeight * 0.1).heightBox,
                applogoWidget(context),
                10.heightBox,
                "Join the $appname".text.fontFamily(bold).white.size(18).make(),
                15.heightBox,
                Obx(
                  () => Form(
                    key: formKey,
                    child: Column(
                      children: [
                        customTextField(
                          isPass: false,
                          hint: nameHint,
                          controller: nameController,
                          fillcolor: isdarkMode ? fontGrey : lightGrey,
                        ),
                        10.heightBox,
                        EmailValidationTextField(
                          textInputAction: TextInputAction.next,
                          whenTextFieldEmpty: "Please enter  email",
                          validatorMassage: "Please enter valid email",
                          decoration: InputDecoration(
                            hintText: emailHint,
                            isDense: true,
                            hintStyle: const TextStyle(
                                fontFamily: semibold, color: textfieldGrey),
                            fillColor: isdarkMode ? fontGrey : lightGrey,
                            filled: true,
                            border: InputBorder.none,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: redColor),
                            ),
                          ),
                          textEditingController: txtEmailCtrl,
                        ),
                        16.heightBox,
                        PassWordValidationTextFiled(
                          textInputAction: TextInputAction.next,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: passwordlHint,
                            isDense: true,
                            hintStyle: const TextStyle(
                                fontFamily: semibold, color: textfieldGrey),
                            fillColor: isdarkMode ? fontGrey : lightGrey,
                            filled: true,
                            suffixIcon: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off)
                                .box
                                .make()
                                .onTap(() {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            }),
                            border: InputBorder.none,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: redColor),
                            ),
                          ),
                          autoCorrect: true,
                          lineIndicator: true,
                          passwordMinError: "Must be more than 5 charater",
                          hasPasswordEmpty: "Password is Empty",
                          passwordMaxError: "Password to long",
                          passWordUpperCaseError:
                              "at least one Uppercase (Capital)lette",
                          passWordDigitsCaseError: "at least one digit",
                          passwordLowercaseError:
                              "at least one lowercase character",
                          passWordSpecialCharacters:
                              "at least one Special Characters",
                          scrollPadding: const EdgeInsets.only(left: 60),
                          passTextEditingController: txtPasswordCtrl,
                          passwordMaxLength: 10,
                          passwordMinLength: 5,
                        ),
                        ConfirmPassWordValidationTextFromField(
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: passwordlHint,
                            isDense: true,
                            hintStyle: const TextStyle(
                                fontFamily: semibold, color: textfieldGrey),
                            fillColor: isdarkMode ? fontGrey : lightGrey,
                            filled: true,
                            border: InputBorder.none,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: redColor),
                            ),
                          ),
                          whenTextFieldEmpty: "Empty",
                          validatorMassage: "Password not Match",
                          confirmtextEditingController: txtConfPasswordCtrl,
                        ),
                        10.heightBox,
                        Row(
                          children: [
                            Checkbox(
                              activeColor: redColor,
                              checkColor: whiteColor,
                              value: isCheck,
                              onChanged: (newValue) {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    isCheck = newValue;
                                  });
                                }
                              },
                            ),
                            10.widthBox,
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "I agree to the ",
                                      style: TextStyle(
                                          fontFamily: regular,
                                          color: whiteColor),
                                    ),
                                    TextSpan(
                                      text: termsAndCond,
                                      style: TextStyle(
                                        fontFamily: regular,
                                        color: redColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " & ",
                                      style: TextStyle(
                                          fontFamily: regular,
                                          color: whiteColor),
                                    ),
                                    TextSpan(
                                      text: privacyPolicy,
                                      style: TextStyle(
                                        fontFamily: regular,
                                        color: redColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        5.heightBox,
                        controller.isLoading.value
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(redColor),
                              )
                            : outButton(
                                color: isCheck == true ? redColor : lightGrey,
                                title: signup,
                                textColor: whiteColor,
                                onPress: () async {
                                  if (isCheck != false) {
                                    controller.isLoading(true);
                                    try {
                                      await controller
                                          .signupMethod(
                                              context: context,
                                              email: txtEmailCtrl.text.trim(),
                                              password:
                                                  txtPasswordCtrl.text.trim())
                                          .then((value) {
                                        return controller.storeUserData(
                                          email: txtEmailCtrl.text.trim(),
                                          password: txtPasswordCtrl.text.trim(),
                                          name: nameController.text.trim(),
                                        );
                                      }).then((value) {
                                        VxToast.show(context, msg: loggedIn);
                                        Get.offAll(() => const Homes());
                                      });
                                    } catch (e) {
                                      auth.signOut();
                                      VxToast.show(context, msg: e.toString());
                                      controller.isLoading(false);
                                    }
                                  }
                                },
                              ).box.width(context.screenWidth - 50).make(),
                        10.heightBox,

                        //Wrap ing with gesture detactor pf velocity X

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            alreadyHaveAccount.text.white.make(),
                            login.text.color(redColor).make().onTap(() {
                              Get.back();
                            })
                          ],
                        ),
                      ],
                    )
                        .box
                        .color(isdarkMode
                            ? fontGrey.withOpacity(0.2)
                            : whiteColor.withOpacity(0.2))
                        .shadow
                        .rounded
                        .padding(const EdgeInsets.all(16))
                        .width(context.screenWidth - 70)
                        .make(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
