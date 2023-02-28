import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:concentric_transition/concentric_transition.dart';
//
import '../../consts/consts.dart';
import '../../model/introduction_model.dart';
import '../auth_screen/login_screen.dart';

class AnimatedOnboard extends StatefulWidget {
  const AnimatedOnboard({Key? key}) : super(key: key);

  @override
  State<AnimatedOnboard> createState() => _AnimatedOnboardState();
}

class _AnimatedOnboardState extends State<AnimatedOnboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        curve: Curves.linear,
        colors: const <Color>[
          Color(0xff4700D8),
          Color(0xff9900F0),
          Color(0xffFF85B3),
        ],
        nextButtonBuilder: (context) => const Icon(
          Icons.navigate_next,
        ),
        itemCount: concentric.length,
        onFinish: () {
          Get.to(() => const LoginScreen());
        },
        itemBuilder: (index) {
          return FadeInUp(
            delay: const Duration(milliseconds: 700),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, right: 20),
                    child: GestureDetector(
                        onTap: () {
                          Get.to(() => const LoginScreen());
                        },
                        child: "Skip"
                            .text
                            .white
                            .fontWeight(FontWeight.w300)
                            .size(25)
                            .make()),
                  ),
                ),
                Image.asset(
                  concentric[index].imagess,
                ).box.size(300, 290).make(),
                concentric[index].title.text.white.size(30).bold.make(),
                concentric[index]
                    .subtitle
                    .text
                    .white
                    .center
                    .size(22)
                    .make()
                    .p(8),
                10.heightBox,
                "${index + 1} / ${concentric.length}"
                    .text
                    .white
                    .fontWeight(FontWeight.w400)
                    .size(22)
                    .make()
              ],
            ).box.makeCentered(),
          );
        },
      ),
    );
  }
}
