import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_social/view/screens/other_profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connect_social/model/Gallery.dart';
import 'package:connect_social/model/Post.dart';
import 'package:connect_social/model/UDetails.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/apis/api_response.dart';
import 'package:connect_social/res/app_url.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/res/routes.dart' as route;
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/crop_profile.dart';
import 'package:connect_social/view/screens/network.dart';
import 'package:connect_social/view/screens/mygallery.dart';
import 'package:connect_social/view/widgets/show_post.dart';
import 'package:connect_social/view_model/gallery_view_model.dart';
import 'package:connect_social/view_model/post_view_model.dart';
import 'package:connect_social/view_model/u_details_view_model.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen();

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<User> friends = [];
  List<Gallery?> galleryImages = [];
  List<Gallery?> gallerySubList = [];
  String? authToken;
  var authId;

  bool profileSelected = false;
  File? profile;
  File? cover;
  int galleryStartIndex = 0;
  bool coverSelected = false;

  bool showMoreBtnFlag = true;
  int showMoreCounter = 0;
  Widget _showMoreBtn = Container();
  bool _allPostsFetched = false;
  bool _isLoadingMore = false;
  List<Post?> myPosts = [];
  Map postParam = {};
  Map data = {};
  bool showabout = true;
  bool showsocialinfo = true;

  String _selectedNetworkPrivacy = 'friends';

  getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CropProfile(image),
    ));
  }

  getCover() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    File file = File(image!.path);
    setState(() {
      coverSelected = true;
      cover = file;
    });
    await Constants.changeProfile(authToken, authId, file, image.path, AppUrl.changeCoverPicture, 'Cover');
  }

  Future<void> _pullNetwork(ctx) async {
    Map fetchNetworkData = {
      'id': '${authId}',
      'key': '${_selectedNetworkPrivacy}'
    };
    Provider.of<UserViewModel>(context, listen: false).setFriends([]);
    Provider.of<UserViewModel>(context, listen: false).fetchFriends(fetchNetworkData, '${authToken}');
  }

  Future<void> _pullPostsown(ctx) async {
    Provider.of<MyPostViewModel>(context, listen: false).setMyPosts([]);
    postParam = {'id': '${authId}', 'number': '0'};
    Provider.of<MyPostViewModel>(context, listen: false)
        .fetchMyPosts(postParam, '${authToken}');
  }

  Future _pullGallery(ctx) async {
    Map galleryParam = {'id': '${authId}', 'key': 'image'};
    Provider.of<GalleryViewModel>(context, listen: false).setGallery([]);
    Provider.of<GalleryViewModel>(context, listen: false)
        .fetchMyGallery(galleryParam, '${authToken}');
  }

  Future<void> _pullPosts(ctx) async {
    Provider.of<MyPostViewModel>(context, listen: false).setMyPosts([]);
    postParam = {'id': '${authId}', 'number': '0'};
    Provider.of<MyPostViewModel>(context, listen: false)
        .fetchMyPosts(postParam, '${authToken}');
  }

  //pull about info
  Future<void> _pullAbout(ctx) async {
    print('_pullAbout');
    Provider.of<UserDetailsViewModel>(context, listen: false)
        .setEmptyDetailsResponse();
  }
  //

  _initScreen() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();
      data = {'id': '${authId}'};
      print('talha');
      await _pullAbout(context);
      _pullNetwork(context);
      _pullPostsown(context);
      _pullGallery(context);

      postParam = {'id': '${authId}', 'number': '0'};
      Provider.of<MyPostViewModel>(context, listen: false)
          .fetchMyPosts(postParam, '${authToken}');

      Map galleryParam = {'id': '${authId}', 'key': 'image'};
      Provider.of<GalleryViewModel>(context, listen: false)
          .fetchMyGallery(galleryParam, '${authToken}');
      Provider.of<UserDetailsViewModel>(context, listen: false)
          .getUserDetails(data, '${authToken}');
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    print('initState');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();
      data = {'id': '${authId}'};
      print('talha');
      await _pullAbout(context);
      _pullNetwork(context);
      _pullPostsown(context);
      _pullGallery(context);

      postParam = {'id': '${authId}', 'number': '0'};
      Provider.of<MyPostViewModel>(context, listen: false)
          .fetchMyPosts(postParam, '${authToken}');

      Map galleryParam = {'id': '${authId}', 'key': 'image'};
      Provider.of<GalleryViewModel>(context, listen: false)
          .fetchMyGallery(galleryParam, '${authToken}');
      Provider.of<UserDetailsViewModel>(context, listen: false)
          .getUserDetails(data, '${authToken}');
    });
  }

  @override
  Widget build(BuildContext context) {
    List<User?> friends = Provider.of<UserViewModel>(context).getFriends;
    UserViewModel _userViewModel =
        Provider.of<UserViewModel>(context, listen: false);
    User? _user = _userViewModel.getUser;

    myPosts = Provider.of<MyPostViewModel>(context).getMyPosts;
    GalleryViewModel galleryViewModel = Provider.of<GalleryViewModel>(context);
    galleryImages = galleryViewModel.getGalleryImages;

    UserDetail? userDetail =
        Provider.of<UserDetailsViewModel>(context).getDetails;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Constants.titleImage2(context),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _initScreen();
        },
        child: Container(
          color: Constants.np_bg_clr,
          child: new SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      height: 200,
                      width: double.infinity,
                      child: (coverSelected == false)
                          ? CachedNetworkImage(
                              imageUrl:
                                  "${Constants.coverPhoto(authId, userDetail?.cover_photo)}",
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
                              errorWidget: (context, url, error) => Image.asset(
                                '${Constants.defaultCover}',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.file(cover!, fit: BoxFit.cover),
                    ),
                    InkWell(
                      onTap: () {
                        getCover();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constants.np_yellow,
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width - 30),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    )
                  ],
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
                              child: (profileSelected == false)
                                  ? CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          Utils.LoadingIndictorWidtet(),
                                      errorWidget: (context, url, error) =>
                                          Constants.defaultImage(60.0),
                                      imageUrl:
                                          "${Constants.profileImage(_user)}",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Image.file(
                                      profile!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Constants.np_yellow,
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              )),
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(left: 120),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      '${_user?.fname} ${_user?.lname}',
                      style: Constants().np_heading,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      userDetail?.rank == null || userDetail?.rank == ' '
                          ? 'Loading...'
                          : ' ${userDetail?.rank}',
                      style: Constants().np_subheading,
                    ),
                  ),
                ),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                showabout = !showabout;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'About',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, route.settingPage);
                                  },
                                  child: Container(
                                    width: 100,
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Icon(
                                        Icons.edit,
                                        size: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        Visibility(
                          visible: showabout,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: (userDetail?.about == null)
                                  ? Text('')
                                  : Text('${userDetail?.about}'),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Social Information',
                                  style: TextStyle(fontSize: 18),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, route.settingPage);
                                  },
                                  child: Container(
                                    width: 100,
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Icon(
                                        Icons.edit,
                                        size: 17,
                                      ),
                                    ),
                                  ),
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
                              height: 300,
                              child: ListView(
                                children: [
                                  (userDetail?.city == null)
                                      ? Container()
                                      : Utils.socialInformation(
                                          'City', '${userDetail?.city}'),
                                  (userDetail?.state == null)
                                      ? Container()
                                      : Utils.socialInformation('Current State',
                                          '${userDetail?.state}'),


                                  Utils.socialInformation('Date of joining',
                                      (userDetail?.createdat?.Y== null)?'':
                                      '${userDetail?.createdat?.Y}-${userDetail?.createdat?.m}-${userDetail?.createdat?.d}'),

                                  (userDetail?.workplace == null)
                                      ? Container()
                                      : Utils.socialInformation('Workplace',
                                          '${userDetail?.workplace}'),
                                  (userDetail?.high_school == null)
                                      ? Container()
                                      : Utils.socialInformation('High School',
                                          '${userDetail?.high_school}'),
                                  (userDetail?.hobbies == null)
                                      ? Container()
                                      : Utils.socialInformation(
                                          'Hobbies', '${userDetail?.hobbies}'),
                                  Utils.socialInformation(
                                      'Email', '${_user?.email}'),
                                  (_user?.phone == null)
                                      ? Container()
                                      : Utils.socialInformation(
                                          'Mobile Number', '${_user?.phone}'),
                                  (_user?.gender == null)
                                      ? Container()
                                      : Utils.socialInformation(
                                          'Gender', '${_user?.gender}'),
                                  (userDetail?.relationship == null)
                                      ? Container()
                                      : Utils.socialInformation(
                                          'Relationship Status',
                                          '${userDetail?.relationship}'),
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
                            spacing: 5,
                            runSpacing: 5,
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
                                  Utils.galleryImageWidget(
                                      context, galleryImages[0]),
                                  (galleryImages.length > 1)
                                      ? Utils.galleryImageWidget(
                                          context, galleryImages[1])
                                      : Container(),
                                  (galleryImages.length > 2)
                                      ? Utils.galleryImageWidget(
                                          context, galleryImages[2])
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
                            child: Text('My Network',
                                style: TextStyle(fontSize: 18)),
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
                                    margin: EdgeInsets.only(top: 35),
                                    child: Center(
                                      child: Text(
                                        'No ${_selectedNetworkPrivacy}',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  )
                                ] else ...[
                                  ProfileFriendCardown(friends[0]),
                                  (friends.length > 1)
                                      ? ProfileFriendCardown(friends[1])
                                      : Container(),
                                  (friends.length > 2)
                                      ? ProfileFriendCardown(friends[2])
                                      : Container(),
                                ]
                              ] else if (_userViewModel
                                      .getFetchFriendStatus.status ==
                                  Status.BUSY) ...[
                                Utils.LoadingIndictorWidtet(size: 40.0),
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
                                .then((value) => {
                                      Provider.of<MyPostViewModel>(context,
                                              listen: false)
                                          .setMyPosts([]),
                                      Provider.of<MyPostViewModel>(context,
                                              listen: false)
                                          .fetchMyPosts(
                                              postParam, '${authToken}'),
                                      Provider.of<UserDetailsViewModel>(context,
                                              listen: false)
                                          .setDetailsResponse(UserDetail()),
                                      Provider.of<UserDetailsViewModel>(context,
                                              listen: false)
                                          .getUserDetails(data, '${authToken}'),
                                    })
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
            ),
          ),
        ),
      ),
    );
  }

  Widget ProfileFriendCardown(user) {
    return InkWell(
      onTap: () {
        if (user.id == authId) {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()))
              .then((value) {
            print('here');
            _pullPostsown(context);
            _pullNetwork(context);
            _pullGallery(context);
          });
          ;
        } else {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OtherProfileScreen(user.id)))
              .then((value) {
            _initScreen();
          });
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

  Widget LoadPostsForProfile() {
    showTwoMorePosts() async {
      if (_isLoadingMore == false) {
        if (!mounted) return;
        setState(() {
          _isLoadingMore = true;
          showMoreCounter = showMoreCounter + 4;
        });
        Map data = {'id': '${authId}', 'number': '${showMoreCounter}'};
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
                margin: EdgeInsets.only(bottom: 20),
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
                        : Text(''),
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
}
