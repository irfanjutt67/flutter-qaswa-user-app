import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
//
import '../../consts/consts.dart';
import '../../widgets_common/applogo_widget.dart';
import '../home_screen.dart/home.dart';
import 'animated_onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController slideAnimation;
  late Animation<Offset> offsetAnimation;
  late Animation<Offset> textAnimation;
  //Creating a method to change screen
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      auth.authStateChanges().listen((User? user) {
        if (user == null && mounted) {
          Get.to(
            () => const AnimatedOnboard(),
          );
        } else {
          Get.to(
            () => const Homes(),
          );
        }
      });
    });
  }

  @override
  void initState() {
    changeScreen();
    animationController = AnimationController(
        vsync: this,
        lowerBound: 0,
        upperBound: 60,
        animationBehavior: AnimationBehavior.normal,
        duration: const Duration(milliseconds: 700));

    animationController.forward();

    slideAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.2, 0.0),
    ).animate(CurvedAnimation(
      parent: slideAnimation,
      curve: Curves.fastOutSlowIn,
    ));

    textAnimation = Tween<Offset>(
      begin: const Offset(-0.0, 0.0),
      end: const Offset(0.1, 0.0),
    ).animate(
        CurvedAnimation(parent: slideAnimation, curve: Curves.fastOutSlowIn));

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        slideAnimation.forward();
      }
    });
    super.initState();
  }

  // @override
  @override
  Widget build(BuildContext context) {
    var isdarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isdarkMode ? darkColor : const Color.fromARGB(255, 11, 1, 58),
      body: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(icSplashBg, width: 300),
            ),
            50.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: animationController,
                  builder: (_, child) {
                    return SlideTransition(
                        position: offsetAnimation,
                        child: applogoWidget(context));
                  },
                ),
                SlideTransition(
                  position: textAnimation,
                  child: appname.text.fontFamily(bold).size(25).white.make(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
