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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page:()=>SplashScreen(),transition: Transition.rightToLeft),
        GetPage(name: '/start', page:()=>GetStartScreeen(),transition: Transition.rightToLeft),
        GetPage(name: '/auth', page:()=>AuthManger(),transition: Transition.rightToLeft),
        GetPage(name: '/singIn', page:()=>SingIn(),transition: Transition.rightToLeft),
        GetPage(name: '/singUp', page:()=>SignUp(),transition: Transition.rightToLeft),
        GetPage(name: '/home', page:()=>HomeScreen(),transition: Transition.rightToLeft),
        GetPage(name: '/chat', page:()=>ChatScreen(),transition: Transition.rightToLeft),
      ],
    );
  }
}

