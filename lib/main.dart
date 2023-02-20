import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'consts/consts.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
//
import 'views/splash_screen/splash_screen.dart';
import 'widgets_common/dark.dart';

final _themedata = GetStorage();
Future<void> main() async {
  // Initializing Firestore
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); //get storage initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool darkMode = _themedata.read('darkmode') ?? false;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: darkMode ? AppTheme.darktheme : AppTheme.lightheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
