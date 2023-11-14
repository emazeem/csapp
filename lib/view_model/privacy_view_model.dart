import 'package:connect_social/model/CheckPrivacy.dart';
import 'package:connect_social/model/Privacy.dart';
import 'package:connect_social/model/apis/api_response.dart';
import 'package:connect_social/model/directories/privacy_repo.dart';
import 'package:flutter/cupertino.dart';

class PrivacyViewModel extends ChangeNotifier {

  
  Privacy? privacyResponse=Privacy();
  PrivacyRepo _privacyRepo=PrivacyRepo();

  Privacy? get getPrivacy => privacyResponse;
  void setPrivacy(Privacy data) {
    privacyResponse = data;
    notifyListeners();
  }
  ApiResponse _apiResponse=ApiResponse();
  ApiResponse get fetchPrivacyStatus => _apiResponse;

  Future fetchPrivacy(dynamic data,String token) async {
    try{
      _apiResponse = ApiResponse.loading('Fetching privacy');
      dynamic response=await _privacyRepo.fetchPrivacyApi(data,token);
      dynamic json=response['data'];
      privacyResponse=Privacy.fromJson(json);
      _apiResponse = ApiResponse.completed(privacyResponse);
    }catch(e){
      _apiResponse = ApiResponse.error('Please try again.!');
      print(e);
    }
    notifyListeners();
  }

  Future updatePrivacy(dynamic data,String token) async {
    dynamic response=await _privacyRepo.updatePrivacyApi(data,token);
    return response;
  }

  CheckPrivacy? checkPrivacyResponse=CheckPrivacy();

  CheckPrivacy? get getCheckPrivacy => checkPrivacyResponse;
  void setCheckPrivacy(CheckPrivacy data) {
    checkPrivacyResponse = data;
    notifyListeners();
  }

  Future checkPrivacy(dynamic data,String token) async {
    try{
      dynamic response=await _privacyRepo.checkPrivacyApi(data,token);
      dynamic json=response['data'];
      print('json ${json}');
      checkPrivacyResponse=CheckPrivacy.fromJson(json);
    }catch(e){
      print(e);
    }
    notifyListeners();
  }

}