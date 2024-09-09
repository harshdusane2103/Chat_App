import 'package:chat_app/Services/auth_services.dart';
import 'package:chat_app/Services/google_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Auth/get_start.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
        actions: [
          IconButton(onPressed: () async {
           await AuthService.authService.singOutUser();
           await GoogleAuthService.googleAuthService.signOutFromGoogle();
            User? user=AuthService.authService.getCurrentUser();
            if(user==null)
              {
                Get.off(const GetStartScreeen());

              }

          }, icon: Icon(Icons.logout))
        ],
      ),
    );
  }
}
