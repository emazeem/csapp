import 'package:badges/badges.dart' as badge2;
import 'package:connect_social/model/MyBalance.dart';
import 'package:connect_social/model/UDetails.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/view_model/u_details_view_model.dart';
import 'package:connect_social/view_model/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:connect_social/res/app_url.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/account_verification.dart';
import 'package:connect_social/view/screens/login.dart';
import 'package:connect_social/view/screens/splash.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:connect_social/res/routes.dart' as route;

class Constants {
  static var authToken = 'token';
  static var registerOtp = 'six-digit-register-otp';
  static var userKey = 'user';
  static var email_verified = 'email_verified';

  static var user_device_id = 'user_device_id';
  static var isStoredUserDeviceId = 'is_store_user_device';

  static String avatarImage = 'assets/images/avatar.jpg';
  static String defaultCover = 'assets/images/cover.jpg';

  static String splashScreen = '/';
  static String loginPage = 'login';
  static String registerPage = 'register';
  static String homePage = 'home';
  static String profilePage = 'profile';
  static String notificationPage = 'notification';
  static String searchPage = 'search';
  static String settingPage = 'setting';
  static String friendPage = 'friend';
  static String myGalleryPage = 'my-gallery';
  static String chatPage = 'chat';
  static String chatBoxPage = 'chat-box';
  static String forgotPasswordPage = 'forgot-password';
  static String createPostPage = 'create-post';
  static String accountVerificationPage = 'account-verification';
  static String friendRequest = 'friend-requests';
  static String walletDashboardPage = 'wallet/dashboard';
  static String walletTransactionsPage = 'wallet/transactions';
  static String walletNetworkEarningPage = 'wallet/network-earnings';

  static double np_padding = 5;
  static double np_padding_only = 10;
  var np_bg = 0XFF41494b;

  static Color np_yellow = const Color(0XFFd8b04e);
  static Color np_bg_clr = const Color(0XFFe5e7e2);

  TextStyle np_heading = new TextStyle(fontSize: 20);
  TextStyle np_subheading = new TextStyle(fontSize: 14, color: Colors.grey);
  static horizontalLine() {
    return Container(color: Constants.np_bg_clr, height: 1);
  }

  static List networkList(
      {bool internal = false,
      bool showGlobal = true,
      bool showAll = false,
      showOnlyMe = false}) {
    List networks = [];
    if (showAll) {
      networks.add({'title': 'All', 'key': 'all'});
    }

    networks.add({'title': 'Global', 'key': 'global'});
    networks.add({'title': 'Public', 'key': 'public'});

    networks.add({'title': 'Friends', 'key': 'friends'});
    networks.add({'title': 'Connections', 'key': 'connections'});
    networks.add({'title': 'Personal Network', 'key': 'tier-1'});
    networks.add({'title': 'Extended Network', 'key': 'tier-2'});
    if (showOnlyMe) {
      networks.add({'title': 'Only me', 'key': 'only-me'});
    }

    if (internal) {
      networks.removeWhere((e) => e['key'] == 'global');
      networks.removeWhere((e) => e['key'] == 'public');
    }
    if (!showGlobal) {
      networks.removeWhere((e) => e['key'] == 'global');
    }

    return networks;
  }

  static profileImage(user) {
    String profile =
        '${AppUrl.url}storage/profile/${user?.email}/50x50${user?.profile}';
    return profile.toString();
  }

  static coverPhoto(id, path) {
    String profile = '${AppUrl.url}storage/a/covers/${id}/${path}';
    return profile.toString();
  }

  static defaultImage(size) {
    return Image.asset(
      '${Constants.avatarImage}',
      width: size,
      height: size,
    );
  }

  static postImage(galleryImage) {
    String image = '${AppUrl.url}storage/a/posts/${galleryImage?.file}';
    return image.toString();
  }

