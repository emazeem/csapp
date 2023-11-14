import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_social/model/MyBalance.dart';
import 'package:connect_social/model/UDetails.dart';
import 'package:connect_social/res/routes.dart';
import 'package:connect_social/view/screens/chatbox.dart';
import 'package:connect_social/view_model/u_details_view_model.dart';
import 'package:connect_social/view_model/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/res/routes.dart' as route;
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/chat.dart';
import 'package:connect_social/view/screens/create_post.dart';
import 'package:connect_social/view/screens/network.dart';
import 'package:connect_social/view/screens/home.dart';
import 'package:connect_social/view/screens/other_profile.dart';
import 'package:connect_social/view/screens/profile.dart';
import 'package:connect_social/view/screens/search.dart';
import 'package:connect_social/view/screens/single_post.dart';
import 'package:connect_social/view/screens/video_thumbnail.dart';
import 'package:connect_social/view_model/UserDeviceViewModel.dart';
import 'package:connect_social/view_model/post_view_model.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class NPLayout extends StatefulWidget {
  final int currentIndex;
  const NPLayout({this.currentIndex = 0});

  @override
  State<NPLayout> createState() => _NPLayoutState();
}

class _NPLayoutState extends State<NPLayout> {
  var authToken;
  var authId;
  String? email_verified_at;
  int _currentIndex = 0;
  bool _isDrawerOpen = false;
  Map datum={};
  @override
  Widget _currentWidget = HomeScreen();

  Future<void> initOneSignal(BuildContext context) async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId('3b924a1e-60c0-434c-89e9-e22db9099580');
    OneSignal.shared.promptUserForPushNotificationPermission().then(
      (accepted) {
        print('Accepted permission $accepted');
      },
    );
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    await AppSharedPref.saveDeviceId(osUserID);

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared.promptUserForPushNotificationPermission(
      fallbackToSettings: true,
    );

    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      dynamic response = result.notification.additionalData;

