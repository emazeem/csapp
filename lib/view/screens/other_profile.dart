import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_social/model/CheckPrivacy.dart';
import 'package:connect_social/view/screens/chatbox.dart';
import 'package:connect_social/view/screens/profile.dart';
import 'package:connect_social/view/screens/single_post.dart';
import 'package:connect_social/view/screens/widgets/layout.dart';
import 'package:connect_social/view_model/privacy_view_model.dart';
import 'package:flutter/material.dart';
import 'package:connect_social/model/Gallery.dart';
import 'package:connect_social/model/Post.dart';
import 'package:connect_social/model/UDetails.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/apis/api_response.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/network.dart';
import 'package:connect_social/view/screens/mygallery.dart';
import 'package:connect_social/view/widgets/show_post.dart';
import 'package:connect_social/view_model/friend_view_model.dart';
import 'package:connect_social/view_model/gallery_view_model.dart';
import 'package:connect_social/view_model/post_view_model.dart';
import 'package:connect_social/view_model/u_details_view_model.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class OtherProfileScreen extends StatefulWidget {
  final int? id;

  const OtherProfileScreen(this.id, {Key? key}) : super(key: key);

  @override
  State<OtherProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<OtherProfileScreen> {
  String? authToken;
  bool? authUser = false;
  var authId;
  Map data = {};
  List<User> friends = [];
  bool showMoreBtnFlag = true;
  int showMoreCounter = 0;
  Widget _showMoreBtn = Container();
  bool _allPostsFetched = false;
  bool _isLoadingMore = false;
  List<Post?> myPosts = [];
  bool showsocialinfo = true;

  String _selectedNetworkPrivacy = 'friends';

  Future<void> _pullNetwork(ctx) async {
    print('_pullNetwork');
    Map fetchNetworkData = {
      'id': '${widget.id}',
      'key': '${_selectedNetworkPrivacy}'
    };
    Provider.of<UserViewModel>(context, listen: false).setFriends([]);
    Provider.of<UserViewModel>(context, listen: false).fetchFriends(fetchNetworkData, '${authToken}');
  }

  Future _pullPosts(ctx) async {
    print('_pullPosts');
    Provider.of<MyPostViewModel>(context, listen: false).setMyPosts([]);
    Map postParam = {'id': '${widget.id}', 'number': '0'};
    Provider.of<MyPostViewModel>(context, listen: false).fetchMyPosts(postParam, '${authToken}');
  }

  Future<void> _pullGalleryImages(ctx) async {
    var galleryDatum = {'id': '${widget.id}', 'key': 'image'};
    Provider.of<GalleryViewModel>(context, listen: false).setGallery([]);
    Provider.of<GalleryViewModel>(context, listen: false).fetchMyGallery(galleryDatum, '${authToken}');
  }

  Future<void> _pullActionButtonStatus(ctx) async {
    _clearActionButtonStatus(ctx);
    Provider.of<FriendViewModel>(context, listen: false).fetchActionButtonStatus({'auth_user': '${authId}', 'other_user': '${widget.id}'}, '${authToken}');
  }

  Future<void> _clearActionButtonStatus(ctx) async {
    Provider.of<FriendViewModel>(context, listen: false).setActionBtnStatus(new ActionButtonStatus());
  }

  Future<void> _blockUser(ctx) async {
    dynamic response = await Provider.of<UserViewModel>(context, listen: false).blockUser({'from': '${authId}', 'to': '${widget.id}'}, '${authToken}');
    Navigator.push(ctx, MaterialPageRoute(builder: (context) => NPLayout(currentIndex: 0,)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = {'id': '${widget.id}'};
    _initScreen();
  }

  _initScreen() async {
    friends = [];
    showMoreBtnFlag = true;
    showMoreCounter = 0;
    _showMoreBtn = Container();
    _allPostsFetched = false;
    _isLoadingMore = false;
    myPosts = [];

    authToken = await AppSharedPref.getAuthToken();
    authId = await AppSharedPref.getAuthId();

    Provider.of<UserDetailsViewModel>(context, listen: false).setDetailsResponse(UserDetail());
    Provider.of<UserDetailsViewModel>(context, listen: false).getUserDetails(data, '${authToken}');

    Provider.of<OtherUserViewModel>(context, listen: false).otherUserResponseSetter(User());
    Provider.of<OtherUserViewModel>(context, listen: false).getOtherUserDetails(data, '${authToken}');

    _pullNetwork(context);
    _pullGalleryImages(context);
    _pullPosts(context);

    Map postParam = {'id': '${widget.id}', 'number': '0'};
    Provider.of<MyPostViewModel>(context, listen: false)
        .fetchMyPosts(postParam, '${authToken}');

    await _pullActionButtonStatus(context);

    Provider.of<PrivacyViewModel>(context, listen: false)
        .setCheckPrivacy(CheckPrivacy());
    Provider.of<PrivacyViewModel>(context, listen: false)
        .checkPrivacy(data, '${authToken}');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    OtherUserViewModel _otherUserViewModel =
        Provider.of<OtherUserViewModel>(context);
    User? _user = _otherUserViewModel.getOtherUser;

    List<User?> friends = Provider.of<UserViewModel>(context).getFriends;
    myPosts = Provider.of<MyPostViewModel>(context).getMyPosts;

    GalleryViewModel galleryViewModel = Provider.of<GalleryViewModel>(context);
    List<Gallery?> galleryImages = galleryViewModel.getGalleryImages;
    UserDetail? userDetail =
        Provider.of<UserDetailsViewModel>(context).getDetails;
    ActionButtonStatus? _actionBtnStatus =
        Provider.of<FriendViewModel>(context).getActionButtonStatus;

    PrivacyViewModel privacyViewModel = Provider.of<PrivacyViewModel>(context);
    CheckPrivacy? checkPrivacy = privacyViewModel.getCheckPrivacy;

    acceptOrRejectRequest(type, status, is_cancel_request) async {
      _clearActionButtonStatus(context);
      dynamic response;
      if (type == 'friend') {
        response = await _userViewModel.acceptOrRejectFriendRequest(
            {'id': '${_user?.id}', 'auth_id': '${authId}', 'status': status},
            '${authToken}');
      }
      if (type == 'connection') {
        response = await _userViewModel.acceptOrRejectConnectionRequest(
            {'id': '${_user?.id}', 'auth_id': '${authId}', 'status': status},
            '${authToken}');
      }

      if (response['success'] == true) {
        if (is_cancel_request == 1) {
          Utils.toastMessage('Request cancelled successfully!');
        } else {
          Utils.toastMessage(response['message']);
        }
      } else {
        Utils.toastMessage('Some error occurred.!');
      }
      _pullActionButtonStatus(context);
    }

    sendRequest(requestType) async {
      _clearActionButtonStatus(context);
      dynamic response;
      if (requestType == 'friend') {
        response = await _userViewModel.sendFriendRequest(
            {'from': '${authId}', 'to': '${_user?.id}'}, '${authToken}');
      }
      if (requestType == 'connection') {
        response = await _userViewModel.sendConnectionRequest(
            {'from': '${authId}', 'to': '${_user?.id}'}, '${authToken}');
      }

      if (response['success'] == true) {
        _pullActionButtonStatus(context);
        Utils.toastMessage(response['message']);
      } else {
        Utils.toastMessage('Some error occurred.!');
      }
      _pullActionButtonStatus(context);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Constants.titleImage2(context),
      ),
      body: Container(
        color: Constants.np_bg_clr,
        child: RefreshIndicator(
          onRefresh: () async {
            _initScreen();
          },
          child: ListView(
            children: [
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: (_user?.is_blocked == true) ? 150 : 200,
                      width: double.infinity,
                      child: (_user?.is_blocked == true)
                          ? Image.asset(
                              'assets/images/cover-bg.png',
                              fit: BoxFit.fill,
                            )
                          : Image.network(
                              '${Constants.coverPhoto(_user?.id, userDetail?.cover_photo)}',
                              fit: BoxFit.cover, errorBuilder:
                                  (BuildContext context, Object exception,
                                      StackTrace? stackTrace) {
                              return Image.asset(
                                '${Constants.defaultCover}',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            }),
                    ),
                  ],
                ),
              ),
              Container(
                  constraints: BoxConstraints.loose(Size.fromHeight(40)),
                  child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: -70.0,
                          child: Container(
                              child: ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(60),
                              child: (_user?.is_blocked == true)
                                  ? Image.asset('assets/images/profile.png',
                                      fit: BoxFit.cover, errorBuilder:
                                          (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                      return Constants.defaultImage(60.0);
                                    })
                                  : Image.network(
                                      '${Constants.profileImage(_user)}',
                                      fit: BoxFit.cover, errorBuilder:
                                          (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                      return Constants.defaultImage(60.0);
                                    }),
                            ),
                          )),
                        )
                      ])),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 10),
                width: double.infinity,
                child: (_user?.is_blocked == true)
                    ? Center(
                        child: Text(
                        'Connect Social User',
                        style: Constants().np_heading,
                      ))
                    : Column(
                        children: [
                          Center(
                            child: (_user?.fname == null)
                                ? Utils.LoadingIndictorWidtet()
                                : Text(
                                    '${_user?.fname} ${_user?.lname}',
                                    style: Constants().np_heading,
                                  ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                userDetail?.rank == null ||
                                        userDetail?.rank == ' '
                                    ? 'Loading...'
                                    : ' ${userDetail?.rank}',
                                style: Constants().np_subheading,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              if (_user?.is_blocked == false) ...[
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_actionBtnStatus?.showFriendRequestBtn == true) ...[
                          InkWell(
                            onTap: () => sendRequest('friend'),
                            child: controlContainerText('Add Friend'),
                          )
                        ],
                        if (_actionBtnStatus?.showConnectionRequestBtn ==
                            true) ...[
                          InkWell(
                            onTap: () => sendRequest('connection'),
                            child: controlContainerText('Add Connection'),
                          )
                        ],
                        if (_actionBtnStatus?.showFriendAcceptRejectBtn ==
                            true) ...[
                          InkWell(
                            onTap: () async {
                              await acceptOrRejectRequest('friend', '1', 0);
                            },
                            child:
                                controlContainerText('Accept Friend Request'),
                          )
                        ],
                        if (_actionBtnStatus?.showFriendAcceptRejectBtn ==
                            true) ...[
                          InkWell(
                            onTap: () async {
                              await acceptOrRejectRequest('friend', '2', 0);
                            },
                            child:
                                controlContainerText('Reject Friend Request'),
                          )
                        ],
                        if (_actionBtnStatus?.showConnectionAcceptRejectBtn ==
                            true) ...[
                          InkWell(
                            onTap: () async {
                              await acceptOrRejectRequest('connection', '1', 0);
                            },
                            child: controlContainerText(
                                'Accept Connection Request'),
                          )
                        ],
                        if (_actionBtnStatus?.showConnectionAcceptRejectBtn ==
                            true) ...[
                          InkWell(
                            onTap: () async {
                              await acceptOrRejectRequest('connection', '2', 0);
                            },
                            child: controlContainerText(
                                'Reject Connection Request'),
                          )
                        ],
                        if (_actionBtnStatus?.showUnfriendBtn == true) ...[
                          InkWell(
                            onTap: () async {
                              _clearActionButtonStatus(context);
                              dynamic response = await _userViewModel.unfriend(
                                  {'from': '${authId}', 'to': '${_user?.id}'},
                                  '${authToken}');
                              _pullActionButtonStatus(context);
                              if (response['success'] == true) {
                                Utils.toastMessage(response['message']);
                              } else {
                                Utils.toastMessage('Some error occurred.!');
                              }
                            },
                            child: controlContainerText('Unfriend'),
                          )
                        ],
                        if (_actionBtnStatus?.showUnConnectionBtn == true) ...[
                          InkWell(
                            onTap: () async {
                              _clearActionButtonStatus(context);
                              dynamic response = await _userViewModel
                                  .unConnection({
                                'from': '${authId}',
                                'to': '${_user?.id}'
                              }, '${authToken}');
                              _pullActionButtonStatus(context);
                              if (response['success'] == true) {
                                Utils.toastMessage(response['message']);
                              } else {
                                Utils.toastMessage('Some error occurred.!');
                              }
                            },
                            child: controlContainerText('Remove Connection'),
                          )
                        ],
                        if (_actionBtnStatus?.showCancelFriendRequestBtn ==
                            true) ...[
                          InkWell(
                            onTap: () async {
                              await acceptOrRejectRequest('friend', '2', 1);
                            },
                            child:
                                controlContainerText('Cancel Friend Request'),
                          )
                        ],
                        if (_actionBtnStatus?.showCancelConnectionRequestBtn ==
                            true) ...[
                          InkWell(
                            onTap: () async {
                              await acceptOrRejectRequest('connection', '2', 1);
                            },
                            child: controlContainerText(
                                'Cancel Connection Request'),
                          )
                        ],
                        _user?.is_network == true
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChatBoxScreen(_user)));
                                },
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Icon(
                                    Icons.message_outlined,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          width: 3,
                        ),
                        InkWell(
                          onTap: () {
                            showAlertDialog(context);
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Icon(
                              Icons.flag_outlined,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if (checkPrivacy?.about == true &&
                    userDetail?.about != null) ...[
                  Padding(
                    padding: EdgeInsets.only(
                        left: Constants.np_padding_only,
                        right: Constants.np_padding_only,
                        top: 20),
                    child: Card(
                      shadowColor: Colors.black12,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Text(
                                  'About',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: (userDetail?.about == null)
                                  ? Container()
                                  : Text('${userDetail?.about}'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
                Padding(
                  padding: EdgeInsets.only(
                      left: Constants.np_padding_only,
                      right: Constants.np_padding_only,
                      top: 20),
                  child: Card(
                    shadowColor: Colors.black12,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              showsocialinfo = !showsocialinfo;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Text(
                                  'Social Information',
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        Visibility(
                          visible: showsocialinfo,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  (checkPrivacy?.city == true &&
                                          userDetail?.city != null)
                                      ? Utils.socialInformation(
                                          'City', '${userDetail?.city}')
                                      : SizedBox.shrink(),
                                  (checkPrivacy?.state == true &&
                                          userDetail?.state != null)
                                      ? Utils.socialInformation('Current State',
                                          '${userDetail?.state}')
                                      : SizedBox.shrink(),
                                  (checkPrivacy?.joining == true)
                                      ? Utils.socialInformation(
                                          'Date of joining',
                                          '${userDetail?.createdat?.Y}-${userDetail?.createdat?.m}-${userDetail?.createdat?.d}')
                                      : SizedBox.shrink(),
                                  (checkPrivacy?.workplace == true &&
                                          userDetail?.workplace != null)
                                      ? Utils.socialInformation('Workplace',
                                          '${userDetail?.workplace}')
                                      : Container(),
                                  (checkPrivacy?.high_school == true &&
                                          userDetail?.high_school != null)
                                      ? Utils.socialInformation('High School',
                                          '${userDetail?.high_school}')
                                      : Container(),
                                  (checkPrivacy?.hobbies == true &&
                                          userDetail?.hobbies != null)
                                      ? Utils.socialInformation(
                                          'Hobbies', '${userDetail?.hobbies}')
                                      : Container(),
                                  (checkPrivacy?.email == true)
                                      ? Utils.socialInformation(
                                          'Email', '${_user?.email}')
                                      : Container(),
                                  (checkPrivacy?.phone == true &&
                                          _user?.phone != null)
                                      ? Utils.socialInformation(
                                          'Mobile Number', '${_user?.phone}')
                                      : Container(),
                                  (checkPrivacy?.gender == true &&
                                          _user?.gender != null)
                                      ? Utils.socialInformation(
                                          'Gender', '${_user?.gender}')
                                      : Container(),
                                  (checkPrivacy?.relationship_status == true &&
                                          userDetail?.relationship != null)
                                      ? Utils.socialInformation(
                                          'Relationship Status',
                                          '${userDetail?.relationship}')
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
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
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child:
                                Text('Gallery', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                        Container(color: Constants.np_bg_clr, height: 1),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 10,
                            runSpacing: 10,
                            children: <Widget>[
                              if (galleryViewModel.getGalleryStatus.status ==
                                  Status.IDLE) ...[
                                if (galleryImages.length == 0) ...[
                                  Padding(
                                    padding: EdgeInsets.all(
                                        Constants.np_padding_only),
                                    child: Center(
                                      child: Text('No images'),
                                    ),
                                  )
                                ] else ...[
                                  galleryImageWidget(galleryImages[0]),
                                  (galleryImages.length > 1)
                                      ? galleryImageWidget(galleryImages[1])
                                      : Container(),
                                  (galleryImages.length > 2)
                                      ? galleryImageWidget(galleryImages[2])
                                      : Container(),
                                ]
                              ] else if (galleryViewModel
                                      .getGalleryStatus.status ==
                                  Status.BUSY) ...[
                                Utils.LoadingIndictorWidtet(),
                              ]
                            ],
                          ),
                        ),
                        Container(color: Constants.np_bg_clr, height: 1),
                        InkWell(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyGalleryScreen(_user?.id)))
                          },
                          child: Center(
                            child: Padding(
                              padding:
                                  EdgeInsets.all(Constants.np_padding_only),
                              child: Text('Show all'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
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
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child:
                                Text('Network', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                        Container(color: Constants.np_bg_clr, height: 1),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            child: Row(children: [
                              for (var item
                                  in Constants.networkList(internal: true)) ...[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedNetworkPrivacy = item['key'];
                                    });
                                    _pullNetwork(context);
                                  },
                                  child: Container(
                                      //color: _selectedPrivacy==item['key']?Colors.black:Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 7, vertical: 7),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Container(
                                        padding: EdgeInsets.only(bottom: 4),
                                        decoration: new BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color:
                                                        _selectedNetworkPrivacy !=
                                                                item['key']
                                                            ? Colors.transparent
                                                            : Colors.black))),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/${item['key']}.png',
                                              width: 20,
                                            ),
                                            Text(
                                              item['title'],
                                              style: TextStyle(
                                                  color: Colors.black
                                                  //color:  _selectedPrivacy!=item['key']?Colors.black:Colors.white
                                                  ),
                                            )
                                          ],
                                        ),
                                      )),
                                )
                              ],
                            ]),
                          ),
                        ),
                        Container(color: Constants.np_bg_clr, height: 1),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 5,
                            runSpacing: 5,
                            children: <Widget>[
                              if (_userViewModel.getFetchFriendStatus.status ==
                                  Status.IDLE) ...[
                                if (friends.length == 0) ...[
                                  Container(
                                    padding: EdgeInsets.all(
                                        Constants.np_padding_only),
                                    child: Center(
                                      child: Text(
                                        'No ${_selectedNetworkPrivacy}',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  )
                                ] else ...[
                                  if (_selectedNetworkPrivacy == 'friends' ||
                                      _selectedNetworkPrivacy ==
                                          'connections') ...[
                                    if (checkPrivacy?.friend == true &&
                                        _selectedNetworkPrivacy ==
                                            'friends') ...[
                                      ProfileFriendCard(friends[0]),
                                      (friends.length > 1)
                                          ? ProfileFriendCard(friends[1])
                                          : Container(),
                                      (friends.length > 2)
                                          ? ProfileFriendCard(friends[2])
                                          : Container(),
                                    ] else if (checkPrivacy?.connection ==
                                            true &&
                                        _selectedNetworkPrivacy ==
                                            'connections') ...[
                                      ProfileFriendCard(friends[0]),
                                      (friends.length > 1)
                                          ? ProfileFriendCard(friends[1])
                                          : Container(),
                                      (friends.length > 2)
                                          ? ProfileFriendCard(friends[2])
                                          : Container(),
                                    ] else ...[
                                      Container(
                                        padding: EdgeInsets.all(
                                            Constants.np_padding_only),
                                        child: Center(
                                          child: Text(
                                            'No ${_selectedNetworkPrivacy}',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      )
                                    ]
                                  ] else ...[
                                    ProfileFriendCard(friends[0]),
                                    (friends.length > 1)
                                        ? ProfileFriendCard(friends[1])
                                        : Container(),
                                    (friends.length > 2)
                                        ? ProfileFriendCard(friends[2])
                                        : Container(),
                                  ]
                                ]
                              ] else if (_userViewModel
                                      .getFetchFriendStatus.status ==
                                  Status.BUSY) ...[
                                Utils.LoadingIndictorWidtet(size: 30.0),
                              ],
                            ],
                          ),
                        ),
                        Container(color: Constants.np_bg_clr, height: 1),
                        InkWell(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FriendScreen(_user?.id)))
                          },
                          child: Center(
                            child: Padding(
                                padding:
                                    EdgeInsets.all(Constants.np_padding_only),
                                child: Text('Show all')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                LoadPostsForProfile(),
              ],
              if (_user?.is_blocked == true) ...[
                Center(
                  child: Text('This user is no longer available.'),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/connect social-coin break2-011.png',
                    width: 200,
                    height: 200,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget controlContainerText(text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(7),
      ),
      margin: EdgeInsets.only(right: 3),
      child: Text(
        '${text}',
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget LoadPostsForProfile() {
    showTwoMorePosts() async {
      if (_isLoadingMore == false) {
        if (!mounted) return;
        setState(() {
          _isLoadingMore = true;
          showMoreCounter = showMoreCounter + 4;
        });
        Map data = {'id': '${widget.id}', 'number': '${showMoreCounter}'};
        List<Post?> twoMorePost =
            await Provider.of<MyPostViewModel>(context, listen: false)
                .fetchMyMorePosts(data, '${authToken}');
        if (twoMorePost.length == 0) {
          _allPostsFetched = true;
        }
        if (!mounted) return;
        setState(() {
          _isLoadingMore = false;
          myPosts.addAll(twoMorePost);
        });
      }
    }

    _showMoreBtn = (_allPostsFetched)
        ? Container()
        : InkWell(
            onTap: () {
              showTwoMorePosts();
            },
            child: Container(
                width: 120,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: _isLoadingMore
                        ? Colors.black.withOpacity(0.8)
                        : Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !_isLoadingMore
                        ? Text(
                            'Show more',
                            style: TextStyle(color: Colors.white),
                          )
                        : Text(
                            'Processing',
                            style: TextStyle(color: Colors.white),
                          ),
                    SizedBox(
                      width: 4,
                    ),
                    _isLoadingMore
                        ? Utils.LoadingIndictorWidtet(size: 10.0)
                        : Text('')
                  ],
                )));

    Widget _child = SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: myPosts.length,
              itemBuilder: (context, index) {
                return ShowPostCard(myPosts[index]);
              }),
          _showMoreBtn,
        ],
      ),
    );

    return Container(
      color: Constants.np_bg_clr,
      child: _child,
    );
  }

  Widget ProfileFriendCard(user) {
    return InkWell(
      onTap: () {
        if (user.id == authId) {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()))
              .then((value) => _pullPosts(context));
          ;
        } else {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OtherProfileScreen(user.id)))
              .then((value) => _pullPosts(context));
        }
      },
      child: Container(
          width: MediaQuery.of(context).size.width / 3.61,
          height: MediaQuery.of(context).size.width / 3.61 + 20,
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/image-placeholder.png',
                  image: '${Constants.profileImage(user)}',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.width / 3.61,
                  width: MediaQuery.of(context).size.width / 3.61,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Constants.defaultImage(
                        MediaQuery.of(context).size.width / 3.61);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    '${user.fname} ${user.lname}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget galleryImageWidget(Gallery? galleryImage) {
    return InkWell(
      onTap: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SinglePostScreen(galleryImage?.post_id)))
            .then((value) => _pullGalleryImages(context));
      },
      child: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width / 3.7,
          height: 130,
          color: Colors.grey,
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/image-placeholder.png',
            image: Constants.postImage(galleryImage),
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          )),
    );
  }

  Widget? showAlertDialog(BuildContext context) {
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          content: Text(
            "Are you sure to block this user?",
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          title: Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          actions: [
            InkWell(
              child: Container(
                width: 70,
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Text(
                    "No",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(buildContext).pop();
              },
            ),
            InkWell(
              child: Container(
                width: 70,
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Text(
                    "Yes",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
              ),
              onTap: () async {
                Navigator.of(buildContext).pop();
                _blockUser(context);
              },
            ),
          ],
        );
      },
    );
  }
}
