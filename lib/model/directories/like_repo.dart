import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/services/BaseApiServices.dart';
import 'package:connect_social/model/services/NetworkApiServices.dart';
import 'package:connect_social/res/app_url.dart';

class LikeRepo {
  BaseApiServices _apiServices = NetworkApiServices();
  Future<dynamic> fetchLikeApi(data,token) async {
    dynamic response = await _apiServices.getPostAuthApiResponse(AppUrl.fetchLikes, data,token);
    try {
      Map res = {
        'message': response['message'],
        'data': response['data']['like'],
      };
      return res;
    }
    catch (e) {
      Map res = {
        'message': e.toString(),
      };
      return jsonEncode(res);
    }
  }
  Future<dynamic> storeLikeApi(data,token) async {
    dynamic response = await _apiServices.getPostAuthApiResponse(AppUrl.storeLikes, data,token);
    try {
      Map res = {
        'response': response,
        'success':true,
      };
      return res;
    }
    catch (e) {
      Map res = {
        'success':false,
        'response': '${e.toString()}',
      };
      return res;
    }
  }

}