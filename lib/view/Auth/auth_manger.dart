import 'package:chat_app/Services/auth_services.dart';
import 'package:chat_app/view/Auth/singin.dart';
import 'package:chat_app/view/Home/home.dart';
import 'package:flutter/material.dart';
class AuthManger extends StatelessWidget {
  const AuthManger({super.key});

  @override
  Widget build(BuildContext context) {
    return (AuthService.authService.getCurrentUser()==null)?SingIn():HomeScreen();
  }
}
