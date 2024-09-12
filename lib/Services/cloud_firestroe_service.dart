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

  void insertUserIntoFireStore(UserModel user)    {
       fireStore.collection("user").doc(user.email).set({
      'email': user.email,
      'name': user.name,
      'phone': user.phone,
      'image': user.image,
      'token': user.token,
    });
  }
  Future<DocumentSnapshot<Map<String, dynamic>>> readCurrentUserFromFireStore()
  async {
    User? user =AuthService.authService.getCurrentUser();
   return await fireStore.collection("user").doc(user!.email).get();
  }
  Future<QuerySnapshot<Map<String, dynamic>>> readAllUserFromCloudFireStore()
  async {
    User? user =AuthService.authService.getCurrentUser();
   return await fireStore.collection("user").where("email",isNotEqualTo: user!.email).get();
  }


}
