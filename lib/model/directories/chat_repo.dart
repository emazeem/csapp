import 'dart:convert';

import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/services/BaseApiServices.dart';
import 'package:connect_social/model/services/NetworkApiServices.dart';
import 'package:connect_social/res/app_url.dart';

class ChatRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> getAllMessage(data,token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(AppUrl.fetchAllMessages, data,token);

      Map res = {
        'data': response['data'],
        'success':true,
      };
      return res;
    }
    catch (e) {
      Map res = {
        'success':false,
        'message': e.toString(),
      };
      return res;
    }
  }
  Future<dynamic> storeMessage(data,token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(AppUrl.storeMessages, data,token);
      Map res = {
        'sent': true,
        'message': response['message'],
        'data': response['data']['message'],
      };

      return res;
    }
    catch (e) {
      Map res = {
        'sent': false,
        'message': e.toString(),
      };
      return jsonEncode(res);
    }
  }


}