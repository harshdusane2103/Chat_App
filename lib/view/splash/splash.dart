import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds:8), () {
      Get.offAndToNamed('/auth');
    });
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 250,),
          Center(
            child: Container(
              height: 250,
              width: 300,
              decoration: BoxDecoration(
                // color: Colors.red,
                image: DecorationImage(fit:BoxFit.cover,image: AssetImage('assets/image/logo3.gif')),
              ),

            ),
          ),
          Column(
            children: [
              // SizedBox(height: 10,),
              Text('VibeTalk',style: TextStyle(fontSize:36, color: Color(0xFF4379F2),fontWeight: FontWeight.bold ),)
            ],
          ),
        ],
      ),
    );
  }
}
