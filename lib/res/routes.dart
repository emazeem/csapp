import 'package:connect_social/view/screens/wallet/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:connect_social/view/screens/account_verification.dart';
import 'package:connect_social/view/screens/chat.dart';
import 'package:connect_social/view/screens/create_post.dart';
import 'package:connect_social/view/screens/forgot_password.dart';
import 'package:connect_social/view/screens/friend_request.dart';
import 'package:connect_social/view/screens/login.dart';
import 'package:connect_social/view/screens/mygallery.dart';
import 'package:connect_social/view/screens/notification.dart';
import 'package:connect_social/view/screens/search.dart';
import 'package:connect_social/view/screens/settings.dart';

const String landingPage = 'landing';
const String loginPage = 'login';
const String registerPage = 'register';
const String homePage = 'home';
const String profilePage = 'profile';
const String forgotPasswordPage = 'forgot-password';
const String notificationPage = 'notification';
const String friendRequestPage = 'friend-requests';
const String searchPage = 'search';

const String settingPage = 'setting';
const String editSocialInformationPage = 'edit-social-information';

const String friendPage = 'friend';
const String myGalleryPage = 'my-gallery';
const String chatPage = 'chat';
const String splashScreenPage = 'splash';
const String createPostPage = 'create-post';
const String accountVerificationPage = 'account-verification';
const String register_step1 = 'register-step-1';

const String walletDashboardPage = 'wallet/dashboard';
const String walletTransactionsPage = 'wallet/transactions';
const String walletNetworkEarningPage = 'wallet/network-earnings';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case loginPage:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case settingPage:
      return MaterialPageRoute(builder: (context) => SettingScreen());
    case notificationPage:
      return MaterialPageRoute(builder: (context) => NotificationScreen());
    case myGalleryPage:
      return MaterialPageRoute(builder: (context) => MyGalleryScreen(0));
    case searchPage:
      return MaterialPageRoute(builder: (context) => SearchScreen());
    case chatPage:
      return MaterialPageRoute(builder: (context) => ChatScreen());
    case forgotPasswordPage:
      return MaterialPageRoute(builder: (context) => ForgotPasswordScreen());
    case accountVerificationPage:
      return MaterialPageRoute(builder: (context) => AccountVerificationScreen());
    case friendRequestPage:
      return MaterialPageRoute(builder: (context) => FriendRequestScreen());
    case walletDashboardPage:
      return MaterialPageRoute(builder: (context) => WalletDashboard());
    case walletTransactionsPage:
      return MaterialPageRoute(builder: (context) => FriendRequestScreen());
    case walletNetworkEarningPage:
      return MaterialPageRoute(builder: (context) => FriendRequestScreen());


    case createPostPage:
      return MaterialPageRoute(builder: (context) => CreatePostScreen('simple'));
    default:
      throw ('This route name does not exists.');
  }
}
