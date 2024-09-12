import 'package:chat_app/Controller/auth_controller.dart';
import 'package:chat_app/Modal/user_modal.dart';
import 'package:chat_app/Services/auth_services.dart';
import 'package:chat_app/Services/cloud_firestroe_service.dart';
import 'package:chat_app/view/Auth/singin.dart';
import 'package:chat_app/view/Home/home.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool isCheck = true;

var controller = Get.put(Authcontroller());

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(20),
              height: 628,
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
                      "Register",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "You and your friends always connceted ",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: controller.txtName,
                      decoration: InputDecoration(
                         enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 1),borderRadius: BorderRadius.circular(10)),
                         focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2),borderRadius: BorderRadius.circular(10)),

                          labelText: 'Name',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          prefixIcon: Icon(
                            Icons.account_circle_outlined,
                          )),
                    ),
                    SizedBox(height: 8,),


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
                      controller: controller.txtPhone,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 1),borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2),borderRadius: BorderRadius.circular(10)),
                          labelText: 'Phone',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          prefixIcon: Icon(
                            Icons.call,
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
                    SizedBox(height: 8,),
                    TextField(
                      controller: controller.txtConfirmPassword,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 1),borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2),borderRadius: BorderRadius.circular(10)),
                          labelText: 'ConfromPassword',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isCheck,
                          onChanged: (value) {},
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'I agree with the ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Terms and condition  ',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              'and the privacy policy  ',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (controller.txtPassword.text == controller.txtConfirmPassword.text) {
                           await AuthService.authService.createAccountWithEmailAndPassword(controller.txtEmail.text, controller.txtPassword.text);
                          UserModel user = UserModel(
                              name: controller.txtName.text,
                              email:controller.txtEmail.text,
                              image:"https://marketplace.canva.com/EAFuJ5pCLLM/1/0/1600w/canva-black-and-gold-simple-business-man-linkedin-profile-picture-BM_NPo97JwE.jpg",
                              phone: controller.txtPhone.text,
                              token: "--------------------");

                        CloudFireStoreService.cloudFireStoreService.insertUserIntoFireStore(user);
                         // Get.back();

                          Get.offAll(HomeScreen());
                          controller.txtEmail.clear();
                          controller.txtPassword.clear();
                          controller.txtName.clear();
                          controller.txtPhone.clear();
                          controller.txtConfirmPassword.clear();
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
                          'SignUp',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.off(SingIn());
                        // Get.back();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have account ?',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'signIn',
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
