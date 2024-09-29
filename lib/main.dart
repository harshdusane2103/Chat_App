import 'package:chat_app/Controller/ThemeMode/ThemeController.dart';
import 'package:chat_app/Services/firebase_messaging_service.dart';
import 'package:chat_app/Services/local_notification_service.dart';
import 'package:chat_app/view/Auth/Singup.dart';
import 'package:chat_app/view/Auth/auth_manger.dart';
import 'package:chat_app/view/Auth/get_start.dart';
import 'package:chat_app/view/Auth/singin.dart';
import 'package:chat_app/view/Home/chatpage.dart';
import 'package:chat_app/view/Home/home.dart';
import 'package:chat_app/view/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest_all.dart' as tz;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNotificationService.notificationService..initNotificationService();
  // await FirebaseMessagingService.fm.requestPermission();
  // await FirebaseMessagingService.fm.getDeviceToken();
  tz.initializeTimeZones();
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return Obx(
      ()=>GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeController.currentTheme,
        darkTheme: ThemeData.dark(),


      themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        //
        // theme: ThemeData.light(),
        // darkTheme: ThemeData.dark(),
        // themeMode: themeController.isDark ? ThemeMode.dark : ThemeMode.light,
        getPages: [
          GetPage(name: '/', page:()=>SplashScreen(),transition: Transition.rightToLeft),
          GetPage(name: '/start', page:()=>GetStartScreeen(),transition: Transition.rightToLeft),
          GetPage(name: '/auth', page:()=>AuthManger(),transition: Transition.rightToLeft),
          GetPage(name: '/singIn', page:()=>SingIn(),transition: Transition.rightToLeft),
          GetPage(name: '/singUp', page:()=>SignUp(),transition: Transition.rightToLeft),
          GetPage(name: '/home', page:()=>HomeScreen(),transition: Transition.rightToLeft),
          GetPage(name: '/chat', page:()=>ChatScreen(),transition: Transition.rightToLeft),
        ],
      ),
    );
  }
}

