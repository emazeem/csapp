
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/home.dart';
import 'package:connect_social/view/screens/login.dart';
import 'package:connect_social/view/screens/widgets/layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connect_social/res/routes.dart' as route;

class AppSharedPref {

  removeDeviceId(){

  }

  static saveAuthTokenResponse(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.authToken,key);
  }
  static saveOtp(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.registerOtp,key);
  }
  static saveLoginUserResponse(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(Constants.userKey,id);
  }
  static saveEmailVerified(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.email_verified,key);
  }
  static saveDeviceId(String? key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.user_device_id,key!);
    await prefs.setInt(Constants.isStoredUserDeviceId,0);
  }

  static getAuthToken()async{
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(Constants.authToken) ?? '';
    return token;
  }
  static getUserDeviceId()async{
    final prefs = await SharedPreferences.getInstance();
    final String userDeviceId = prefs.getString(Constants.user_device_id) ?? '';
    return userDeviceId;
  }
  static isStoredDeviceId()async{
    final prefs = await SharedPreferences.getInstance();
    final int? result = prefs.getInt(Constants.isStoredUserDeviceId);
    return result;
  }

  static getAuthId()async{
    final prefs = await SharedPreferences.getInstance();
    final int id = prefs.getInt(Constants.userKey) ?? 0;
    return id;
  }
  static logout(context)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(Constants.authToken);
    prefs.remove(Constants.user_device_id);
    Utils.toastMessage('Logout successful');
    Navigator.of(context).pushNamedAndRemoveUntil(route.loginPage, (Route r) => false);
  }
}
