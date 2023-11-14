import 'package:flutter/material.dart';
import 'package:connect_social/model/Like.dart';
import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/Comment.dart';
import 'package:connect_social/model/directories/comment_repo.dart';
import 'package:connect_social/model/directories/like_repo.dart';
import 'package:connect_social/model/directories/post_repo.dart';
import 'package:connect_social/utils/Utils.dart';

class LikeViewModel extends ChangeNotifier {

  
  Like? likeResponse=Like();
  LikeRepo _likeRepo=LikeRepo();

  LikeViewModel({this.likeResponse});


  List<Like?> _allLikes=[];
  List<Like?> get getAllLikes => _allLikes;

  void setAllComments(List<Like> like) {
    _allLikes = like;
    notifyListeners();
  }

  Future fetchAllLikes(dynamic data,String token) async {
    final response =  await _likeRepo.fetchLikeApi(data,token);
    print(response['data']);
    try{
      List<Like?> allLikes=[];
      response['data'].forEach((item) {
        item['user']=User.fromJson(item['user']);
        allLikes.add(Like.fromJson(item));
      });
      _allLikes=allLikes;
      notifyListeners();
    }catch(e){
      //Utils.toastMessage('${response['message']}');
    }

  }


  Future storeLike(dynamic data,String token) async {
    dynamic response =  await _likeRepo.storeLikeApi(data,token);
    try{
       return response;
    }catch(e){
      print(response);
    }
  }

}