import 'package:chat_app/Controller/chatController.dart';
import 'package:chat_app/Modal/chatModel.dart';
import 'package:chat_app/Services/auth_services.dart';
import 'package:chat_app/Services/cloud_firestroe_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

var chatController = Get.put(ChatController());

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatController.receiverName.value),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                for (QueryDocumentSnapshot snap in data) {
                  chatList.add(ChatModel.fromMap(snap.data() as Map));
                }
                return ListView.builder(
                  itemBuilder: (context, index) =>
                      Text(chatList[index].message!.toString()),
                  itemCount: chatList.length,
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
                      },
                      icon: Icon(Icons.send))),
            ),
          ],
        ),
      ),
    );
  }
}