  static titleImage(context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    User? user = _userViewModel.getUser;
    print('user notification :: ${user?.anyUnreadNotification}');

    MyBalance? myBalance = Provider.of<WalletViewModel>(context).getMyBalance;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        /*InkWell(
                    onTap: (){
                        if(Provider.of<UserDetailsViewModel>(context,listen: false).getDetails?.kyc_status=='2'){
                            Navigator.pushNamed(context, route.walletDashboardPage);
                        }else{
                            Utils.toastMessage('You can not access wallet because your KYC status is ${Constants.kycStatus(Provider.of<UserDetailsViewModel>(context,listen: false).getDetails!)}');

                        }
                    },
                    child: Row(
                        children: [
                            Padding(
                                padding:EdgeInsets.only(right: 20),
                                child: Image.asset('assets/images/logo 2.png', height: 30),
                            )
                            Container(
                                width: 40.0,
                                height:40.0,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: const Color(0xff7c94b6),
                                    image: DecorationImage(
                                        image: AssetImage('assets/images/logo.png'),
                                        fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all( Radius.circular(40.0)),
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 2.0,
                                    ),
                                ),
                            ),
                            SizedBox(width: 10),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text('My Balance',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                                    (myBalance.balance==null)
                                        ? Utils.LoadingIndictorWidtet(size: 12.0)
                                        : Text('${myBalance.balance} Coins',style: TextStyle(color: Colors.white,fontSize: 12),),
                                ],
                            ),


                        ],
                    ),
                ),
                */
        Expanded(
            child: Container(
          width: double.infinity,
          child: Center(
            child: Image.asset('assets/images/logo 2.png', height: 40),
          ),
        )),
        Row(
          children: [
            Container(
              width: 23,
              height: 40,
              margin: EdgeInsets.only(right: 10),
              child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, route.searchPage);
                  },
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                  )),
            ),
            Container(
              width: 23,
              height: 40,
              margin: EdgeInsets.only(right: 10),
              child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, route.notificationPage);
                  },
                  child: (user?.anyUnreadNotification == 0 ||
                          user?.anyUnreadNotification == null)
                      ? Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.black,
                        )
                      : badge2.Badge(
                          position: badge2.BadgePosition.topEnd(top: 6, end: 0),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.black,
                          ),
                        )),
            ),
          ],
        )
      ],
    );
    return Image.asset(
      'assets/images/logo.png',
      width: 40,
      height: 40,
    );
  }

  static titleImage2(context) {
    return Image.asset('assets/images/logo 2.png', height: 40);
  }

  static checkToken(context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(Constants.authToken);
    if (token != null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SplashScreen()));
      });
    }
  }

  static authNavigation(context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(Constants.authToken);
    String? nav;
    if (token == null) {
      nav = 'login';
    } else {
      var authId = await AppSharedPref.getAuthId();
      Map datum = {'id': '${authId}'};
      await Provider.of<UserViewModel>(context, listen: false)
          .getUserDetails(datum, '${token}');
      nav = 'home';
    }
    return nav;
  }

  static checkVerificationStatus(context, data) async {
    if (data['email'] == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AccountVerificationScreen()),
          (Route<dynamic> route) => false);
    }
  }

  static kycStatus(UserDetail userDetail) {
    String? status;
    if (userDetail.kyc_status == '0') {
      status = 'Pending';
    }
    if (userDetail.kyc_status == '1') {
      status = 'Requested';
    }

    if (userDetail.kyc_status == '2') {
      status = 'Approved';
    }
    if (userDetail.kyc_status == '3') {
      status = 'Rejected';
    }
    return status;
  }

  static redirectToLoginIfNotAuthUser(context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(Constants.authToken);
    if (token == null) {
      //user is not login
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false);
    }
  }

  static changeProfile(token, id, file, path, api, input) async {
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer " + token
    };

    var uri = Uri.parse(api);
    var request = new http.MultipartRequest("POST", uri);
    var multipartFileSign = new http.MultipartFile(
        input.toString().toLowerCase(), stream, length,
        filename: basename(path));
    request.files.add(multipartFileSign);
    request.headers.addAll(headers);
    request.fields['id'] = '${id}';
    var response = await request.send();

    if (response.statusCode == 200) {
      Utils.toastMessage('Your ${input} photo has been updated');
      return {'success': true, 'response': response};
    } else {
      return {'success': false, 'response': response};
    }
  }
}
