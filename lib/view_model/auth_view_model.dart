
import 'dart:convert';

import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:connect_social/model/directories/auth_repo.dart';
import 'package:connect_social/res/app_url.dart';
import 'package:connect_social/utils/utils.dart';

class AuthViewModel with ChangeNotifier {

  final _myRepo=AuthRepo();
  Future loginApi(dynamic data,BuildContext context) async {
    try{
      dynamic response=await _myRepo.loginApi(data);
      return jsonDecode(response);
    }catch(e){
      print(e);
    }

  }
  Future registerApi(dynamic data,BuildContext context) async {
    dynamic response=await _myRepo.registerApi(data);
    return jsonDecode(response);
  }
  Future afterRejected(dynamic data,authToken) async {
    dynamic response=await _myRepo.afterRejectionApi(data,authToken);
    return jsonDecode(response);
  }

  Future verifyEmail(dynamic data,BuildContext context) async {
    dynamic response=await _myRepo.verifyEmailApi(data);
    return jsonDecode(response);

  }
  Future isAuth(int? id) async {
    int authId = await AppSharedPref.getAuthId();
    if(authId==id){
      return true;
    }else{
      return false;
    }
  }




}
