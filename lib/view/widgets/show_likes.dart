import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/Post.dart';
import 'package:connect_social/model/Like.dart';
import 'package:connect_social/model/User.dart';
import 'package:http/http.dart' as http;
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/other_profile.dart';
import 'package:connect_social/view_model/auth_token_view_model.dart';
import 'package:connect_social/view_model/comment_view_model.dart';
import 'package:connect_social/view_model/like_view_model.dart';
import 'package:connect_social/view_model/post_view_model.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connect_social/model/Comment.dart';

class ShowLikeCard extends StatefulWidget {
  final Post? post;

  const ShowLikeCard(this.post);

  //const ShowLikeCard({Key? key,required this.post}) : super(key: key);
  @override
  State<ShowLikeCard> createState() => _ShowLikeCardState();
}

class _ShowLikeCardState extends State<ShowLikeCard> {

  List<Comment> comment = [];
  List<Like> like = [];
  var totalComment = 0;
  String? authToken;
  int? AuthId;

  


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      AuthId = await AppSharedPref.getAuthId();

      var likeData = {'post': '${widget.post?.id}'};
      Provider.of<LikeViewModel>(context, listen: false).setAllComments([]);
      Provider.of<LikeViewModel>(context, listen: false).fetchAllLikes(likeData, '${authToken}');

    });
  }

  @override
  Widget build(BuildContext context) {
    List<Like?> likes = Provider.of<LikeViewModel>(context).getAllLikes;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Constants.titleImage2(context),
      ),
      body: Container(
        child: Material(
          child: Container(
            color: Constants.np_bg_clr,
            child: Padding(
              padding: EdgeInsets.only(left: Constants.np_padding_only,
                  right: Constants.np_padding_only,
                  top: Constants.np_padding_only),
              child: Card(
                shadowColor: Colors.black12,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  height: double.infinity,
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'All Reactions',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Divider(),
                      for(var c in likes) popupLike(c!)
                    ],
                  ),
                ),
              ),
            ),
          ),

        ),
      ),
    );
  }

  Widget popupLike(Like like) {
    return Padding(padding: EdgeInsets.all(10),
      child: Row(
        children: [
          InkWell(
            onTap: ()=>{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtherProfileScreen(like.user?.id)))
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network('${Constants.profileImage(like.user)}', width: 30, height: 30,fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Constants.defaultImage(30.0);
                  },
                )
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: ()=>{
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtherProfileScreen(like.user?.id)))
                    },
                    child: Text('${like.user?.fname} ${like.user?.lname}',style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Image.asset('assets/images/${like.type}.png',width: 20,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
