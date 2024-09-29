import 'dart:developer';

import 'package:chat_app/Modal/user_modal.dart';
import 'package:chat_app/Services/cloud_firestroe_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService
{
  GoogleAuthService._();
  static GoogleAuthService googleAuthService=GoogleAuthService._();
  GoogleSignIn googleSignIn=GoogleSignIn();
  Future<void> signInWithGoogle()
  async {
    try
    {
      GoogleSignInAccount? account= await googleSignIn.signIn();
      GoogleSignInAuthentication authentication =await account!.authentication;
      AuthCredential credential =GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,

      );
      UserCredential userCredential=await FirebaseAuth.instance.signInWithCredential(credential);
      UserModel user=UserModel(name:userCredential.user!.displayName.toString(),
        email: userCredential.user!.phoneNumber.toString(),
        image:userCredential.user!.photoURL.toString() ,
        phone: userCredential.user!.phoneNumber.toString(),
        token: '--------------',
        isOnline:true,
        isTyping: true,
      );
      CloudFireStoreService.cloudFireStoreService.insertUserIntoFireStore(user);
      log(userCredential.user!.email!);
      log(userCredential.user!.photoURL!);

    }
    catch(e)
    {
      Get.snackbar("SignIn failed", "e.toString()");
      log(e.toString());
    }



  }
  Future<void> signOutFromGoogle()
  async {
    await googleSignIn.signOut();
  }



}
