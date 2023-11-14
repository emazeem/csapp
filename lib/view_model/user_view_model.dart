import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/apis/api_response.dart';
import 'package:connect_social/model/directories/other_user_repo.dart';
import 'package:connect_social/model/directories/user_repo.dart';
import 'package:connect_social/utils/Utils.dart';

class UserViewModel extends ChangeNotifier {
  User? userResponse = User();
  UserRepo _userRepo = UserRepo();
  User? get getUser => userResponse;
  void setUser(User newUser) {
    userResponse = newUser;
    notifyListeners();
  }

  void setemptyUser() {
    userResponse = User();
    notifyListeners();
  }

  UserViewModel({this.userResponse});
  Future getUserDetails(dynamic data, String token) async {
    dynamic response = await _userRepo.getUserApi(data, token);
    try {
      response['data']['createdat'] =
          NpDateTime.fromJson(response['data']['createdat']);
      User? us = User.fromJson(response['data']);
      userResponse = us;
      notifyListeners();
    } catch (e) {
      //Utils.toastMessage('${response['message']}');
    }
  }

  ApiResponse fetchFriendStatus = ApiResponse();
  ApiResponse get getFetchFriendStatus => fetchFriendStatus;
  List<User?> _friendsResponse = [];
  List<User?> get getFriends => _friendsResponse;
  void setFriends(List<User> friendlist) {
    _friendsResponse = friendlist;
    notifyListeners();
  }

  Future fetchFriends(dynamic data, String token) async {
    ApiResponse _fetchFriendStatus = ApiResponse.loading('Fetching friend');
    fetchFriendStatus = _fetchFriendStatus;

    final response = await _userRepo.getFriendsApi(data, token);

    try {
      List<User> users = [];
      response['data'].forEach((item) {item['createdat'] = NpDateTime.fromJson(item['createdat']);

        users.add(User.fromJson(item));
      });
      _friendsResponse = [];
      _friendsResponse = users;

      _fetchFriendStatus = ApiResponse.completed(_friendsResponse);
      fetchFriendStatus = _fetchFriendStatus;
      notifyListeners();
    } catch (e) {
      Utils.toastMessage('${response}');
      print(e.toString());
      print(response);
      _fetchFriendStatus = ApiResponse.error('Please try again.!');
      fetchFriendStatus = _fetchFriendStatus;
    }
  }

  ApiResponse _fetchFriendRequestStatus = ApiResponse();
  ApiResponse get getFetchFriendRequestStatus => _fetchFriendRequestStatus;
  List<User?> _friendsRequestResponse = [];
  List<User?> get getFriendsRequest => _friendsRequestResponse;
  void setFriendsRequestResponse(List<User> friendRequestList) {
    _friendsRequestResponse = friendRequestList;
    notifyListeners();
  }

  Future fetchFriendsRequest(dynamic data, String token) async {
    _fetchFriendRequestStatus = ApiResponse.loading('Fetching requests');
    try {
      final response = await _userRepo.getNetworkRequestsApi(data, token);

      List<User> users = [];
      response['data'].forEach((item) {
        users.add(User.fromJson(item['user_from']));
      });
      _friendsRequestResponse = users;
      _fetchFriendRequestStatus =
          ApiResponse.completed(_friendsRequestResponse);
    } catch (e) {
      // Utils.toastMessage('${response['message']}');
      _fetchFriendRequestStatus = ApiResponse.error('Please try again.!');
    }
    notifyListeners();
  }

  List<User?> _searchResponse = [];
  List<User?> get getSearchUser => _searchResponse;
  set setSearchUserResponse(List<User> search) {
    _searchResponse = search;
    notifyListeners();
  }

  Future searchUsers(dynamic data, String token) async {
    var response = await _userRepo.getSearchUsersApi(data, token);
    _searchResponse = [];
    try {
      response['data'].forEach((item) {
        item['createdat'] = NpDateTime.fromJson(item['createdat']);
        _searchResponse.add(User.fromJson(item));
      });
      return _searchResponse;
    } catch (e) {
      Utils.toastMessage('${response['message']}');
    }
  }

  Future changePassword(dynamic data, String token) async {
    dynamic response = await _userRepo.changePasswordApi(data, token);
    print('message ::: ${response}');
    print('message ::: ${response['message']}');
    Utils.toastMessage(response['message']);
  }

  Future messagesMarkAsRead(dynamic data, String token) async {
    dynamic response = await _userRepo.messagesMarkAsReadApi(data, token);
    response = jsonDecode(response);
    return response['message'];
  }

