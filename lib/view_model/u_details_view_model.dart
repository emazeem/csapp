import 'package:connect_social/model/apis/api_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/UDetails.dart';
import 'package:connect_social/model/directories/u_details_repo.dart';
import 'package:connect_social/res/app_url.dart';

class UserDetailsViewModel extends ChangeNotifier {
  UserDetail? detailsResponse = UserDetail();
  UserDetailRepo _detailsRepo = UserDetailRepo();

  UserDetail? get getDetails => detailsResponse;
  void setDetailsResponse(UserDetail newDetails) {
    detailsResponse = newDetails;
    notifyListeners();
  }

  //set empty response
  void setEmptyDetailsResponse() {
    detailsResponse = UserDetail();
    notifyListeners();
    print('talha:: setEmptyDetailsResponse: $detailsResponse');
  }

  UserDetailsViewModel({this.detailsResponse});

  ApiResponse _userDetailsFetchStatus = ApiResponse();
  ApiResponse get getUserDetailStatus => _userDetailsFetchStatus;

  Future getUserDetails(dynamic data, String token) async {
    _userDetailsFetchStatus = ApiResponse.loading('Fetching user details');
    try {
      dynamic response = await _detailsRepo.getUserDetailsApi(data, token);

      response['data']['createdat'] =
          NpDateTime.fromJson(response['data']['createdat']);
      detailsResponse = UserDetail.fromJson(response['data']);
      _userDetailsFetchStatus = ApiResponse.completed(detailsResponse);
    } catch (e) {
      _userDetailsFetchStatus = ApiResponse.error('Please try again.!');
      print(e);
    }
    notifyListeners();
  }

  Future updateSocialInfo(dynamic data, String token) async {
    dynamic response = await _detailsRepo.updateSocialInfoApi(data, token);
    return response;
  }
}
