import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/services/BaseApiServices.dart';
import 'package:connect_social/model/services/NetworkApiServices.dart';
import 'package:connect_social/res/app_url.dart';

class UserRepo {
  BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> getUserApi(dynamic data, String token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.fetchUser, data, token);
      Map res = {
        'message': response['message'],
        'data': response['data']['user_data'],
      };
      return res;
    } catch (e) {
      Map res = {
        'message': e.toString(),
      };
      return res;
    }
  }

  Future<dynamic> getFriendsApi(data, token) async {
    dynamic response = await _apiServices.getPostAuthApiResponse(
        AppUrl.fetchFriends, data, token);
    try {
      Map<String, dynamic> res = {
        'message': response['message'],
        'data': response['data']['network'],
      };
      return res;
    } catch (e) {
      Map res = {
        'message': e.toString(),
      };
      return jsonEncode(res);
    }
  }

  Future<dynamic> getNetworkRequestsApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.networkRequests, data, token);
      Map<String, dynamic> res = {
        'message': response['message'],
        'data': response['data']['requests'],
      };
      return res;
    } catch (e) {
      Map res = {
        'message': e.toString(),
      };
      return jsonEncode(res);
    }
  }

  Future<dynamic> getSearchUsersApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.fetchSearchUsers, data, token);
      Map<String, dynamic> res = {
        'success': true,
        'message': response['message'],
        'data': response['data']['user_detail'],
      };
      return res;
    } catch (e) {
      Map<String, dynamic> res = {
        'success': false,
        'message': e.toString(),
      };
      return res;
    }
  }

  Future<dynamic> changePasswordApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.changePassword, data, token);
      Map<String, dynamic> res = {
        'message': response['message'],
        'data': response['data'],
      };
      return res;
    } catch (e) {
      Map res = {
        'message': e.toString(),
      };
      return res;
    }
  }

  Future<dynamic> messagesMarkAsReadApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.markAllMessagesAsRead, data, token);
      Map<String, dynamic> res = {
        'message': response['message'],
        'data': response['data']['action'],
      };
      return jsonEncode(res);
    } catch (e) {
      Map res = {
        'message': e.toString(),
      };
      return jsonEncode(res);
    }
  }

  Future<dynamic> sendFriendRequestApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.sendFriendRequest, data, token);
      Map<String, dynamic> res = {
        'message': response['message'],
        'success': true
      };
      return jsonEncode(res);
    } catch (e) {
      Map res = {'message': e.toString(), 'success': false};
      return jsonEncode(res);
    }
  }

  Future<dynamic> unfriendApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.unfriend, data, token);
      Map<String, dynamic> res = {
        'message': response['message'],
        'success': true
      };
      return jsonEncode(res);
    } catch (e) {
      Map res = {'message': e.toString(), 'success': false};
      return jsonEncode(res);
    }
  }

  Future<dynamic> unConnectionApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.unConnection, data, token);
      Map<String, dynamic> res = {
        'message': response['message'],
        'success': true
      };
      return jsonEncode(res);
    } catch (e) {
      Map res = {'message': e.toString(), 'success': false};
      return jsonEncode(res);
    }
  }

  Future<dynamic> acceptOrRejectFriendRequestApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.acceptOrRejectFriendRequest, data, token);
      Map<String, dynamic> res = {
        'message': response['message'],
        'success': true
      };
      return jsonEncode(res);
    } catch (e) {
      Map res = {'message': e.toString(), 'success': false};
      return jsonEncode(res);
    }
  }

  Future<dynamic> sendConnectionRequestApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.sendConnectionRequest, data, token);
      Map<String, dynamic> res = {
        'message': response['message'],
        'success': true
      };
      return jsonEncode(res);
    } catch (e) {
      Map res = {'message': e.toString(), 'success': false};
      return jsonEncode(res);
    }
  }

  Future<dynamic> acceptOrRejectConnectionRequestApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.acceptOrRejectConnectionRequest, data, token);
      Map<String, dynamic> res = {
        'message': response['message'],
        'success': true
      };
      return jsonEncode(res);
    } catch (e) {
      Map res = {'message': e.toString(), 'success': false};
      return jsonEncode(res);
    }
  }

  //deactivate account
  Future<dynamic> deactivateAccountApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.deactivateAccount, data, token);
      Map<String, dynamic> res = {
        'message': response['message'],
        'success': true
      };
      return jsonEncode(res);
    } catch (e) {
      Map res = {'message': e.toString(), 'success': false};
      return jsonEncode(res);
    }
  }

  Future<dynamic> forgetPasswordEmailApi(data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.forgetPassword, data);
      Map<String, dynamic> res = {
        'message': response['message'],
        'success': true
      };
      return jsonEncode(res);
    } catch (e) {
      Map res = {'message': e.toString(), 'success': false};
      return jsonEncode(res);
    }
  }

  Future<dynamic> createNewPasswordApi(data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.createNewPassword, data);
      Map<String, dynamic> res = {
        'message': response['message'],
        'success': true
      };
      return jsonEncode(res);
    } catch (e) {
      Map res = {'message': e.toString(), 'success': false};
      return jsonEncode(res);
    }
  }

  Future<dynamic> getBlockedUsersApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.fetchBlocklist, data, token);
      Map<String, dynamic> res = {
        'message': response['message'],
        'data': response['data']['blocked-users'],
      };
      return res;
    } catch (e) {
      Map res = {'message': e.toString(), 'data': ''};
      return res;
    }
  }

  Future<dynamic> unblockUserApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.unblockUser, data, token);
      Map<String, dynamic> res = {
        'message': response['message'],
        'data': response['data'],
      };
      return res;
    } catch (e) {
      Map res = {'message': e.toString(), 'data': ''};
      return res;
    }
  }

  Future<dynamic> blockUserApi(data, token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(
          AppUrl.blockUser, data, token);
      Map<String, dynamic> res = {
        'message': response['message'],
        'data': response['data'],
      };
      return res;
    } catch (e) {
      Map res = {'message': e.toString(), 'data': ''};
      return res;
    }
  }
}
