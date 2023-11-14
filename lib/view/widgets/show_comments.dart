import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/Post.dart';
import 'package:connect_social/model/Like.dart';
import 'package:connect_social/model/User.dart';
import 'package:http/http.dart' as http;
import 'package:connect_social/model/apis/api_response.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/other_profile.dart';
import 'package:connect_social/view_model/comment_view_model.dart';
import 'package:connect_social/view_model/like_view_model.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:connect_social/model/Comment.dart';

class ShowCommentCard extends StatefulWidget {
  final Post? post;

  const ShowCommentCard(this.post);

  //const ShowCommentCard({Key? key,required this.post}) : super(key: key);
  @override
  State<ShowCommentCard> createState() => _ShowCommentCardState();
}

class _ShowCommentCardState extends State<ShowCommentCard> {
  List<Comment> comment = [];
  final _commentTxtController = TextEditingController();

  String? authToken;
  int? AuthId;

  List<Comment?> newComments = [];
  bool commentstored = false;
  bool savingcomment = false;

  Future<void> _pullComments(ctx) async {
    Provider.of<CommentViewModel>(context, listen: false)
        .fetchAllComments({'id': '${widget.post?.id}'}, '${authToken}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      AuthId = await AppSharedPref.getAuthId();
      Provider.of<UserViewModel>(context, listen: false)
          .getUserDetails({'id': '${AuthId}'}, '${authToken}');

      _pullComments(context);
      Provider.of<CommentViewModel>(context, listen: false).setAllComments([]);
    });
  }

  @override
  Widget build(BuildContext context) {
    User? authUser = Provider.of<UserViewModel>(context).getUser;
    CommentViewModel _commentViewModal = Provider.of<CommentViewModel>(context);
    List<Comment?> comments =
        Provider.of<CommentViewModel>(context).getAllComments;

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Constants.titleImage2(context)),
      body: Container(
        child: Material(
          child: Container(
            color: Constants.np_bg_clr,
            child: Padding(
              padding: EdgeInsets.only(
                  left: Constants.np_padding_only,
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
                          'All Comments',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        height: 70,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    '${Constants.profileImage(authUser)}',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Constants.defaultImage(40.0);
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: SizedBox(
                                height: 40,
                                child: TextField(
                                  controller: _commentTxtController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                      ),
                                      hintText: 'Write something ...',
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5)),
                                ),
                              )),
                              savingcomment
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Utils.LoadingIndictorWidtet())
                                  : IconButton(
                                      icon: const Icon(Icons.add),
                                      color: Colors.black,
                                      tooltip: 'Add Comment',
                                      onPressed: () async {
                                        savingcomment = true;

                                        if (_commentTxtController
                                            .text.isEmpty) {
                                          Utils.toastMessage(
                                              'Comment is required!');
                                          savingcomment = false;
                                        } else {
                                          Map commentStoreData = {
                                            'comment':
                                                _commentTxtController.text,
                                            'post_id': '${widget.post?.id}',
                                            'user_id': '${AuthId}',
                                          };
                                          setState(() {
                                            commentstored = true;
                                          });
                                          Map response = await _commentViewModal
                                              .storeComments(commentStoreData,
                                                  '${authToken}');

                                          setState(() {
                                            var json = response['data'];
                                            Comment newCommnt = new Comment(
                                              id: json['id'],
                                              user_id:
                                                  int.parse(json['user_id']),
                                              post_id:
                                                  int.parse(json['post_id']),
                                              text: json['text'],
                                              createdat: NpDateTime.fromJson(
                                                  json['createdat']),
                                              user: User(
                                                id: authUser?.id,
                                                email: authUser?.email,
                                                profile: authUser?.profile,
                                                fname: authUser?.fname,
                                                lname: authUser?.lname,
                                              ),
                                            );

                                            if (comments.length == 0) {
                                              _pullComments(context);
                                            } else {
                                              newComments.add(newCommnt);
                                            }
                                          });

                                          if (response['success'] == true) {
                                            _commentTxtController.text = '';

                                            Utils.toastMessage(
                                                'Your comment has been added');
                                            savingcomment = false;
                                          } else {
                                            //Utils.toastMessage('Comment added successfully!!!');
                                          }
                                        }

                                        //commentStore(widget.post.id);
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      for (var c in newComments.reversed) popupComment(c!),
                      if (_commentViewModal.getAllCommentStatus.status ==
                          Status.IDLE) ...[
                        if (comments.length == 0) ...[
                          Center(
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(Constants.np_padding),
                              child: Text(
                                'No comments',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        ] else ...[
                          for (var c in comments) popupComment(c!),
                        ]
                      ] else if (_commentViewModal.getAllCommentStatus.status ==
                          Status.BUSY) ...[
                        Utils.LoadingIndictorWidtet(),
                      ],
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

  Widget popupComment(Comment comment) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          InkWell(
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OtherProfileScreen(comment.user?.id)))
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  '${Constants.profileImage(comment.user)}',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Constants.defaultImage(30.0);
                  },
                )),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OtherProfileScreen(comment.user?.id)))
                    },
                    child: Text(
                      '${comment.user?.fname} ${comment.user?.lname}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text('${comment.text}')
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${comment.createdat?.h}:${comment.createdat?.i}${comment.createdat?.a}',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text(
                    '${comment.createdat?.m}-${comment.createdat?.d}-${comment.createdat?.Y}',
                    style: TextStyle(fontSize: 10, color: Colors.grey))
              ],
            ),
          )
        ],
      ),
    );
  }
}
