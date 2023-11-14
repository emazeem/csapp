import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_social/view/widgets/report_post.dart';
import 'package:connect_social/view/widgets/show_likes.dart';
import 'package:connect_social/view/widgets/showimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:connect_social/model/Comment.dart';
import 'package:connect_social/model/Like.dart';
import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/Post.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/res/app_url.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/other_profile.dart';
import 'package:connect_social/view/screens/profile.dart';
import 'package:connect_social/view/screens/webview/audio.dart';
import 'package:connect_social/view/screens/webview/video.dart';
import 'package:connect_social/view/screens/widgets/layout.dart';
import 'package:connect_social/view/widgets/show_comments.dart';
import 'package:connect_social/view_model/comment_view_model.dart';
import 'package:connect_social/view_model/like_view_model.dart';
import 'package:connect_social/view_model/post_view_model.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'package:any_link_preview/any_link_preview.dart';

class ShowPostCard extends StatefulWidget {
  final Post? post;

  const ShowPostCard(this.post);

  @override
  State<ShowPostCard> createState() => _ShowPostCardState();
}

class _ShowPostCardState extends State<ShowPostCard>
    with WidgetsBindingObserver {
  String audioURL = '';
  String videoURL = '';
  List<Comment> comment = [];
  List<Like> like = [];
  int? totalComment = 0;
  bool? ownreacted;
  int? totalLikes = 0;
  final _commentTxtController = TextEditingController();
  String? authToken;
  int? AuthId;
  Color likeColor = Colors.black;
  String fileName = '';
  Future<void>? _launched;
  bool showReactionPopup = false;
  bool showPost = true;
  List<String> reactions = [
    'like',
    'love',
    'care',
    'haha',
    'wow',
    'sad',
    'angry'
  ];
  String? selectedreaction;
  List<Widget> reactionWidget = [];
  Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.post?.reacted_value == null) {
      selectedreaction = 'liked';
    } else {
      selectedreaction = widget.post?.reacted_value;
    }
    if (widget.post?.is_liked == 1) {
      ownreacted = true;
    } else {
      ownreacted = false;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      AuthId = await AppSharedPref.getAuthId();
      Provider.of<UserViewModel>(context, listen: false)
          .getUserDetails({'id': '${AuthId}'}, '${authToken}');
      var data = {'id': '${widget.post?.id}'};
      Provider.of<CommentViewModel>(context, listen: false)
          .fetchAllComments(data, '${authToken}');
      var likeData = {'post': '${widget.post?.id}'};
      Provider.of<LikeViewModel>(context, listen: false)
          .fetchAllLikes(likeData, '${authToken}');
    });
    Provider.of<PostViewModel>(context, listen: false);
    totalLikes = widget.post?.likes;
    totalComment = widget.post?.comments;

    likeColor =
        (widget.post?.is_liked == 1) ? Constants.np_yellow : Colors.black;
    //_getImage();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  deletePost(id) async {
    setState(() {
      showPost = false;
    });
    await Provider.of<PostViewModel>(context, listen: false)
        .deletePost({'id': '${id}'}, '${authToken}');
  }

  reportPost(id) {
    print('report post');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReportPost(widget.post?.id)));
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (Platform.isAndroid) {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch $url';
      }
    } else {
      final UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;
      if (await launcher.canLaunch(url.toString())) {
        await launcher.launch(
          url.toString(),
          useSafariVC: true,
          useWebView: true,
          enableJavaScript: true,
          enableDomStorage: false,
          universalLinksOnly: false,
          headers: <String, String>{'my_header_key': 'my_header_value'},
        );
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentTxtController.dispose();
  }

  Widget reactionWidgetLayout(reaction) {
    return Container(
      padding: EdgeInsets.all(3),
      child: InkWell(
        onTap: () async {
          print(ownreacted);

          if (selectedreaction == reaction) {
            setState(() {
              //unlike
              print('unlike');
              totalLikes = totalLikes! - 1;
              selectedreaction = 'liked';
              ownreacted = false;
            });
          } else {
            if (ownreacted == false) {
              setState(() {
                selectedreaction = reaction;
                totalLikes = totalLikes! + 1;
                ownreacted = true;
              });
            } else if (ownreacted == true) {
              setState(() {
                selectedreaction = reaction;
              });
            }
          }
          setState(() {
            showReactionPopup = false;
          });
          Map likeStoreData = {
            'post': '${widget.post?.id}',
            'user': '${AuthId}',
            'type': reaction
          };
          try {
            dynamic likeResponse =
                await Provider.of<LikeViewModel>(context, listen: false)
                    .storeLike(likeStoreData, '${authToken}');
            print(likeResponse);
          } catch (e) {
            print(e);
          }
        },
        child: Image.asset(
          'assets/images/${reaction}.png',
          width: 25,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> privacyList = [];
    if (widget.post?.privacy?.length == 1) {
      widget.post?.privacy?.forEach((element) {
        privacyList.add(Image.asset(
          'assets/images/${element}.png',
          width: 20,
          height: 20,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Constants.defaultImage(20.0);
          },
        ));
      });
    } else {
      String tooltip = '';
      widget.post?.privacy?.forEach((element) {
        tooltip += element + ' ';
      });
      privacyList.add(Tooltip(
        message: '${tooltip}',
        child: Image.asset(
          'assets/images/custom-privacy.png',
          width: 20,
          height: 20,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Constants.defaultImage(20.0);
          },
        ),
      ));
    }

    Widget privacyWidget = Row(children: privacyList);

    UserViewModel? _userViewModel = Provider.of<UserViewModel>(context);
    User? _user = _userViewModel.getUser;
    CommentViewModel _commentViewModal = Provider.of<CommentViewModel>(context);

    NpDateTime postCreatedAt = widget.post!.createdat!;

    return Visibility(
      visible: showPost,
      child: Container(
        child: Material(
          child: Container(
            color: Constants.np_bg_clr,
            child: Padding(
              padding: EdgeInsets.only(
                  left: Constants.np_padding_only,
                  right: Constants.np_padding_only,
                  top: 0),
              child: Card(
                shadowColor: Colors.black12,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(Constants.np_padding_only),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: (widget.post == null)
                                            ? Utils.LoadingIndictorWidtet()
                                            : Image.network(
                                                '${Constants.profileImage(widget.post?.user)}',
                                                fit: BoxFit.cover,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return Constants.defaultImage(
                                                      50.0);
                                                },
                                              )),
                                  ),
                                  Container(
                                    height: 50,
                                    margin: EdgeInsets.only(left: 10, top: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${widget.post?.user?.fname} ${widget.post?.user?.lname}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${postCreatedAt.m}-${postCreatedAt.d}-${postCreatedAt.Y} ${postCreatedAt.h}:${postCreatedAt.i} ${postCreatedAt.A} ',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                            privacyWidget
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Theme(
                                data: Theme.of(context).copyWith(
                                  cardColor: Colors.white,
                                ),
                                child: new PopupMenuButton<int>(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Colors.black,
                                  ),
                                  color: Colors.white,
                                  onSelected: (item) async {
                                    if (item == 0) {
                                      await deletePost(widget.post?.id);
                                    }
                                    if (item == 1) {
                                      reportPost(widget.post?.id);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    (widget.post?.user_id == AuthId)
                                        ? PopupMenuItem<int>(
                                            value: 0,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                Text('Delete'),
                                              ],
                                            ),
                                          )
                                        : PopupMenuItem<int>(
                                            value: 1,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.flag,
                                                  color: Colors.red,
                                                ),
                                                Text('Report'),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              )
                              // Container(
                              //   child: Row(
                              //     children: [
                              //       if (widget.post?.user_id == AuthId) ...[
                              //         Theme(
                              //           data: Theme.of(context).copyWith(
                              //             cardColor: Colors.white,
                              //           ),
                              //           child: new PopupMenuButton<int>(
                              //             color: Colors.white,
                              //             padding: EdgeInsets.zero,
                              //             onSelected: (item) async {
                              //               await deletePost(widget.post?.id);
                              //             },
                              //             itemBuilder: (context) => [
                              //               PopupMenuItem<int>(
                              //                 value: 0,
                              //                 padding: EdgeInsets.symmetric(
                              //                     horizontal: 10),
                              //                 child: Row(
                              //                   children: [
                              //                     Icon(
                              //                       Icons.delete,
                              //                       color: Colors.red,
                              //                       size: 15,
                              //                     ),
                              //                     Text('Delete Post')
                              //                   ],
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        onTap: () {
                          if (widget.post?.user?.id != AuthId) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtherProfileScreen(
                                        widget.post?.user?.id)));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen()));
                          }
                        },
                      ),
                      Container(color: Constants.np_bg_clr, height: 1),
                      if (widget.post?.details != null) ...[
                        Container(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding:
                                  EdgeInsets.all(Constants.np_padding_only),
                              child: Linkify(
                                onOpen: (url) {
                                  setState(() {
                                    _launched =
                                        _launchInBrowser(Uri.parse(url.url));
                                  });
                                  FutureBuilder<void>(
                                      future: _launched,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<void> snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          return const Text('');
                                        }
                                      });
                                },
                                text: "${widget.post?.details}",
                              )),
                        ),
                        Constants.horizontalLine(),
                      ],
                      if (widget.post != null) ...[
                        if (widget.post?.assets?.type == 'image') ...[
                          Container(
                            height: 300,
                            width: double.infinity,
                            color: Colors.white,
                            child: (widget.post == null)
                                ? Utils.LoadingIndictorWidtet()
                                /*: FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/image-placeholder.png',
                                  image: Constants.postImage(widget.post?.assets,),
                                  fit: BoxFit.cover,
                                ),
                          ),*/
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ShowImage(
                                                  Constants.postImage(
                                                          widget.post?.assets)
                                                      .toString(),
                                                )),
                                      );
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${Constants.postImage(widget.post?.assets)}",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          Utils.LoadingIndictorWidtet(),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/image-placeholder.png',
                                        width: 300,
                                        height: 300,
                                      ),
                                    ),
                                  ),
                          ),
                          Container(color: Constants.np_bg_clr, height: 1),
                        ],
                        if (widget.post?.assets?.type == 'audio') ...[
                          Container(
                            width: double.infinity,
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AudioScreen(
                                        audioUrl:
                                            "${AppUrl.url}storage/a/posts/${widget.post?.assets?.file}",
                                      ),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'assets/images/audio-thumbnail.png',
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Divider(),
                        ],
                        if (widget.post?.assets?.type == 'video') ...[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoScreen(
                                    videoUrl:
                                        "${AppUrl.url}storage/a/posts/${widget.post?.assets?.file}",
                                  ),
                                ),
                              );
                            },
                            /*child: Container(
                            width: double.infinity,
                            color: Colors.grey.shade400,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 110),
                              child: Icon(
                                Icons.play_circle_outline,
                                size: 70,
                                color: Color(0x8A000000),
                              ),
                            ),
                          ),
                          */
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  decoration:
                                      new BoxDecoration(color: Colors.white),
                                  alignment: Alignment.center,
                                  height: 280,
                                  child: FadeInImage(
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: AssetImage(
                                        'assets/images/video-placeholder.png'),
                                    image: CachedNetworkImageProvider(
                                        '${AppUrl.url}storage/a/posts/thumbnail-${widget.post?.assets?.file?.split(".")[0]}.png'),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/images/video-placeholder.png',
                                          fit: BoxFit.fitWidth);
                                    },
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 280,
                                      child: Icon(
                                        Icons.play_circle_outline,
                                        size: 70,
                                        color: Color(0x8A000000),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                        if (widget.post?.assets?.type == 'link') ...[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: AnyLinkPreview(
                              link: '${widget.post?.assets?.file}',
                              displayDirection: UIDirection.uiDirectionVertical,
                              showMultimedia: true,
                              bodyMaxLines: 5,
                              bodyTextOverflow: TextOverflow.ellipsis,
                              titleStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              bodyStyle:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                              errorBody: ' Something went wrong',
                              errorTitle: 'Oops!',
                              errorWidget: Container(
                                color: Colors.grey[100],
                                child: Text('Oops!'),
                              ),
                              errorImage: "https://google.com/",
                              cache: Duration(days: 7),
                              backgroundColor: Colors.grey[100],
                              borderRadius: 12,
                              removeElevation: false,
                              boxShadow: [
                                BoxShadow(blurRadius: 3, color: Colors.grey)
                              ],
                              onTap: () {
                                var url = widget.post?.assets?.file ?? '';
                                setState(() {
                                  _launched =
                                      _launchInWebViewOrVC(Uri.parse(url));
                                });
                              },
                            ),
                          )
                        ]
                      ],
                      Visibility(
                          visible: showReactionPopup,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                width: MediaQuery.of(context).size.width - 150,
                                margin:
                                    EdgeInsets.only(left: 5, top: 5, right: 5),
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                  color: Colors.grey.shade200,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                ),
                                child: SingleChildScrollView(
                                  child: Container(
                                    width: 300,
                                    padding: EdgeInsets.zero,
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        for (var reaction in reactions)
                                          reactionWidgetLayout(reaction),
                                      ],
                                    ),
                                  ),
                                )),
                          )),
                      Container(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              child: Container(
                                  width: 30,
                                  height: 50,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Image.asset(
                                      'assets/images/${selectedreaction}.png',
                                      height: 5,
                                      width: 5,
                                    ),
                                  )
                                  // Icon(Icons.thumb_up, color: likeColor),
                                  ),
                              onTap: () async {
                                setState(() {
                                  showReactionPopup = !showReactionPopup;
                                });
                              },
                              onLongPress: () async {
                                setState(() {
                                  showReactionPopup = !showReactionPopup;
                                });
                              },
                            ),
                            Container(
                              width: 20,
                              height: 50,
                              child: Center(
                                  child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ShowLikeCard(widget.post),
                                  ));
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 8, right: 10, left: 3),
                                  child: Text(
                                    '${totalLikes}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              )),
                            ),
                            Container(width: 20),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShowCommentCard(widget.post)))
                                    .then((value) {});
                              },
                              child: Icon(Icons.comment),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${totalComment}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(color: Constants.np_bg_clr, height: 1),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.all(Constants.np_padding_only),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: (widget.post?.user_id.toString() ==
                                          null)
                                      ? Utils.LoadingIndictorWidtet()
                                      : Image.network(
                                          '${Constants.profileImage(_user)}',
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
                              new Flexible(
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
                                        hintText: 'Write something',
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 17, vertical: 10)),
                                  ),
                                ),
                              ),
                              Container(
                                width: 30,
                                height: 40,
                                child: IconButton(
                                  icon: const Icon(Icons.add),
                                  color: Colors.black,
                                  tooltip: 'Add Comment',
                                  onPressed: () async {
                                    if (_commentTxtController.text.isEmpty) {
                                      Utils.toastMessage('Comment is required');
                                    } else {
                                      Map commentStoreData = {
                                        'comment': _commentTxtController.text,
                                        'post_id': '${widget.post?.id}',
                                        'user_id': '${AuthId}',
                                      };
                                      setState(() {
                                        totalComment = totalComment! + 1;
                                        _commentTxtController.text = '';
                                      });
                                      Map response =
                                          await _commentViewModal.storeComments(
                                              commentStoreData, '${authToken}');
                                      if (response['success'] == true) {
                                        Utils.toastMessage(
                                            'Your comment has been added');
                                      } else {
                                        setState(() {
                                          totalComment = totalComment! - 1;
                                        });
                                        Utils.toastMessage(
                                            'Something went wrong');
                                      }
                                    }
                                    //commentStore(widget.post.id);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
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
}
