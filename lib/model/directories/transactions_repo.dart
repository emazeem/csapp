import 'dart:convert';

import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/services/BaseApiServices.dart';
import 'package:connect_social/model/services/NetworkApiServices.dart';
import 'package:connect_social/res/app_url.dart';

class TransactionsRepo {
  BaseApiServices _apiServices = NetworkApiServices();
  Future<dynamic> fetchTransactionsApi(data,token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(AppUrl.fetchWalletTransactions, data,token);
      Map res = {
        'message': response['message'],
        'data': response['data']['transactions'],
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
  Future<dynamic> fetchMyBalance(data,token) async {
    try {
      dynamic response = await _apiServices.getPostAuthApiResponse(AppUrl.fetchWalletMyBalance, data,token);
      Map res = {
        'message': response['message'],
        'data': response['data'],
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