      String url = response['url'];
      int data_id = 0;
      if (url == 'post') {
        data_id = response['id'];
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SinglePostScreen(data_id)));
      }
      if (url == 'friend') {
        data_id = response['id'];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtherProfileScreen(data_id)));
      }
      if (url == 'chat') {
        print('chat user ${response['user']}');
        //'_Map<Object?, Object?>' is not a subtype of type 'Map<String, dynamic>'

        User? _chatUser = User.fromJson({
          'id': response['user']['id'],
          'fname': response['user']['fname'],
          'lname': response['user']['lname'],
          'profile': response['user']['profile'],
          'username': response['user']['username'],
        });

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatBoxScreen(_chatUser)));
      }
    });
  }

  Future<void> _removeDevices(ctx) async {
    bool isOnline = await Utils.hasNetwork();
    if (isOnline) {
      Map userDeviceParams = {'user_id': '${authId}'};
      await Provider.of<UserDeviceViewModel>(ctx, listen: false).removeDeviceId(userDeviceParams, '${authToken}');
      AppSharedPref.logout(ctx);
    } else {
      Utils.toastMessage('No internet connection!');
    }
  }

  Future<void> _getUserDetails(ctx) async {
    Provider.of<UserDetailsViewModel>(ctx,listen: false).setDetailsResponse(UserDetail());
    Provider.of<UserDetailsViewModel>(ctx, listen: false).getUserDetails(datum, '${authToken}');
  }


  @override
  void initState() {
    // TODO: implement initState
    initOneSignal(context);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _currentIndex = widget.currentIndex;
      _currentWidget = _navScreens().elementAt(_currentIndex);
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();

      await Constants.redirectToLoginIfNotAuthUser(context);
      datum = {'id': '${authId}'};

      Provider.of<UserViewModel>(context, listen: false).getUserDetails(datum, '${authToken}');

      _getUserDetails(context);
      Provider.of<WalletViewModel>(context, listen: false).myBalance(datum, '${authToken}');

      final status = await OneSignal.shared.getDeviceState();
      await AppSharedPref.saveDeviceId(status?.userId);

      final String? osUserID = await AppSharedPref.getUserDeviceId();
      final int? isDeviceIdStored = await AppSharedPref.isStoredDeviceId();

      if (isDeviceIdStored != 1) {
        Map userDeviceParams = {
          'user_id': '${authId}',
          'device_id': '${osUserID}'
        };
        Provider.of<UserDeviceViewModel>(context, listen: false)
            .storeDeviceId(userDeviceParams, '${authToken}');
      }
    });
  }

  List<Widget> _navScreens() {
    return [
      HomeScreen(),
      FriendScreen(authId),
      Container(),
      ChatScreen(),
      ProfileScreen(),
      SearchScreen(),
    ];
  }

  navigateToNextScreen(index) {
    setState(() {
      if (index.runtimeType == int) {
        _currentWidget = _navScreens().elementAt(index);
        _currentIndex = index;
      } else {
        if (index == 'search') {
          Navigator.pushNamed(context, route.searchPage);
        }
        /*if(index=='wallet'){
          Navigator.pushNamed(context, route.walletDashboardPage);
        }
        */
        if (index == 'friend-requests') {
          Navigator.pushNamed(context, route.friendRequestPage);
        }
        if (index == 'notifications') {
          Navigator.pushNamed(context, route.notificationPage);
        }
        if (index == 'settings') {
          Navigator.pushNamed(context, route.settingPage);
        }
      }
    });
  }

  void _onItemTapped(int index) async {
    switch (index) {
      case 2:
        showModalBottomSheet(
            backgroundColor: Colors.black.withOpacity(0.8),
            isScrollControlled: true,
            context: context,
            builder: (context) {
              PostViewModel postViewModel =
                  Provider.of<PostViewModel>(context, listen: false);
              return Container(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: InkWell(
                                onTap: () => {
                                  Navigator.pop(context),
                                },
                                child: Container(
                                  color: Colors.white,
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreatePostScreen('video'))).then((value) {
                            return postViewModel.getPublicPosts;
                          }),
                        },
                        child: bottomNavBarPopupItem(
                            Icons.video_collection_sharp, 'Upload Video'),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreatePostScreen('audio'))).then((value) {
                            return postViewModel.getPublicPosts;
                          }),
                        },
                        child: bottomNavBarPopupItem(
                            Icons.audiotrack, 'Upload Audio'),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreatePostScreen('image'))).then((value) {
                            return postViewModel.getPublicPosts;
                          }),
                        },
                        child: bottomNavBarPopupItem(
                            Icons.photo, 'Upload Picture'),
                      ),
                      InkWell(
                        onTap: () => {
                          Navigator.pop(context),
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreatePostScreen('simple')))
                              .then((value) {
                            return postViewModel.getPublicPosts;
                          }),
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 50),
                          child:
                              bottomNavBarPopupItem(Icons.text_fields, 'Post'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FriendScreen(authId),
        ));
        break;
      case 4:
        Navigator.pushNamed(context, profilePage);

        break;
      default:
        setState(() {
          navigateToNextScreen(index);
        });
        break;
    }
  }

  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    User? user = _userViewModel.getUser;
    UserDetailsViewModel _userDetailsViewModel = Provider.of<UserDetailsViewModel>(context);
    UserDetail? userDetails = _userDetailsViewModel.getDetails;

    Constants.checkVerificationStatus(context, {'email': '${user?.email_verified_at}'});
    Widget drawer(BuildContext context) {
      return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          Container(
            padding: EdgeInsets.only(top:80,bottom: 30),
            color: Colors.grey.shade200,
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(0), // Border width
                    decoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.circle),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      child: ClipOval(
                        child: SizedBox.fromSize(
                            size: Size.fromRadius(35),
                            child: (user != null)
                                ? FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: AssetImage(Constants.avatarImage),
                              image: CachedNetworkImageProvider(Constants.profileImage(user)),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Constants.defaultImage(40.0);
                              },
                            )
                                : Utils.LoadingIndictorWidtet()),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10, top: 2, right: 10),
                      child: Column(
                        children: [
                          Text('${user?.fname} ${user?.lname}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          (userDetails?.rank == null || userDetails?.rank == 'null' || userDetails?.rank?.isEmpty == true)
                              ? Container()
                              :Text('${userDetails?.rank}', style: Constants().np_subheading),
                            (userDetails?.kyc_status == null || userDetails?.kyc_status == 'null' || userDetails?.kyc_status?.isEmpty == true)
                              ? Container()
                              : Text('KYC : ${Constants.kycStatus(userDetails!)}', style: TextStyle(fontSize: 11),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
          siderBarMenuItem("Feed", Icons.home, "home"),
          siderBarMenuItem(
              "My Network", Icons.account_tree_outlined, 'friends'),
          siderBarMenuItem(
              "Network Requests", Icons.add_box_outlined, 'friend-requests'),
          siderBarMenuItem(
              "Messages",
              (user?.anyUnreadMessage == 0 || user?.anyUnreadMessage == null)
                  ? Icons.chat
                  : Icons.mark_unread_chat_alt,
              'chat'),

          /*siderBarMenuItem("Wallet", Icons.wallet, "wallet"),*/

          siderBarMenuItem(
              "Notifications", Icons.notifications, "notifications"),
          siderBarMenuItem("Settings", Icons.settings, 'settings'),
          siderBarMenuItem("Logout", Icons.logout, 'logout'),
        ]),
      );
    }

    return WillPopScope(
      onWillPop: () {
        if(Navigator.canPop(context)){
          Navigator.pop(context);
          return Future.value(true);
        }else{
          exit(0);
        }
        return Future.value(false);
      },
      child: Scaffold(
        extendBody: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Constants.titleImage(context),
          titleSpacing: 4,
        ),
        body: _currentWidget,
        backgroundColor: Constants.np_bg_clr,
        drawer: drawer(context),
        onDrawerChanged: (isDrawerOpen) async{
          setState(() {
            _isDrawerOpen = isDrawerOpen;
          });
          if (_isDrawerOpen) {
            _getUserDetails(context);
          }
        },
        bottomNavigationBar: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: Padding(
            padding: EdgeInsets.zero,
            child: Container(
              padding: (Platform.isIOS)?EdgeInsets.symmetric(vertical: 5):EdgeInsets.zero,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Color(0xFF503f1f)],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  stops: [0.0, 0.8],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage('assets/images/home.png'),
                      color: Color(0xFFffffff),
                      size: 30,
                    ),
                    tooltip: 'Home',
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage('assets/images/network.png'),
                      color: Color(0xFFffffff),
                      size: 40,
                    ),
                    tooltip: 'Network',
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage('assets/images/plus.png'),
                      color: Color(0xFFffffff),
                      size: 45,
                    ),
                    tooltip: 'Add',
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage((user?.anyUnreadMessage == 0 ||
                              user?.anyUnreadMessage == null)
                          ? 'assets/images/message.png'
                          : 'assets/images/message-red.png'),
                      color: Color(0xFFffffff),
                      size: 35,
                    ),
                    tooltip: 'Chat',
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: (user == null)
                            ? Utils.LoadingIndictorWidtet()
                            : FadeInImage(
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          placeholder: AssetImage(Constants.avatarImage),
                          image: CachedNetworkImageProvider(Constants.profileImage(user)),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Constants.defaultImage(40.0);
                          },
                        )
                    ),
                    tooltip: 'Profile',
                    label: '',
                  ),
                ],
                currentIndex: _currentIndex,
                onTap: _onItemTapped,
                showUnselectedLabels: true,
                unselectedLabelStyle: TextStyle(
                  fontSize: 14,
                ),
                selectedLabelStyle: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget siderBarMenuItem(String title, IconData icon, String page) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          switch (page) {
            case 'home':
              _onItemTapped(0);
              break;
            case 'friends':
              _onItemTapped(1);
              break;
            case 'friend-requests':
              navigateToNextScreen('friend-requests');
              break;
            case 'notifications':
              navigateToNextScreen('notifications');
              break;
            case 'search':
              navigateToNextScreen('search');
              break;
            case 'settings':
              navigateToNextScreen('settings');
              break;
/*            case 'wallet':
              navigateToNextScreen('wallet');*/

              break;
            case 'logout':
              showAlertDialog(context);
              break;

            case 'chat':
              _onItemTapped(3);
              break;
            default:
              throw ('This route name does not exists.');
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
            color: Colors.grey.shade300,
          )),
        ),
        child: Row(
          children: [
            Expanded(
              child: Icon(icon, size: 25, color: Colors.black),
            ),
            Expanded(
              flex: 4,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      ),
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
            "Are you sure to Logout?",
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
              onTap: () {
                Navigator.of(buildContext).pop();
                _removeDevices(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class bottomNavBarPopupItem extends StatelessWidget {
  final IconData ico;
  final String title;

  const bottomNavBarPopupItem(this.ico, this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
              child: Icon(this.ico, size: 30),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                this.title,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
