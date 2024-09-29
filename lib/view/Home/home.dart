import 'package:chat_app/Controller/ThemeMode/ThemeController.dart';
import 'package:chat_app/Controller/chatController.dart';
import 'package:chat_app/Modal/user_modal.dart';
import 'package:chat_app/Services/auth_services.dart';
import 'package:chat_app/Services/cloud_firestroe_service.dart';
import 'package:chat_app/Services/google_auth_services.dart';
import 'package:chat_app/Services/local_notification_service.dart';
import 'package:chat_app/view/Auth/singin.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


var chatController = Get.put(ChatController());
var themeController = Get.put(ThemeController());

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    CloudFireStoreService.cloudFireStoreService.toggleOnlineStatus(
      true,
      Timestamp.now(),
      false,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      CloudFireStoreService.cloudFireStoreService
        ..toggleOnlineStatus(
          false,
          Timestamp.now(),
          false,
        );
    } else if (state == AppLifecycleState.resumed) {
      CloudFireStoreService.cloudFireStoreService
        ..toggleOnlineStatus(
          true,
          Timestamp.now(),
          false,
        );
    } else if (state == AppLifecycleState.inactive) {
      CloudFireStoreService.cloudFireStoreService
        ..toggleOnlineStatus(
          false,
          Timestamp.now(),
          false,
        );
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

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
                    Text(
                      userModel.name!,
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(userModel.email!),
                    Text(userModel.phone!),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          themeController.isDarkMode.value
                              ? Icons.nightlight_round
                              : Icons.sunny,
                          size: 24,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Theme",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          width: 120,
                        ),
                        Obx(
                          () => Switch(
                            value: themeController.isDarkMode.value,
                            onChanged: (value) {
                              themeController.toggleTheme();
                            },
                            activeColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () async {
                              await LocalNotificationService.notificationService
                                  .scheduleNotification();
                            },
                            icon: Icon(Icons.notifications)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Notification",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.settings,
                          size: 24,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Settings and Privacy',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.comment_outlined,
                          size: 24,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Help Center',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.notifications,
                          size: 24,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Notifications',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 150,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "LogOut",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        IconButton(
                            onPressed: () async {
                              await AuthService.authService.singOutUser();
                              await GoogleAuthService.googleAuthService
                                  .signOutFromGoogle();
                              User? user =
                                  AuthService.authService.getCurrentUser();
                              if (user == null) {
                                Get.off(const SingIn());
                              }
                            },
                            icon: Icon(Icons.logout)),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
      appBar: AppBar(
        title: Text("Vibetalk"),
        actions: [
          // IconButton(
          //     onPressed: () async {
          //       await AuthService.authService.singOutUser();
          //       await GoogleAuthService.googleAuthService
          //           .signOutFromGoogle();
          //       User? user =
          //       AuthService.authService.getCurrentUser();
          //       if (user == null) {
          //         Get.off(const SingIn());
          //       }
          //     },
          //     icon: Icon(Icons.logout)),
          // GestureDetector(
          //   onTap: () => showPopover(
          //       context: context,
          //       bodyBuilder: (context) => Obx(() => MenuItems()),
          //       width: 250,
          //       height: 150,
          //       backgroundColor: Colors.deepPurple.shade300,
          //       direction: PopoverDirection.bottom),
          //   child: Icon(Icons.more_vert),
          // ),
          // IconButton(
          //     onPressed: () async {
          //       await AuthService.authService.singOutUser();
          //       await GoogleAuthService.googleAuthService.signOutFromGoogle();
          //       User? user = AuthService.authService.getCurrentUser();
          //       if (user == null) {
          //         Get.off(const GetStartScreeen());
          //       }
          //     },
          //     icon: Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          // Expanded(
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       TextField(
          //         decoration: InputDecoration(
          //             prefixIcon: Icon(Icons.search), hintText: 'Serach Chat'),
          //       ),
          //       Container(
          //         height: 40,
          //         width: 40,
          //         decoration:
          //         BoxDecoration(borderRadius: BorderRadius.circular(20)),
          //         child: Icon(Icons.document_scanner),
          //       )
          //     ],
          //   ),
          // ),

          Flexible(
            child: FutureBuilder(
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
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children:[ Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                onTap: () {
                                  chatController.getReceiver(
                                      userList[index].email!,
                                      userList[index].name!);
                                  Get.toNamed('/chat');
                                },
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(userList[index].image!),
                                ),
                                title: Text(userList[index].name!),
                                subtitle: Text(userList[index].email!),
                              ),
                            ),
                          ]),
                        );
                      });
                }),
          ),

        ],
      ),
    );
  }
}
