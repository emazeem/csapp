import 'dart:convert';
import 'dart:developer';

import 'package:logger/logger.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/services/BaseApiServices.dart';
import 'package:connect_social/model/services/NetworkApiServices.dart';
import 'package:connect_social/res/app_url.dart';
import 'package:http/http.dart' as http;

import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'dart:io';

class PostRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> getPublicPostApi(data, token) async {
    dynamic response = await _apiServices.getPostAuthApiResponse(
        AppUrl.fetchAllTwoPosts, data, token);
    try {
      Map res = {
        'message': response['message'],
        'data': response['data']['allposts'],
      };
      return res;
    } catch (e) {
      Map res = {
        'message': e.toString(),
      };
      return jsonEncode(res);
    }
  }

  Future<dynamic> fetchSinglePostApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.fetchSinglePost, data, token);
      Map res = {
        'message': response['message'],
        'data': response['data']['post'],
      };
      return res;
    } catch (e) {
      Map res = {
        'message': e.toString(),
      };
      return jsonEncode(res);
    }
  }

  Future<dynamic> reportPostApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.reportPosts, data, token);
      Map res = {
        'message': response['message'],
        'data': response['data'],
      };
      return res;
    } catch (e) {
      Map res = {
        'message': '${e.toString()}',
      };
      return jsonEncode(res);
    }
  }

  Future<dynamic> getMyPostApi(data, token) async {
    dynamic response = await _apiServices.getPostAuthApiResponse(
        AppUrl.fetchMyPosts, data, token);
    try {
      Map res = {
        'message': response['message'],
        'data': response['data']['allposts'],
      };
      return res;
    } catch (e) {
      var logger = Logger();
      logger.d("HTML ERROR: ${response}");

      Map res = {
        'message': e.toString(),
      };
      return jsonEncode(res);
    }
  }

  Future<dynamic> deleteMyPostApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.deleteMyPosts, data, token);
      Map res = {
        'message': response['message'],
        'data': response['data']['post'],
      };
      return res;
    } catch (e) {
      Map res = {
        'message': e.toString(),
      };
      return jsonEncode(res);
    }
  }

  Future<dynamic> createPostApi(data, token) async {
    try {
      dynamic response;
      if (data['file_type'] == 'image') {
        dynamic file = data['attachment'];
        dynamic path = data['image_path'];

        var stream =
            new http.ByteStream(DelegatingStream.typed(file.openRead()));
        var length = await file.length();
        Map<String, String> headers = {
          "Accept": "application/json",
          "Authorization": "Bearer " + token
        };

        var uri = Uri.parse(AppUrl.createPost);
        var request = new http.MultipartRequest("POST", uri);
        var multipartFileSign = new http.MultipartFile(
            data['attachment'].toString().toLowerCase(), stream, length,
            filename: basename(path));
        request.files.add(multipartFileSign);
        request.headers.addAll(headers);

        request.fields['details'] = '${data['details']}';
        request.fields['user'] = '${data['user']}';
        request.fields['privacy'] = '${data['privacy']}';
        request.fields['file_type'] = '${data['file_type']}';

        response = await request.send();
      } else {
        response = await _apiServices.getPostAuthApiResponse(
            AppUrl.createPost, data, token);
      }

      Map res = {
        'message': response['message'],
        'success': true,
      };
      return res;
    } catch (e) {
      Map res = {
        'message': e.toString(),
        'success': false,
      };
      return jsonEncode(res);
    }
  }
}
