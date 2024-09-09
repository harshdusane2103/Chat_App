import 'package:chat_app/Controller/auth_controller.dart';
import 'package:chat_app/Services/auth_services.dart';
import 'package:chat_app/view/Auth/singin.dart';
import 'package:chat_app/view/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool ischeck = false;

var controller = Get.put(AuthController());

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
                      controller: controller.txtEmail,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                          )),
                    ),
                    TextField(
                      controller: controller.txtPassword,
                      decoration: InputDecoration(
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
                    Row(
                      children: [
                        Checkbox(
                          value: ischeck,
                          onChanged: (value) {},
                        ),
                       Column(
                         children: [
                           Row(
                             children: [
                               Text(
                                 'I agree with the ',
                                 style: TextStyle(
                                     color: Colors.black, fontWeight: FontWeight.bold),
                               ),
                               Text(
                                 'Terms and condition  ',
                                 style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                               ),
                             ],
                           ),
                           Text(
                             'and the privacy policy  ',
                             style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold ),
                           ),
                         ],
                       )
                      ],
                    ),
                    SizedBox(height: 20,),

                    GestureDetector(
                      onTap: () {
                        AuthService.authService
                            .createAccountWithEmailAndPassword(
                                controller.txtEmail.text,
                                controller.txtPassword.text);
                        controller.txtEmail.clear();
                        controller.txtPassword.clear();
                        Get.offAll(HomeScreen());
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
