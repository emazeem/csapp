import 'dart:convert';

import 'package:connect_social/res/app_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart';
import 'package:indexed/indexed.dart';
import 'package:connect_social/model/UDetails.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/view_model/auth_view_model.dart';
import 'package:connect_social/view_model/u_details_view_model.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:connect_social/utils/utils.dart';
import 'package:connect_social/res/routes.dart' as route;
import 'package:shared_preferences/shared_preferences.dart';

class AccountVerificationScreen extends StatefulWidget {
  const AccountVerificationScreen();

  @override
  State<AccountVerificationScreen> createState() =>
      _AccountVerificationScreenState();
}

class _AccountVerificationScreenState extends State<AccountVerificationScreen> {
  var authId;
  var authToken;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();
      Provider.of<UserViewModel>(context, listen: false).getUserDetails({'id': '${authId}'}, '${authToken}');

    });
  }

  Widget build(BuildContext context){
    User? user = Provider.of<UserViewModel>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Connect Social'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Container(
                  color: Constants.np_bg_clr,
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
                                  transform:
                                  Matrix4.translationValues(0.0, -40, 0.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Image(
                                          width: 130,
                                          image: AssetImage('assets/images/logo.png'),
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
                                  child: Column(
                                    children: [
                                      Card(
                                        color: Colors.white,
                                        child: SizedBox(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(20, 100, 20, 50),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child:Text('Account Verification',style: TextStyle(fontWeight: FontWeight.w400,fontSize:20),),
                                                    ),
                                                    Container(
                                                        padding: const EdgeInsets.all(10),
                                                        child:Text('Dear ${user?.fname} ${user?.lname}, Thank you for registering on Connect Social. Please verify your email using following link:')
                                                    ),
                                                    Container(
                                                        padding: const EdgeInsets.all(10),
                                                        child:Text(AppUrl.url+'email/verify',style: TextStyle(color: Colors.blue),)
                                                    ),

                                                    Container(
                                                        width:MediaQuery.of(context).size.width * 1,
                                                        height: 50,
                                                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            primary: Colors.black,
                                                          ),
                                                          child:Text('Logout'),
                                                          onPressed: () async {
                                                            await AppSharedPref.logout(context);
                                                          },
                                                        )),

                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
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
          ],
        ),
      ),
    );
  }
}
