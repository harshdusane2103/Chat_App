import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

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
  void obscureCheck() {
    _obscure.value = !_obscure.value;
  }




}
