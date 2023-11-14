import 'dart:convert';

import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/services/BaseApiServices.dart';
import 'package:connect_social/model/services/NetworkApiServices.dart';
import 'package:connect_social/res/app_url.dart';

class PrivacyRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> fetchPrivacyApi(dynamic data,String token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(AppUrl.fetchPrivacy, data,token);
      Map res = {
        'success':true,
        'message': response['message'],
        'data': response['data'],
      };
      return res;
    }
    catch (e) {
      print(e.toString());

      Map<String,dynamic> res = {
        'success':false,
        'data':'',
        'message': e.toString(),
      };
      return jsonEncode(res);
    }
  }
  Future<dynamic> updatePrivacyApi(dynamic data,String token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(AppUrl.updatePrivacy, data,token);
      Map res = {
        'success':true,
        'message': response['message'],
        'data': response['data'],
      };
      return res;
    }
    catch (e) {
      print(e.toString());

      Map<String,dynamic> res = {
        'success':false,
        'data':'',
        'message': e.toString(),
      };
      return jsonEncode(res);
    }
  }
  Future<dynamic> checkPrivacyApi(dynamic data,String token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(AppUrl.checkPrivacy, data,token);
      Map res = {
        'success':true,
        'message': response['message'],
        'data': response['data'],
      };
      return res;
    }
    catch (e) {
      print(e.toString());

      Map<String,dynamic> res = {
        'success':false,
        'data':'',
        'message': e.toString(),
      };
      return jsonEncode(res);
    }
  }



}