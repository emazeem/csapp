import 'dart:convert';

import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/services/BaseApiServices.dart';
import 'package:connect_social/model/services/NetworkApiServices.dart';
import 'package:connect_social/res/app_url.dart';

class GalleryRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> getGalleryImages(data,token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(AppUrl.fetchGalleryImages, data,token);
      Map res = {
        'message': response['message'],
        'data': response['data']['allmedia'],
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

}