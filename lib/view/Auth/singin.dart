import 'package:chat_app/Controller/auth_controller.dart';
import 'package:chat_app/Services/auth_services.dart';
import 'package:chat_app/Services/google_auth_services.dart';
import 'package:chat_app/view/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

import 'Singup.dart';
  var controller=Get.put(Authcontroller());
class SingIn extends StatelessWidget {
  const SingIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SignIn'),),
      body: SingleChildScrollView(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(20),
              height: 600,
              width: 360,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue.shade100,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "SignIn",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Remember to get up & stretch once",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "in a  while-your friends at chat",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: controller.txtEmail,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 1),borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2),borderRadius: BorderRadius.circular(10)),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                          )),
                    ),
                    SizedBox(height: 8,),
                    TextField(
                      controller: controller.txtPassword,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 1),borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2),borderRadius: BorderRadius.circular(10)),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    SizedBox(height: 20,),

                    GestureDetector(
                      onTap: () async {
                        String response= await AuthService.authService.signInwithEmailAndPassword(controller.txtEmail.text,controller.txtPassword.text);
                        User? user= AuthService.authService.getCurrentUser();
                        if(user!=null)
                        {
                          Get.offAndToNamed('/home');
                        }
                        else
                        {
                          Get.snackbar('signIn in failed', response);
                        }

                      },
                      child: Container(
                        height: 40,
                        width: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue,
                        ),
                        child: Center(
                            child: Text(
                              'SignIn',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            )),
                      ),
                    ),


                    SizedBox(
                      height: 8,
                    ),
                    Text('OR'),
                    SizedBox(
                      height: 8,
                    ),
                    SignInButton(Buttons.google, onPressed:() async {
                      await GoogleAuthService.googleAuthService.signInWithGoogle();
                      User? user= AuthService.authService.getCurrentUser();
                      if(user!=null)
                        {
                          Get.offAll(HomeScreen());

                        }

                    }),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.off(SignUp());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                           'Don\'t have account ?',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'signUp',
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),



        //     ElevatedButton(onPressed: () async {
        //      String response= await AuthService.authService.signInwithEmailAndPassword(controller.txtEmail.text,controller.txtPassword.text);
        //       User? user= AuthService.authService.getCurrentUser();
        //       if(user!=null)
        //         {
        //           Get.offAndToNamed('/home');
        // }
        //       else
        //         {
        //           Get.snackbar('singin in failed', response);
        //         }
        //
        //
        //     }, child: Text('SingIn'))
          ],
        ),
      ),
    );
  }
}
