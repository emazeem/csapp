import 'dart:convert';

import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/services/BaseApiServices.dart';
import 'package:connect_social/model/services/NetworkApiServices.dart';
import 'package:connect_social/res/app_url.dart';

class NotificationRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> getNotifications(data,token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(AppUrl.fetchNotifications, data,token);
      Map res = {
        'message': response['message'],
        'data': response['data']['notifications'],
      };
      return res;
    }
    catch (e) {
      Map res = {
        'message': e.toString(),
        'data':'',
      };
      return jsonEncode(res);
    }
  }
  Future<dynamic> markAllNotificationAsRead(data,token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(AppUrl.markAllNotificationAsRead, data,token);
      Map res = {
        'message': response['message'],
        'data': response['data']['notifications'],
      };
      return res;
    }
    catch (e) {
      Map res = {
        'message': e.toString(),
        'data':'',
      };
      return jsonEncode(res);
    }
  }

}