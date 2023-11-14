import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
  Color mColor = Colors.red,
  int duration = 3200,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: duration),
      backgroundColor: mColor,
    ),
  );
}

class Const {
  static const appLogo = 'assets/app_logo/app_logo.png';
  static const emailIconLight = 'assets/app_icons/email_icon_light.png';
  static const passwordIconLight = 'assets/app_icons/password_icon_light.png';
  static const dashboardHomeIconLight = 'assets/app_icons/dashboard_home_icon_light.png';
  static const ticketIconLight = 'assets/app_icons/ticket_icon_light.png';
  static const dollarIconLight = 'assets/app_icons/dollar_icon_light.png';

  static const homeIconLight = 'assets/app_icons/home_icon_light.png';
  static const orderIconLight = 'assets/app_icons/order_icon_light.png';
  static const eventIconLight = 'assets/app_icons/event_icon_light.png';
  static const reportIconLight = 'assets/app_icons/report_icon_light.png';
  static const settingIconLight = 'assets/app_icons/setting_icon_light.png';

  static const bottomIconAmber = 'assets/app_icons/bottom_icon_amber.png';
  static const bottomIconBrown = 'assets/app_icons/bottom_icon_brown.png';
  static const bottomIconDarkBlue = 'assets/app_icons/bottom_icon_dark_blue.png';
  static const bottomIconLightPurple = 'assets/app_icons/bottom_icon_light_purple.png';
  static const bottomIconOrange = 'assets/app_icons/bottom_icon_orange.png';
  static const bottomIconPink = 'assets/app_icons/bottom_icon_pink.png';
  static const bottomIconTeal = 'assets/app_icons/bottom_icon_teal.png';

  static const backgroundLogoLight = 'assets/backgrounds/background_light.png';
  static const backgroundLogoDark = 'assets/backgrounds/background_dark.png';

  static const drawerCouponIconLight =
      'assets/drawer_icons/coupon_icon_light.png';
  static const drawerDashboardIconLight =
      'assets/drawer_icons/dashboard_icon_light.png';
  static const drawerEmailIconLight =
      'assets/drawer_icons/email_icon_light.png';
  static const drawerEventAttendanceIconLight =
      'assets/drawer_icons/event_attendance_icon_light.png';
  static const drawerEventManagementIconLight =
      'assets/drawer_icons/event_management_icon_light.png';
  static const drawerOrderIconLight =
      'assets/drawer_icons/order_icon_light.png';

  static const String LOGIN_RESPONSE_KEY = 'login_response';
  static const String LOGGED_IN_USER_DETAILS_KEY = 'logged_in_user';

  static const List<String> bottomIconsList = [
    bottomIconPink,
    bottomIconDarkBlue,
    bottomIconTeal,
    bottomIconOrange,
    bottomIconLightPurple,
    bottomIconOrange,
    bottomIconBrown,
  ];
}

class ColorsConst {
  static const Color primaryColor = Color(0xFF182233);
  static const Color secondaryColor = Color(0xFF2B3D56);
  static const Color textColorDark = Color(0xFFD1E9F0);
  static const Color textColorLight = Color(0xFF182233);
  static const Color appBarTextColor = Color(0xFFD1E9F0);
  static const Color appBarIconColor = Color(0xFFD1E9F0);
  static const Color buttonColorLight = Color(0xFFD1E9F0);
  static const Color gradiantCardColorLight = Color(0xFFD1E9F0);
  static const Color gradiantCardColorDark = Color(0xFF182233);
  static const Color buttonColorDark = Color(0xFF182233);
  static const Color screenBackgroundColorDark = Color(0xFF2B3D56);
  static const Color screenBackgroundColorLight = Color(0xFFFFFFFF);
  static const Color bottomNavbarColorLight = Color(0xFFD1E9F0);
  static const Color bottomNavbarColorDark = Color(0xFF182233);
  static const Color bottomNavbarIconColorLight = Color(0xFF5DA2B2);

  static const Color progressIndicatorColorLight = Color(0xFF182233);
  static const Color progressIndicatorColorDark = Color(0xFFD1E9F0);

  static const Color activeSwitchColor = Color(0xFF5DA2B2);
  static const Color inactiveSwitchColor = Colors.grey;

  static const Color unselectedCheckBoxColorLight = Colors.grey;
  static const Color unselectedCheckBoxColorDark = Color(0xFFD1E9F0);
  static const Color selectedCheckBoxColorLight = Color(0xFF182233);
  static const Color selectedCheckBoxColorDark = Color(0xFFD1E9F0);

  static const Color pink = Color(0xFFFD4175);
  static const Color darkBlue = Color(0xFF7675E7);
  static const Color teal = Color(0xFF2ECBB2);
  static const Color tealLight = Color(0xFF90FAFF);
  static const Color amber = Color(0xFFFFB106);
  static const Color lightPurple = Color(0xFFCC94E0);

  static const Color columnNameColor = Color(0xFF182233);
  static const Color tableRowColor = Color(0xFFD1E9F0);

  static const Color popupMenuColorLight = Color(0xFFFFFFFF);
  static const Color popupMenuColorDark = Color(0xFF182233);
}
