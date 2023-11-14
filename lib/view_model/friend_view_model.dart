import 'package:flutter/material.dart';
import 'package:connect_social/model/Friend.dart';
import 'package:connect_social/model/Like.dart';
import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/Comment.dart';
import 'package:connect_social/model/directories/comment_repo.dart';
import 'package:connect_social/model/directories/friend_repo.dart';
import 'package:connect_social/model/directories/like_repo.dart';
import 'package:connect_social/model/directories/post_repo.dart';

class FriendViewModel extends ChangeNotifier {
  FriendRepo _friendRepo = FriendRepo();

  ActionButtonStatus? actionBtnStatus = new ActionButtonStatus();
  ActionButtonStatus? get getActionButtonStatus => actionBtnStatus;

  setActionBtnStatus(ActionButtonStatus? fir) {
    actionBtnStatus = fir;
    notifyListeners();
  }
  Future fetchActionButtonStatus(dynamic data, String token) async {
    dynamic response = await _friendRepo.friendStatusApi(data, token);
    try{
      ActionButtonStatus _actionBtnStatus = new ActionButtonStatus();
      dynamic StatusResponse = response['data'];
      print('StatusResponse ${StatusResponse}');
      _actionBtnStatus.showFriendRequestBtn=StatusResponse['show_friend_requests_btn'];
      _actionBtnStatus.showUnfriendBtn=StatusResponse['is_friend'];
      _actionBtnStatus.showFriendAcceptRejectBtn=StatusResponse['show_friend_accept_reject_btn'];
      _actionBtnStatus.showCancelFriendRequestBtn=StatusResponse['show_friend_cancel_request_btn'];

      _actionBtnStatus.showConnectionRequestBtn=StatusResponse['show_connection_requests_btn'];
      _actionBtnStatus.showUnConnectionBtn=StatusResponse['is_connection'];
      _actionBtnStatus.showConnectionAcceptRejectBtn=StatusResponse['show_connection_accept_reject_btn'];
      _actionBtnStatus.showCancelConnectionRequestBtn=StatusResponse['show_connection_cancel_request_btn'];

      actionBtnStatus=_actionBtnStatus;
    }catch(e){
      print('Error');
    }

    notifyListeners();
  }
}

class ActionButtonStatus {
  bool? showFriendRequestBtn=false;
  bool? showCancelFriendRequestBtn=false;
  bool? showUnfriendBtn=false;
  bool? showFriendAcceptRejectBtn=false;

  bool? showConnectionRequestBtn=false;
  bool? showCancelConnectionRequestBtn=false;
  bool? showUnConnectionBtn=false;
  bool? showConnectionAcceptRejectBtn=false;


  ActionButtonStatus({
    this.showFriendRequestBtn,
    this.showCancelFriendRequestBtn,
    this.showUnfriendBtn,
    this.showFriendAcceptRejectBtn,


    this.showConnectionRequestBtn,
    this.showCancelConnectionRequestBtn,
    this.showUnConnectionBtn,
    this.showConnectionAcceptRejectBtn,

  });
}
