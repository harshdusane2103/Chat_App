import 'package:chat_app/Services/cloud_firestroe_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController
{
  RxString receiverEmail="".obs;
  RxString receiverName="".obs;
  TextEditingController txtMessage=TextEditingController();
  TextEditingController txtUpdateMessage=TextEditingController();
  void getReceiver(String email,String name)
  {
    receiverEmail.value=email;
    receiverName.value=name;
  }
  @override
  void onInit()
  {
    super.onInit();
    CloudFireStoreService.cloudFireStoreService.changeOnlineStatus(true);
  }
  @override
  // TODO: implement isClosed
  void onClose()
  {
    super.onClose();
    CloudFireStoreService.cloudFireStoreService.changeOnlineStatus(false);
  }


}