import 'dart:convert';

import 'package:connect_social/model/services/BaseApiServices.dart';
import 'package:connect_social/model/services/NetworkApiServices.dart';
import 'package:connect_social/res/app_url.dart';

class AuthRepo {
  BaseApiServices _apiServices=NetworkApiServices();
  Future<String> loginApi(dynamic data) async{
    try{
      dynamic response=await _apiServices.getPostApiResponse(AppUrl.loginUrl, data);
      Map res={
        'login':true,
        'message':response['message'],
        'data':response['data'],
      };
      return jsonEncode(res);
    }
    catch(e){
      Map res={
        'login':false,
        'message':e.toString(),
      };
      return jsonEncode(res);
    }
  }
  Future<String> registerApi(dynamic data) async{
    try{
      dynamic response=await _apiServices.getPostApiResponse(AppUrl.registeUrl, data);
      Map res={
        'register':true,
        'message':response['message'],
        'data':response['data'],
      };
      return jsonEncode(res);
    }
    catch(e){
      Map res={
        'register':false,
        'message':e.toString(),
      };
      return jsonEncode(res);
    }
  }
  Future<String> afterRejectionApi(dynamic data,authToken) async{
    try{

      dynamic response=await _apiServices.getPostAuthApiResponse(AppUrl.afterRejectionUrl, data,authToken);
      Map res={
        'register':true,
        'message':response['message'],
        'data':response['data'],
      };
      return jsonEncode(res);
    }
    catch(e){
      Map res={
        'register':false,
        'message':e.toString(),
      };
      return jsonEncode(res);
    }
  }

  Future<String> verifyEmailApi(dynamic data) async{
    try{
      dynamic response=await _apiServices.getPostApiResponse(AppUrl.verifyEmail, data);
      Map res={
        'success':true,
        'message':response['message'],
        'data':response['data'],
      };
      return jsonEncode(res);
    }
    catch(e){
      Map res={
        'success':false,
        'message':'${e.toString()}',
        'data':'',
      };
      return jsonEncode(res);
    }
  }


}
