import 'package:chat_app/Modal/chatModel.dart';
import 'package:chat_app/Modal/user_modal.dart';
import 'package:chat_app/Services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudFireStoreService {
  // collection :doc-set-update/add
  CloudFireStoreService._();

  static CloudFireStoreService cloudFireStoreService =
      CloudFireStoreService._();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  void insertUserIntoFireStore(UserModel user) {
    fireStore.collection("user").doc(user.email).set({
      'email': user.email,
      'name': user.name,
      'phone': user.phone,
      'image': user.image,
      'token': user.token,
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>>
      readCurrentUserFromFireStore() async {
    User? user = AuthService.authService.getCurrentUser();
    return await fireStore.collection("user").doc(user!.email).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>>
      readAllUserFromCloudFireStore() async {
    User? user = AuthService.authService.getCurrentUser();
    return await fireStore
        .collection("user")
        .where("email", isNotEqualTo: user!.email)
        .get();
  }

  Future<void> addChatInFireStore(ChatModel chat) async {
    String? sender = chat.sender;
    String? receiver = chat.receiver;
    List doc = [sender, receiver];
    doc.sort();
    String docId=doc.join("_");

    await fireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .add(chat.toMap(chat));
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> readChatFromFireStore(String receiver)
  {
    String sender= AuthService.authService.getCurrentUser()!.email!;
    List doc=[sender,receiver];
    doc.sort;
    String docId=doc.join("_");
    return fireStore.collection("chatroom").doc(docId).collection("chat").orderBy("time",descending: false).snapshots();
  }


  Future<void> updateChat(String receiver,String message,String dcId)
  async {
    String sender= AuthService.authService.getCurrentUser()!.email!;
    List doc=[sender,receiver];
    doc.sort;
    String docId=doc.join("_");
    await fireStore.collection("chatroom").doc(docId).collection("chat").doc(dcId).update({'message':message},);
  }
  Future<void> removeChat(String dcId,String receiver)
  async {
    String sender= AuthService.authService.getCurrentUser()!.email!;
    List doc=[sender,receiver];
    doc.sort;
    String docId=doc.join("_");
    await fireStore.collection("chatroom").doc(docId).collection("chat").doc(dcId).delete();
  }
  Future<void> changeOnlineStatus(bool status)
  async {
    String email= AuthService.authService.getCurrentUser()!.email!;
    await fireStore.collection("user").doc(email).update({'isOnline':status});
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> findUserIsOnlineOrNot()
  {
    String email=AuthService.authService.getCurrentUser()!.email!;
    return fireStore.collection("user").doc(email).snapshots();
  }

}
