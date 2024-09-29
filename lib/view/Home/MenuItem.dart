import 'package:chat_app/Controller/ThemeMode/ThemeController.dart';
import 'package:chat_app/Controller/chatController.dart';
import 'package:chat_app/Services/auth_services.dart';
import 'package:chat_app/Services/google_auth_services.dart';
import 'package:chat_app/view/Auth/get_start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class MenuItems extends StatelessWidget {
  const MenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    // var chatController = Get.put(ChatController());
    var themeController=Get.put(ThemeController());
    return
      Column(
      children: [
        Container(
          height: 50,
          color: Colors.deepPurple,
        ),
        Container(
          height: 50,
          color: Colors.deepPurple,
        ),
        Container(
          height: 50,
          color: Colors.deepPurple,
        ),


        // Container(
        //   height: 50,
        //   color: Colors.white,
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Text("Theme "),
        //       Obx(
        //             ()=> Switch(
        //           value: themeController.isDarkMode.value,
        //           onChanged: (value) {
        //             themeController.toggleTheme();
        //           },
        //           activeColor: Colors.white,
        //         ),
        //       ),
        //
        //
        //     ],
        //   ),
        // ),
        // Container(
        //   height: 50,
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //
        //       Text("LogOut"),
        //       IconButton(
        //           onPressed: () async {
        //             await AuthService.authService.singOutUser();
        //             await GoogleAuthService.googleAuthService.signOutFromGoogle();
        //             User? user = AuthService.authService.getCurrentUser();
        //             if (user == null) {
        //               Get.off(const GetStartScreeen());
        //             }
        //           },
        //           icon: Icon(Icons.logout))
        //     ],
        //   ),
        // ),

      ],
    );
  }
}
