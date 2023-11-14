import 'dart:io';
import 'package:connect_social/model/Privacy.dart';
import 'package:connect_social/view/screens/wallet/dashboard.dart';
import 'package:connect_social/view/screens/wallet/network_earnings.dart';
import 'package:connect_social/view/screens/wallet/transactions.dart';
import 'package:connect_social/view_model/privacy_view_model.dart';
import 'package:connect_social/view_model/wallet_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connect_social/model/Friend.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/account_verification.dart';
import 'package:connect_social/view/screens/chat.dart';
import 'package:connect_social/view/screens/chatbox.dart';
import 'package:connect_social/view/screens/create_post.dart';
import 'package:connect_social/view/screens/forgot_password.dart';
import 'package:connect_social/view/screens/friend_request.dart';
import 'package:connect_social/view/screens/network.dart';
import 'package:connect_social/view/screens/home.dart';
import 'package:connect_social/view/screens/login.dart';
import 'package:connect_social/view/screens/mygallery.dart';
import 'package:connect_social/view/screens/notification.dart';
import 'package:connect_social/view/screens/profile.dart';
import 'package:connect_social/view/screens/search.dart';
import 'package:connect_social/view/screens/settings.dart';
import 'package:connect_social/view/screens/splash.dart';
import 'package:connect_social/view/screens/video_thumbnail.dart';
import 'package:connect_social/view_model/UserDeviceViewModel.dart';
import 'package:connect_social/view_model/auth_token_view_model.dart';
import 'package:connect_social/view_model/auth_view_model.dart';
import 'package:connect_social/view_model/chat_view_model.dart';
import 'package:connect_social/view_model/comment_view_model.dart';
import 'package:connect_social/view_model/friend_view_model.dart';
import 'package:connect_social/view_model/gallery_view_model.dart';
import 'package:connect_social/view_model/like_view_model.dart';
import 'package:connect_social/view_model/notification_view_model.dart';
import 'package:connect_social/view_model/post_view_model.dart';
import 'package:connect_social/view_model/u_details_view_model.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClientx(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initOneSignal(context);
    super.initState();
  }

  Future<void> initOneSignal(BuildContext context) async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId('3b924a1e-60c0-434c-89e9-e22db9099580');
    OneSignal.shared.promptUserForPushNotificationPermission().then(
      (accepted) {
        print('Accepted permission $accepted');
      },
    );

    //final status = await OneSignal.shared.getDeviceState();
    //final String? osUserID = status?.userId;
    //await AppSharedPref.saveDeviceId(osUserID);

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared.promptUserForPushNotificationPermission(
      fallbackToSettings: false,
    );

    /// Calls when foreground notification arrives.
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (handleForegroundNotifications) {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(create: (context) {
          return AuthViewModel();
        }),
        ChangeNotifierProvider<UserViewModel>(create: (context) {
          return UserViewModel();
        }),
        ChangeNotifierProvider<AuthTokenViewModel>(create: (context) {
          return AuthTokenViewModel();
        }),
        ChangeNotifierProvider<PostViewModel>(create: (context) {
          return PostViewModel();
        }),
        ChangeNotifierProvider<CommentViewModel>(create: (context) {
          return CommentViewModel();
        }),
        ChangeNotifierProvider<MyPostViewModel>(create: (context) {
          return MyPostViewModel();
        }),
        ChangeNotifierProvider<GalleryViewModel>(create: (context) {
          return GalleryViewModel();
        }),
        ChangeNotifierProvider<NotificationViewModal>(create: (context) {
          return NotificationViewModal();
        }),
        ChangeNotifierProvider<UserDetailsViewModel>(create: (context) {
          return UserDetailsViewModel();
        }),
        ChangeNotifierProvider<LikeViewModel>(create: (context) {
          return LikeViewModel();
        }),
        ChangeNotifierProvider<ChatViewModel>(create: (context) {
          return ChatViewModel();
        }),
        ChangeNotifierProvider<FriendViewModel>(create: (context) {
          return FriendViewModel();
        }),
        ChangeNotifierProvider<OtherUserViewModel>(create: (context) {
          return OtherUserViewModel();
        }),
        ChangeNotifierProvider<UserDeviceViewModel>(create: (context) {
          return UserDeviceViewModel();
        }),
        ChangeNotifierProvider<WalletViewModel>(create: (context) {
          return WalletViewModel();
        }),
        ChangeNotifierProvider<PrivacyViewModel>(create: (context) {
          return PrivacyViewModel();
        }),
        ChangeNotifierProvider<UserDetailsViewModel>(create: (context) {
          return UserDetailsViewModel();
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Connect Social',
        theme: ThemeData(
          appBarTheme: AppBarTheme(),
          accentColor: Colors.deepOrange,
          popupMenuTheme: PopupMenuThemeData().copyWith(
            color: Colors.blue,
          ),
        ),
        initialRoute: Constants.splashScreen,
        routes: {
          Constants.loginPage: (context) => LoginScreen(),
          Constants.homePage: (context) => HomeScreen(),
          Constants.friendPage: (context) => FriendScreen(0),
          Constants.profilePage: (context) => ProfileScreen(),
          Constants.settingPage: (context) => SettingScreen(),
          Constants.notificationPage: (context) => NotificationScreen(),
          Constants.myGalleryPage: (context) => MyGalleryScreen(0),
          Constants.searchPage: (context) => SearchScreen(),
          Constants.chatPage: (context) => ChatScreen(),
          Constants.forgotPasswordPage: (context) => ForgotPasswordScreen(),
          Constants.accountVerificationPage: (context) =>
              AccountVerificationScreen(),
          Constants.chatBoxPage: (context) => ChatBoxScreen(User()),
          Constants.createPostPage: (context) => CreatePostScreen('simple'),
          Constants.splashScreen: (context) => SplashScreen(),
          Constants.friendRequest: (context) => FriendRequestScreen(),
          Constants.walletDashboardPage: (context) => WalletDashboard(),
          Constants.walletTransactionsPage: (context) => WalletTransactions(),
          Constants.walletNetworkEarningPage: (context) =>
              WalletNetworkEarning(),

          //'video-thumbnail' : (context) => HomePage(title: 'Homepage'),
        },
      ),
    );
  }
}
