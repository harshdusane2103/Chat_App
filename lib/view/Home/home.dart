import 'package:chat_app/Controller/ThemeMode/ThemeController.dart';
import 'package:chat_app/Controller/chatController.dart';
import 'package:chat_app/Modal/user_modal.dart';
import 'package:chat_app/Services/auth_services.dart';
import 'package:chat_app/Services/cloud_firestroe_service.dart';
import 'package:chat_app/Services/google_auth_services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Auth/get_start.dart';

var chatController = Get.put(ChatController());
var themeController=Get.put(ThemeController());

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: FutureBuilder(
            future: CloudFireStoreService.cloudFireStoreService
                .readCurrentUserFromFireStore(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              Map? data = snapshot.data!.data();
              UserModel userModel = UserModel.fromMap(data!);
              return Center(
                child: Column(
                  children: [
                    DrawerHeader(
                        child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(userModel.image!),
                    )),
                    Text(userModel.name!),
                    Text(userModel.email!),
                    Text(userModel.phone!),
                  ],
                ),
              );
            }),
      ),
      appBar: AppBar(
        title: Text("Homepage"),
        actions: [
          // CupertinoSwitch(
          //   value: themeController.currentTheme,
          //   onChanged: (value) => themeController.toggleTheme(),
          //   activeColor: Color(0xFF4379F2),
          //   offLabelColor: Colors.white,
          //   focusColor: Colors.white,
          //   onLabelColor: Colors.white,
          //   trackColor: Colors.grey,
          // ),
          Obx(
          ()=> Switch(
              value: themeController.isDarkMode.value,
              onChanged: (value) {
                themeController.toggleTheme();




              },
            activeColor: Colors.white,
            ),
          ),
          // ElevatedButton(
          //   onPressed: themeController.toggleTheme,
          //   child: Text('Toggle Theme'),
          // ),
          IconButton(
              onPressed: () async {
                await AuthService.authService.singOutUser();
                await GoogleAuthService.googleAuthService.signOutFromGoogle();
                User? user = AuthService.authService.getCurrentUser();
                if (user == null) {
                  Get.off(const GetStartScreeen());
                }
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder(
          future: CloudFireStoreService.cloudFireStoreService
              .readAllUserFromCloudFireStore(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List data = snapshot.data!.docs;
            List<UserModel> userList = [];
            for (var user in data) {
              userList.add(UserModel.fromMap(user.data()));
            }
            return ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      chatController.getReceiver(
                          userList[index].email!, userList[index].name!);
                      Get.toNamed('/chat');
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(userList[index].image!),
                    ),
                    title: Text(userList[index].name!),
                    subtitle: Text(userList[index].email!),
                  );
                });
          }),

    );
  }
}
