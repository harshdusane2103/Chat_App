import 'package:chat_app/Controller/auth_controller.dart';
import 'package:chat_app/Controller/chatController.dart';
import 'package:chat_app/Modal/chatModel.dart';
import 'package:chat_app/Services/auth_services.dart';
import 'package:chat_app/Services/cloud_firestroe_service.dart';
import 'package:chat_app/Services/local_notification_service.dart';
import 'package:chat_app/Services/storage_seravice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

var chatController = Get.put(ChatController());
var controller = Get.put(Authcontroller());

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // double h = MediaQuery.of(context).size.height;
    // double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                  "https://marketplace.canva.com/EAFuJ5pCLLM/1/0/1600w/canva-black-and-gold-simple-business-man-linkedin-profile-picture-BM_NPo97JwE.jpg"),
            ),
            SizedBox(
              width: 5,
            ),
            //
            Text(chatController.receiverName.value),

            // Column(
            //   // crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     // Text(
            //     //   chatController.receiverName.value,
            //     //   style: TextStyle(fontSize: w * 0.044),
            //     //   overflow: TextOverflow.ellipsis,
            //     // ),
            //     StreamBuilder(
            //       stream: CloudFireStoreService.cloudFireStoreService
            //           .checkUserIsOnlineOrNot(
            //           chatController.receiverEmail.value),
            //       builder: (context, snapshot) {
            //         if (snapshot.hasError) {
            //           return Text(snapshot.error.toString());
            //         }
            //         if (snapshot.connectionState ==
            //             ConnectionState.waiting) {
            //           return const Text('',style: TextStyle(),);
            //         }
            //
            //         Map? user = snapshot.data!.data();
            //         String nightDay = '';
            //         if (user!['lastSeen'].toDate().hour > 11) {
            //           nightDay = 'PM';
            //         } else {
            //           nightDay = 'AM';
            //         }
            //         return Text(
            //           user['isOnline']
            //               ? (user['isTyping'])
            //               ? 'Typing...'
            //               : 'Online'
            //               : 'Last seen at ${user['lastSeen'].toDate().hour % 12}:${user['lastSeen'].toDate().minute} $nightDay',
            //           style: const TextStyle(
            //             color: Colors.grey,
            //           ),
            //         );
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                controller.Phoneluncher();
              },
              icon: Icon(Icons.phone)),
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: 800,
              width:402,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     fit:BoxFit.fill,
              //     image: AssetImage ('assets/image/chat.jpg'),
              //   ),
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: StreamBuilder(
                    stream: CloudFireStoreService.cloudFireStoreService
                        .readChatFromFireStore(
                            chatController.receiverEmail.value),
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
                      List<ChatModel> chatList = [];
                      List<String> docIdList = [];
                      for (QueryDocumentSnapshot snap in data) {
                        docIdList.add(snap.id);
                        chatList.add(ChatModel.fromMap(snap.data() as Map));
                      }
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: List.generate(
                            chatList.length,
                            (index) => GestureDetector(
                              onLongPress: () {
                                if (chatList[index].sender ==
                                    AuthService.authService
                                        .getCurrentUser()!
                                        .email!) {
                                  chatController.txtUpdateMessage =
                                      TextEditingController(
                                          text: chatList[index].message);
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('update'),
                                        content: TextField(
                                          controller:
                                              chatController.txtUpdateMessage,
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                String dcId = docIdList[index];
                                                CloudFireStoreService
                                                    .cloudFireStoreService
                                                    .updateChat(
                                                        chatController
                                                            .receiverEmail
                                                            .value,
                                                        chatController
                                                            .txtUpdateMessage
                                                            .text,
                                                        dcId);
                                                Get.back();
                                              },
                                              child: Text('Update')),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              onDoubleTap: () {
                                CloudFireStoreService.cloudFireStoreService
                                    .removeChat(docIdList[index],
                                        chatController.receiverEmail.value);
                              },
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8, right: 14, left: 14),
                                  child: Container(
                                    alignment: (chatList[index].sender ==
                                            AuthService.authService
                                                .getCurrentUser()!
                                                .email!)
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: (chatList[index].sender ==
                                                AuthService.authService
                                                    .getCurrentUser()!
                                                    .email!)
                                            ? Color(0xff41B3A2)
                                            : Color(0xffA594F9),
                                        borderRadius: (chatList[index].sender ==
                                                AuthService.authService
                                                    .getCurrentUser()!
                                                    .email!)
                                            ? BorderRadius.only(
                                                topLeft: Radius.circular(13),
                                                bottomLeft: Radius.circular(13),
                                                bottomRight:
                                                    Radius.circular(13),
                                              )
                                            : BorderRadius.only(
                                                topRight: Radius.circular(13),
                                                bottomLeft: Radius.circular(13),
                                                bottomRight:
                                                    Radius.circular(13),
                                              ),
                                      ),
                                      // child:Image.network( chatList[index].image!),

                                      child: (chatList[index].image!.isEmpty &&
                                              chatList[index].image == "")
                                          ? Text(
                                              chatList[index]
                                                  .message!
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Container(
                                              height: 300,
                                              child: Image.network(
                                                  chatList[index].image!),
                                            ),
                                    ),
                                  )),

                              //     Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Container(
                              //     margin: EdgeInsets.symmetric(
                              //         horizontal: 8, vertical: 2),
                              //     alignment: (chatList[index].sender ==
                              //             AuthService.authService
                              //                 .getCurrentUser()!
                              //                 .email!)
                              //         ? Alignment.centerRight
                              //         : Alignment.centerLeft,
                              //     child: (chatList[index].image!.isEmpty && chatList[index].image == "")
                              //         ? Text(
                              //             chatList[index].message!.toString(),
                              //             style:
                              //                 TextStyle(fontWeight: FontWeight.bold),
                              //           )
                              //         : Card(
                              //             child:
                              //                 Image.network(chatList[index].image!)),
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                      );
                    },
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 300,
                        child: TextField(
                          onChanged: (value) {
                            chatController.txtMessage.text = value;
                            CloudFireStoreService.cloudFireStoreService
                                .toggleOnlineStatus(
                              true,
                              Timestamp.now(),
                              true,
                            );
                          },
                          controller: chatController.txtMessage,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.emoji_emotions_outlined),
                            hintText: "Message",
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2)),
                            suffixIcon: IconButton(
                                onPressed: () async {
                                  String url = await StorageService.service
                                      .uploadImage();
                                  chatController.getImage(url);
                                },
                                icon: Icon(Icons.image)),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 29,
                        backgroundColor: Colors.blue,
                        child: IconButton(
                            onPressed: () async {
                              ChatModel chat = ChatModel(
                                  image: chatController.image.value,
                                  sender: AuthService.authService
                                      .getCurrentUser()!
                                      .email,
                                  receiver: chatController.receiverEmail.value,
                                  message: chatController.txtMessage.text,
                                  time: Timestamp.now());
                              await CloudFireStoreService.cloudFireStoreService
                                  .addChatInFireStore(chat);
                              await LocalNotificationService.notificationService
                                  .showNotification(
                                      AuthService.authService
                                          .getCurrentUser()!
                                          .email!,
                                      chatController.txtMessage.text);
                              chatController.txtMessage.clear();
                              chatController.getImage("");
                            },
                            icon: Icon(Icons.send)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Container(
// height: 120,
// // color: Colors.red,
// child: Row(
// children: [
// SizedBox(
// width: 2,
// ),
// GestureDetector(
// onTap: () {
// Get.back();
// },
// child: Icon(Icons.arrow_back)),
// SizedBox(
// width: 12,
// ),
// CircleAvatar(
// radius: 25,
// backgroundImage: NetworkImage(
// "https://marketplace.canva.com/EAFuJ5pCLLM/1/0/1600w/canva-black-and-gold-simple-business-man-linkedin-profile-picture-BM_NPo97JwE.jpg"),
// ),
// //
// // Text(chatController.receiverName.value),
// SizedBox(
// width: 5,
// ),
// // Column(
// //   mainAxisSize: MainAxisSize.min,
// //   crossAxisAlignment: CrossAxisAlignment.start,
// //   children: [
// //     Text(chatController.receiverName.value),
// //     StreamBuilder(
// //       stream: CloudFireStoreService.cloudFireStoreService
// //           .checkUserIsOnlineOrNot(
// //               chatController.receiverEmail.value),
// //       builder: (context, snapshot) {
// //         Map? users = snapshot.data!.data();
// //         return Text(
// //           users!['isOnline'] ? 'online' : 'offline',
// //           style: TextStyle(fontSize: 12, color: Colors.green),
// //         );
// //       },
// //     )
// //   ],
// // ),
// Column(
// children: [
// Text(
// chatController.receiverName.value,
// style: TextStyle(fontSize: 20),
// overflow: TextOverflow.ellipsis,
// ),
// StreamBuilder(
// stream: CloudFireStoreService.cloudFireStoreService
//     .checkUserIsOnlineOrNot(
// chatController.receiverEmail.value),
// builder: (context, snapshot) {
// if (snapshot.hasError) {
// return Text(snapshot.error.toString());
// }
// if (snapshot.connectionState ==
// ConnectionState.waiting) {
// return const Text('');
// }
//
// Map? user = snapshot.data!.data();
// return Text(
// user!['isOnline'] ? 'online' : 'offline',
// style: TextStyle(fontSize: 12, color: Colors.green),
// );
//
// String nightDay = '';
// if (user!['lastSeen'].toDate().hour > 11) {
// nightDay = 'PM';
// } else {
// nightDay = 'AM';
// }
// return Text(
// user['isOnline']
// ? (user['isTyping'])
// ? 'Typing...'
//     : 'Online'
//     : 'Last seen at ${user['lastSeen'].toDate().hour % 12}:${user['lastSeen'].toDate().minute} $nightDay',
// style: const TextStyle(
// color: Colors.grey,
// ),
// );
// },
// ),
// ],
// ),
// ],
// ),
// //   // actions: [
// //   //   IconButton(onPressed: () {}, icon: Icon(Icons.phone)),
// //   //   IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
// //   // ],,
// ),
