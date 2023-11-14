import 'package:flutter/material.dart';
import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/Comment.dart';
import 'package:connect_social/model/apis/api_response.dart';
import 'package:connect_social/model/directories/comment_repo.dart';
import 'package:connect_social/model/directories/post_repo.dart';
import 'package:connect_social/utils/Utils.dart';

class CommentViewModel extends ChangeNotifier {

  
  Comment? commentResponse=Comment();
  CommentRepo _commentRepo=CommentRepo();

  CommentViewModel({this.commentResponse});


  List<Comment?> _allComments=[];
  List<Comment?> get getAllComments => _allComments;


  ApiResponse fetchAllCommentStatus=ApiResponse();
  ApiResponse get getAllCommentStatus => fetchAllCommentStatus;

  void setAllComments(List<Comment> comments) {
    _allComments = comments;
    notifyListeners();
  }

  Future fetchAllComments(dynamic data,String token) async {
    ApiResponse _fetchAllCommentStatus=ApiResponse.loading('Fetching comments..');
    fetchAllCommentStatus = _fetchAllCommentStatus;

    final response =  await _commentRepo.getAllCommentsApi(data,token);
    try{
      List<Comment> allComments=[];
      response['data'].forEach((item) {
        item['createdat']=NpDateTime.fromJson(item['createdat']);
        item['user']=User.fromJson(item['user']);
        allComments.add(Comment.fromJson(item));
      });
      _allComments=allComments;

      _fetchAllCommentStatus = ApiResponse.completed(_allComments);
      fetchAllCommentStatus = _fetchAllCommentStatus;

      notifyListeners();
    }catch(e){
      _fetchAllCommentStatus = ApiResponse.error('Please try again.!');
      fetchAllCommentStatus = _fetchAllCommentStatus;
      //Utils.toastMessage('${response['message']}');
    }
  }
  Future storeComments(dynamic data,String token) async {
    final response =  await _commentRepo.storeCommentApi(data,token);
    return response;
  }
}