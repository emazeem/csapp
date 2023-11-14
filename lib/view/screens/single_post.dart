import 'package:flutter/material.dart';
import 'package:connect_social/model/Gallery.dart';
import 'package:connect_social/model/Post.dart';
import 'package:connect_social/model/apis/api_response.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/widgets/layout.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/view/widgets/show_post.dart';
import 'package:connect_social/view_model/gallery_view_model.dart';
import 'package:connect_social/view_model/post_view_model.dart';
import 'package:provider/provider.dart';

class SinglePostScreen extends StatefulWidget {
  final int? postId;
  const SinglePostScreen(this.postId);

  @override
  State<SinglePostScreen> createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  var authId;
  String? authToken;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();
      Map data = {'id': '${widget.postId}'};
      Provider.of<PostViewModel>(context, listen: false).setSinglePost(Post());
      Provider.of<PostViewModel>(context, listen: false)
          .fetchSinglePost(data, '${authToken}');
    });
  }

  @override
  Widget build(BuildContext context) {
    PostViewModel _postViewModel = Provider.of<PostViewModel>(context);
    Post? post = _postViewModel.getSinglePost;
    Widget _child = Center(
      child: Utils.LoadingIndictorWidtet(),
    );
    //return NPLayout(ShowPostCard(post));

    if (_postViewModel.getSinglePostStatus.status == Status.IDLE) {
      if (post?.is_deleted == false) {
        _child = ShowPostCard(post!);
      } else {
        _child = Center(
          child: Text('Post not found'),
        );
      }
    } else if (_postViewModel.getSinglePostStatus.status == Status.BUSY) {
      _child = Center(
        child: Utils.LoadingIndictorWidtet(),
      );
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Constants.titleImage2(context),
        ),
        body: _child
        //body: ShowPostCard(post!)
        );
  }
}
