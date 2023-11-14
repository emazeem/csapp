import 'package:connect_social/model/User.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/block_list.dart';
import 'package:connect_social/view/screens/settings/edit_social_information.dart';
import 'package:connect_social/view/screens/settings/prviacy_management.dart';
import 'package:connect_social/view/screens/settings/update_password.dart';
import 'package:connect_social/view_model/UserDeviceViewModel.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:connect_social/res/constant.dart';
import 'package:provider/provider.dart';

import '../../shared_preference/app_shared_preference.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var authToken;
  var authId;

  final _usernameConfirmationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();
    });
  }

  Widget? showAccountDeleteConfirmation(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String message = '';
        return AlertDialog(
          alignment: Alignment.centerLeft,
          title: Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Are you sure to delete your account? If yes, please type your username(${user.username}) below:",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextField(
                      controller: _usernameConfirmationController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      ),
                      style: TextStyle(fontSize: 15, height: 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${message}',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Container(
                          width: 70,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius:
                                new BorderRadius.all(Radius.circular(3)),
                            color: Colors.grey,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: Text(
                              "No",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            message = '';
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        child: Container(
                          width: 70,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius:
                                new BorderRadius.all(Radius.circular(3)),
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        onTap: () {
                          if (_usernameConfirmationController.text == '') {
                            setState(() {
                              message = 'Please type your username';
                            });
                          } else if (_usernameConfirmationController.text !=
                              user.username) {
                            setState(() {
                              message = 'Please type correct username';
                            });
                          } else if (_usernameConfirmationController.text ==
                              user.username) {
                            setState(() {
                              message = '';
                            });

                            _deactivateAccount(context);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Future<void> _deactivateAccount(ctx) async {
    bool isOnline = await Utils.hasNetwork();
    if (isOnline) {
      Map userDeviceParams = {'user_id': '${authId}'};
      await Provider.of<UserDeviceViewModel>(context, listen: false)
          .removeDeviceId(userDeviceParams, '${authToken}');
      await Provider.of<UserViewModel>(context, listen: false)
          .deactiveAccount({'id': '${authId}'}, '${authToken}');
      AppSharedPref.logout(context);
    } else {
      Utils.toastMessage('No internet connection!');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Constants.titleImage2(context),
      ),
      body: Container(
          color: Constants.np_bg_clr,
          child: Padding(
            padding: EdgeInsets.only(
                left: Constants.np_padding_only,
                right: Constants.np_padding_only,
                top: Constants.np_padding_only),
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      Text(
                        'Settings',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                settingMenu('Edit Social Information',
                    'edit-social-information', Icons.edit, Colors.white),
                settingMenu('Change Password', 'change-password', Icons.edit,
                    Colors.white),
                settingMenu('Privacy Management', 'privacy-management',
                    Icons.edit, Colors.white),
                settingMenu(
                    'Blocklist', 'block-list', Icons.edit, Colors.white),
                settingMenu('Delete Account', 'delete-account',
                    Icons.delete_forever_sharp, Colors.red),
              ],
            ),
          )),
      backgroundColor: Colors.white,
    );
  }

  Widget settingMenu(String title, String route, IconData icon, Color color) {
    var userViewModel = Provider.of<UserViewModel>(context);
    User? user = userViewModel.getUser;
    return Card(
      color: color,
      child: Container(
        padding: EdgeInsets.only(left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 17),
            ),
            InkWell(
              onTap: () {
                if (route == 'edit-social-information') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditSocialInformationScreen()));
                }
                if (route == 'change-password') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdatePasswordScreen()));
                }
                if (route == 'privacy-management') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacyManagementScreen()));
                }
                if (route == 'block-list') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BlockScreen()));
                }
                if (route == 'delete-account') {
                  showAccountDeleteConfirmation(context, user!);
                }
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Icon(
                  icon,
                  size: 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