  Future sendFriendRequest(dynamic data, String token) async {
    dynamic response = await _userRepo.sendFriendRequestApi(data, token);
    response = jsonDecode(response);
    return response;
  }

  Future unfriend(dynamic data, String token) async {
    dynamic response = await _userRepo.unfriendApi(data, token);
    response = jsonDecode(response);
    return response;
  }

  Future acceptOrRejectFriendRequest(dynamic data, String token) async {
    dynamic response =
        await _userRepo.acceptOrRejectFriendRequestApi(data, token);
    try {
      response = jsonDecode(response);
      return response;
    } catch (e) {
      Utils.toastMessage('${response['message']}');
    }
  }

  Future sendConnectionRequest(dynamic data, String token) async {
    dynamic response = await _userRepo.sendConnectionRequestApi(data, token);
    response = jsonDecode(response);
    return response;
  }

  Future unConnection(dynamic data, String token) async {
    dynamic response = await _userRepo.unConnectionApi(data, token);
    response = jsonDecode(response);
    return response;
  }

  Future acceptOrRejectConnectionRequest(dynamic data, String token) async {
    dynamic response =
        await _userRepo.acceptOrRejectConnectionRequestApi(data, token);
    try {
      response = jsonDecode(response);
      return response;
    } catch (e) {
      Utils.toastMessage('${response['message']}');
    }
  }

  Future forgetPasswordEmail(dynamic data) async {
    dynamic response = await _userRepo.forgetPasswordEmailApi(data);
    response = jsonDecode(response);
    return response;
  }

// deactive account
  Future deactiveAccount(dynamic data, String token) async {
    dynamic response = await _userRepo.deactivateAccountApi(data, token);
    response = jsonDecode(response);
    return response;
  }

  Future createNewPassword(dynamic data) async {
    dynamic response = await _userRepo.createNewPasswordApi(data);
    response = jsonDecode(response);
    return response;
  }

  List<User?> _blockedUserResponse = [];
  List<User?> get getBlockedUsers => _blockedUserResponse;

  ApiResponse _fetchBlocklistStatus = ApiResponse();
  ApiResponse get getBlocklistStatus => _fetchBlocklistStatus;
  void setBlockedUserResponse(List<User?> blocklist) {
    _blockedUserResponse = blocklist;
    notifyListeners();
  }

  Future blockedUsers(dynamic data, String token) async {
    _fetchBlocklistStatus = ApiResponse.loading('Fetching block list');
    try {
      List<User?> blockedUserResponse = [];
      final response = await _userRepo.getBlockedUsersApi(data, token);
      response['data'].forEach((item) {
        blockedUserResponse.add(User.fromJson(item));
      });
      _blockedUserResponse = blockedUserResponse;
      _fetchBlocklistStatus = ApiResponse.completed(blockedUserResponse);
      notifyListeners();
    } catch (e) {
      _fetchBlocklistStatus = ApiResponse.error('Please try again.!');
      Utils.toastMessage('Error in fetching block list!');
    }
  }

  Future unblockUser(dynamic data, String token) async {
    dynamic response;
    try {
      response = await _userRepo.unblockUserApi(data, token);
      //Utils.toastMessage(response['message']);
    } catch (e) {
      Utils.toastMessage('${e.toString()}');
    }
    return response;
  }

  Future blockUser(dynamic data, String token) async {
    dynamic response;
    try {
      response = await _userRepo.blockUserApi(data, token);
    } catch (e) {
      Utils.toastMessage('${e.toString()}');
    }
    return response;
  }
}

class OtherUserViewModel extends ChangeNotifier {
  User? otherUserResponse = User();
  OtherUserRepo _otherUserRepo = OtherUserRepo();
  OtherUserViewModel({this.otherUserResponse});

  User? get getOtherUser => otherUserResponse;
  void otherUserResponseSetter(User newUser) {
    otherUserResponse = newUser;
    notifyListeners();
  }

  Future getOtherUserDetails(dynamic data, String token) async {
    dynamic response = await _otherUserRepo.getOtherUserApi(data, token);
    try {
      response['data']['createdat'] =
          NpDateTime.fromJson(response['data']['createdat']);
      User? us = User.fromJson(response['data']);
      print('other user ::: ${us}');
      otherUserResponse = us;
      notifyListeners();
    } catch (e) {
      //Utils.toastMessage('${response['message']}');
    }
  }
}
