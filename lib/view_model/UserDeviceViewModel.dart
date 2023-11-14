import 'package:flutter/material.dart';
import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/Comment.dart';
import 'package:connect_social/model/directories/comment_repo.dart';
import 'package:connect_social/model/directories/post_repo.dart';
import 'package:connect_social/model/directories/user_device_repo.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDeviceViewModel extends ChangeNotifier {
  UserDeviceRepo _userDeviceRepo=UserDeviceRepo();
  Future storeDeviceId(dynamic data,String token) async {
    try{
      final response =  await _userDeviceRepo.storeDeviceIdApi(data,token);
      //print(response);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(Constants.isStoredUserDeviceId,1);
      int? isStored= await prefs.getInt(Constants.isStoredUserDeviceId);
      //print('is stored updated : ${isStored}');
      return response;
    }catch(e){
      print(e);
    }
  }

  Future removeDeviceId(dynamic data,String token ) async {
    final response =  await _userDeviceRepo.removeDeviceIdApi(data,token);
    print(response);
    return response;
  }
}