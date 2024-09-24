import 'package:chat_app/Controller/chatController.dart';
import 'package:chat_app/Modal/chatModel.dart';
import 'package:chat_app/Services/auth_services.dart';
import 'package:chat_app/Services/cloud_firestroe_service.dart';
import 'package:chat_app/Services/local_notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

var chatController = Get.put(ChatController());

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(chatController.receiverName.value),
            StreamBuilder(
              stream: CloudFireStoreService.cloudFireStoreService
                  .findUserIsOnlineOrNot(),
              builder: (context, snapshot) {
                Map? users = snapshot.data!.data();
                return Text(
                  users!['isOnline'] ? 'online' : 'offline',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                );
              },
            )
          ],
        ),
      ),
      body: Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
            // image: DecorationImage(
            //     fit: BoxFit.cover,
            //     image: AssetImage('assets/image/bg2.jpeg')
            //
            // )
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: StreamBuilder(
              stream: CloudFireStoreService.cloudFireStoreService
                  .readChatFromFireStore(chatController.receiverEmail.value),
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
                                    controller: chatController.txtUpdateMessage,
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          String dcId = docIdList[index];
                                          CloudFireStoreService.cloudFireStoreService.updateChat(chatController.receiverEmail.value,
                                                  chatController
                                                      .txtUpdateMessage.text,
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
                        child:
                        Padding(
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
                                  bottomRight: Radius.circular(13),
                                )
                                    : BorderRadius.only(
                                  topRight: Radius.circular(13),
                                  bottomLeft: Radius.circular(13),
                                  bottomRight: Radius.circular(13),
                                ),
                              ),
                              child:Text(chatList[index].message!.toString(),
                                        style: TextStyle(
                                            // color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                            )

                          ),

                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Container(
                            //       margin: EdgeInsets.symmetric(
                            //           horizontal: 8, vertical: 2),
                            //
                            //       alignment: (chatList[index].sender ==
                            //               AuthService.authService
                            //                   .getCurrentUser()!
                            //                   .email!)
                            //           ? Alignment.centerRight
                            //           : Alignment.centerLeft,
                            //       child: Text(chatList[index].message!.toString(),
                            //         style: TextStyle(
                            //             // color: Colors.black,
                            //             fontWeight: FontWeight.bold),
                            //       )),
                            // ),
                        ),
                        ),
                      ),
                  );

                  
                
              },
            )),
            TextField(
              controller: chatController.txtMessage,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: () async {
                        ChatModel chat = ChatModel(
                            sender:
                                AuthService.authService.getCurrentUser()!.email,
                            receiver: chatController.receiverEmail.value,
                            message: chatController.txtMessage.text,
                            time: Timestamp.now());
                        await CloudFireStoreService.cloudFireStoreService
                            .addChatInFireStore(chat);
                        await LocalNotificationService.notificationService.showNotification(AuthService.authService.getCurrentUser()!.email!,chatController.txtMessage.text );
                        chatController.txtMessage.clear();
                      },
                      icon: Icon(Icons.send))),
            ),
          ],
        ),
      ),
    );
  }
}
