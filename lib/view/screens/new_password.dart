import 'dart:convert';

import 'package:connect_social/view/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/view/screens/home.dart';
import 'package:connect_social/view_model/auth_view_model.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:connect_social/utils/utils.dart';
import 'package:connect_social/res/routes.dart' as route;
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String? email;
  const CreateNewPasswordScreen(this.email);

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();

  bool _passwordVisible1 = true;
  bool _passwordVisible2 = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Constants.checkToken(context);
    });
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _newPasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    bool _isLoading = false;
    final userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Constants.titleImage2(context),
      ),
      backgroundColor: Constants.np_bg_clr,
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Container(
                  color: Constants.np_bg_clr,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Indexer(
                            children: [
                              Indexed(
                                index: 2,
                                child: Center(
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                          const Radius.circular(120)),
                                      color: Colors.white,
                                    ),
                                    transform: Matrix4.translationValues(
                                        0.0, -40, 0.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image(
                                            width: 130,
                                            image: AssetImage(
                                                'assets/images/logo.png'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Indexed(
                                  index: 1,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
                                    child: Card(
                                      color: Colors.white,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 100, 10, 0),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                'Create New Password',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                    'Provide OTP below sent to your email [${widget.email}]')),
                                            Container(
                                              padding: EdgeInsets.only(top: 10),
                                              child: TextField(
                                                controller: _otpController,
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      'Enter OTP 6-Digit Code',
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 10),
                                              child: TextField(
                                                obscureText: _passwordVisible1,
                                                controller:
                                                    _newPasswordController,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'New Password',
                                                  suffixIcon: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _passwordVisible1 =
                                                            !_passwordVisible1;
                                                      });
                                                    },
                                                    child: new Icon(
                                                        _passwordVisible1
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 10),
                                              child: TextField(
                                                obscureText: _passwordVisible2,
                                                controller:
                                                    _confirmPasswordController,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      'Confirm New Password',
                                                  suffixIcon: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _passwordVisible2 =
                                                            !_passwordVisible2;
                                                      });
                                                    },
                                                    child: new Icon(
                                                        _passwordVisible2
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 10),
                                                height: 70,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.black,
                                                  ),
                                                  child: (_isLoading)
                                                      ? Utils
                                                          .LoadingIndictorWidtet()
                                                      : Text('Create Password'),
                                                  onPressed: () async {
                                                    if (_newPasswordController
                                                        .text.isEmpty) {
                                                      Utils.toastMessage(
                                                          'New Password is required');
                                                    } else if (_confirmPasswordController
                                                        .text.isEmpty) {
                                                      Utils.toastMessage(
                                                          'Current Password is required');
                                                    } else if (_otpController
                                                            .text.length !=
                                                        6) {
                                                      Utils.toastMessage(
                                                          'OTP must be 6-Digit number');
                                                    } else if (_otpController
                                                        .text.isEmpty) {
                                                      Utils.toastMessage(
                                                          'OTP is required');
                                                    } else if (_confirmPasswordController
                                                            .text !=
                                                        _newPasswordController
                                                            .text) {
                                                      Utils.toastMessage(
                                                          'Confirm password does not match');
                                                    } else {
                                                      Map data = {
                                                        'email':
                                                            '${widget.email}',
                                                        'new_password':
                                                            _newPasswordController
                                                                .text,
                                                        'confirm_password':
                                                            _confirmPasswordController
                                                                .text,
                                                        'otp':
                                                            _otpController.text
                                                      };
                                                      setState(() {
                                                        _isLoading = true;
                                                      });
                                                      Map response =
                                                          await userViewModel
                                                              .createNewPassword(
                                                                  data);
                                                      if (response['success'] ==
                                                          true) {
                                                        Utils.toastMessage(
                                                            response[
                                                                'message']);
                                                        Navigator.of(context)
                                                            .pushAndRemoveUntil(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            LoginScreen()),
                                                                (Route<dynamic>
                                                                        route) =>
                                                                    false);
                                                      } else {
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        Utils.toastMessage(
                                                            response[
                                                                'message']);
                                                      }
                                                    }
                                                  },
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
