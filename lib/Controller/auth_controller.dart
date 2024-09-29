import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Authcontroller extends GetxController
{

  RxBool isCheck = false.obs;
  TextEditingController txtEmail=TextEditingController();
  TextEditingController txtPassword=TextEditingController();
  TextEditingController txtName=TextEditingController();
  TextEditingController txtPhone=TextEditingController();
  TextEditingController txtConfirmPassword=TextEditingController();
  RxBool obscure = false.obs;
  RxBool rememberMeCheck=false.obs;
  final RxBool _obscure = false.obs;

  void Phoneluncher()
  {
    Uri uri = Uri.parse('tel: 9638799776');
    launchUrl(uri);
  }
  void obscureCheck() {
    _obscure.value = !_obscure.value;
  }




}
