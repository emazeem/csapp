import 'dart:io';

import 'package:connect_social/model/Privacy.dart';
import 'package:connect_social/model/apis/api_response.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/settings/update_privacy.dart';
import 'package:connect_social/view_model/privacy_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connect_social/model/UDetails.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/res/app_url.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/view_model/u_details_view_model.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PrivacyManagementScreen extends StatefulWidget {
  const PrivacyManagementScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyManagementScreen> createState() =>
      _PrivacyManagementScreenState();
}

class _PrivacyManagementScreenState extends State<PrivacyManagementScreen> {
  var authToken;
  var authId;
  List<String>? updatedPrivacy;
  Future<void> _pullRefresh(ctx) async {
    Map data = {'id': '${authId}'};
    Provider.of<PrivacyViewModel>(context, listen: false).setPrivacy(Privacy());
    Provider.of<PrivacyViewModel>(context, listen: false)
        .fetchPrivacy(data, '${authToken}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();
      _pullRefresh(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                Card(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(Icons.edit_note),
                              Text(
                                'Privacy Settings',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '1. Social Information',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        privacyCard('About', 'about'),
                        privacyCard('City', 'city'),
                        privacyCard('Current State', 'state'),
                        privacyCard(
                            'Relationship Status', 'relationship_status'),
                        privacyCard('Date of Joining', 'joining'),
                        privacyCard('Workplace', 'workplace'),
                        privacyCard('High School', 'high_school'),
                        privacyCard('Hobbies', 'hobbies'),
                        privacyCard('Email', 'email'),
                        privacyCard('Mobile Number', 'phone'),
                        privacyCard('Gender', 'gender'),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '2. Network',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        privacyCard('Friends List', 'friends'),
                        privacyCard('Connections List', 'connections'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
      backgroundColor: Colors.white,
    );
  }

  Widget privacyCard(String column, String columnKey) {
    PrivacyViewModel privacyViewModel = Provider.of<PrivacyViewModel>(context);
    Privacy? privacyValues = privacyViewModel.getPrivacy;

    Widget image = Container();

    if (privacyViewModel.fetchPrivacyStatus.status == Status.BUSY) {
      image = Container();
    } else {
      if (columnKey == 'about') {
        image = privacyImage(privacyValues?.about);
      }
      if (columnKey == 'city') {
        image = privacyImage(privacyValues?.city);
      }
      if (columnKey == 'state') {
        image = privacyImage(privacyValues?.state);
      }
      if (columnKey == 'relationship_status') {
        image = privacyImage(privacyValues?.relationship_status);
      }
      if (columnKey == 'joining') {
        image = privacyImage(privacyValues?.joining);
      }
      if (columnKey == 'workplace') {
        image = privacyImage(privacyValues?.workplace);
      }
      if (columnKey == 'high_school') {
        image = privacyImage(privacyValues?.high_school);
      }
      if (columnKey == 'hobbies') {
        image = privacyImage(privacyValues?.hobbies);
      }
      if (columnKey == 'email') {
        image = privacyImage(privacyValues?.email);
      }
      if (columnKey == 'phone') {
        image = privacyImage(privacyValues?.phone);
      }
      if (columnKey == 'gender') {
        image = privacyImage(privacyValues?.gender);
      }
      if (columnKey == 'friends') {
        image = privacyImage(privacyValues?.friends);
      }
      if (columnKey == 'connections') {
        image = privacyImage(privacyValues?.connections);
      }
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                child: InkWell(
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 10, bottom: 10, right: 10),
                      child: Icon(
                        Icons.edit,
                        size: 12,
                      )),
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UpdatePrivacyScreen(columnKey, column)))
                        .then((value) => _pullRefresh(context));
                  },
                ),
              ),
              Text(column),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: image,
          ),
        ],
      ),
    );
  }

  Widget privacyImage(List<String>? privacyList) {
    List<Widget> privacyWidgets = [];
    if (privacyList?.length == 1) {
      privacyList?.forEach((element) {
        privacyWidgets.add(Image.asset(
          'assets/images/${element}.png',
          width: 20,
          height: 20,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Constants.defaultImage(20.0);
          },
        ));
      });
    } else {
      String tooltip = '';
      privacyList?.forEach((element) {
        tooltip += element + ' ';
      });
      privacyWidgets.add(Tooltip(
        message: '${tooltip}',
        child: Image.asset(
          'assets/images/custom-privacy.png',
          width: 20,
          height: 20,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Constants.defaultImage(20.0);
          },
        ),
      ));
    }
    return Container(
        child: Row(
      children: privacyWidgets,
    ));
  }
}
