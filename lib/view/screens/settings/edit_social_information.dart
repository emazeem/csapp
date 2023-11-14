import 'dart:io';

import 'package:connect_social/model/apis/api_response.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/widgets/textfield_social_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connect_social/model/UDetails.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/view_model/u_details_view_model.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../widgets/phone_textfield_social_info.dart';

class EditSocialInformationScreen extends StatefulWidget {
  const EditSocialInformationScreen({Key? key}) : super(key: key);

  @override
  State<EditSocialInformationScreen> createState() =>
      _EditSocialInformationScreenState();
}

class _EditSocialInformationScreenState
    extends State<EditSocialInformationScreen> {
  var authToken;
  var authId;

  String? gender;
  String? relationship;
  final _aboutController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _workplaceController = TextEditingController();
  final _hobbiesController = TextEditingController();
  //high school is university
  final _highSchoolController = TextEditingController();
  bool isProcessing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('talha:: init state called');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();

      Map data = {'id': '${authId}'};

      Provider.of<UserDetailsViewModel>(context, listen: false)
          .setDetailsResponse(UserDetail());
      await Provider.of<UserDetailsViewModel>(context, listen: false)
          .getUserDetails(data, '${authToken}');

      Provider.of<UserViewModel>(context, listen: false).setemptyUser();
      await Provider.of<UserViewModel>(context, listen: false)
          .getUserDetails(data, '${authToken}');

      UserDetail? userDetail =
          Provider.of<UserDetailsViewModel>(context, listen: false).getDetails;
      relationship = userDetail?.relationship;

      _aboutController.text =
          userDetail?.about == null ? '' : '${userDetail?.about}';
      _cityController.text =
          userDetail?.city == null ? '' : '${userDetail?.city}';
      _stateController.text =
          userDetail?.state == null ? '' : '${userDetail?.state}';
      _workplaceController.text =
          userDetail?.workplace == null ? '' : '${userDetail?.workplace}';
      _highSchoolController.text =
          userDetail?.high_school == null ? '' : '${userDetail?.high_school}';
      _hobbiesController.text =
          userDetail?.hobbies == null ? '' : '${userDetail?.hobbies}';

      User? user = Provider.of<UserViewModel>(context, listen: false).getUser;

      gender = user?.gender;
      _firstNameController.text = '${user?.fname}';
      _lastNameController.text = '${user?.lname}';
    });
  }

  @override
  void dispose() {
    _aboutController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _workplaceController.dispose();
    _hobbiesController.dispose();
    _highSchoolController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    UserDetailsViewModel userDetailViewModel =
        Provider.of<UserDetailsViewModel>(context);
    User? user = userViewModel.getUser;
    UserDetail? userDetail =
        Provider.of<UserDetailsViewModel>(context).getDetails;

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
                                'Edit Social Information',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                        if (userDetailViewModel.getUserDetailStatus.status ==
                            Status.IDLE) ...[
                          if (user?.fname == null &&
                              userDetail?.relationship == null) ...[
                            Container(
                              height: MediaQuery.of(context).size.height - 200,
                              child: Center(
                                child: Utils.LoadingIndictorWidtet(),
                              ),
                            )
                          ] else ...[
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 10, left: 5, right: 5),
                                    child: TextField(
                                      controller: _firstNameController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'First Name',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 10, left: 5, right: 5),
                                    child: TextField(
                                      controller: _lastNameController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Last Name',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 10, left: 5, right: 5),
                                    child: TextField(
                                      controller: _aboutController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'About',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 10, left: 5, right: 5),
                                    child: TextField(
                                      controller: _cityController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'City',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 10, left: 5, right: 5),
                                    child: TextField(
                                      controller: _stateController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Current State',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 10, left: 5, right: 5),
                                    child: TextField(
                                      controller: _workplaceController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Workplace',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 10, left: 5, right: 5),
                                    child: TextField(
                                      controller: _highSchoolController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'High School',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 10, left: 5, right: 5),
                                    child: TextField(
                                      controller: _hobbiesController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Hobbies',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3),
                                        ),
                                        side: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 5,
                                            bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Gender'),
                                            Row(
                                              children: [
                                                (gender == null)
                                                    ? Utils
                                                        .LoadingIndictorWidtet()
                                                    : Text(gender!),
                                                PopupMenuButton<String>(
                                                    color: Colors.white,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    // Callback that sets the selected popup menu item.
                                                    onSelected: (String pri) {
                                                      setState(() {
                                                        gender = pri;
                                                      });
                                                    },
                                                    itemBuilder: (BuildContext
                                                            context) =>
                                                        <
                                                            PopupMenuEntry<
                                                                String>>[
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: 'Male',
                                                            child: Text('Male'),
                                                          ),
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: 'Female',
                                                            child:
                                                                Text('Female'),
                                                          ),
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: 'Other',
                                                            child:
                                                                Text('Other'),
                                                          ),
                                                        ]),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3),
                                        ),
                                        side: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 5,
                                            bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Relationship'),
                                            Row(
                                              children: [
                                                (relationship == null)
                                                    ? Utils
                                                        .LoadingIndictorWidtet()
                                                    : Text('${relationship}'),
                                                PopupMenuButton<String>(
                                                    color: Colors.white,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    // Callback that sets the selected popup menu item.
                                                    onSelected: (String pri) {
                                                      setState(() {
                                                        relationship = pri;
                                                      });
                                                    },
                                                    itemBuilder: (BuildContext
                                                            context) =>
                                                        <
                                                            PopupMenuEntry<
                                                                String>>[
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: 'Single',
                                                            child:
                                                                Text('Single'),
                                                          ),
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: 'Married',
                                                            child:
                                                                Text('Married'),
                                                          ),
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: 'Widow',
                                                            child:
                                                                Text('Widow'),
                                                          ),
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: 'Engaged',
                                                            child:
                                                                Text('Engaged'),
                                                          ),
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: 'Divorced',
                                                            child: Text(
                                                                'Divorced'),
                                                          ),
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: 'Separated',
                                                            child: Text(
                                                                'Separated'),
                                                          ),
                                                          const PopupMenuItem<
                                                              String>(
                                                            value:
                                                                'Complicated',
                                                            child: Text(
                                                                'Complicated'),
                                                          ),
                                                        ]),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          height: 50,
                                          padding: EdgeInsets.only(top: 10),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.black,
                                            ),
                                            child: (isProcessing == true)
                                                ? Utils.LoadingIndictorWidtet()
                                                : Text('Update'),
                                            onPressed: () async {
                                              if (_firstNameController
                                                  .text.isEmpty) {
                                                Utils.toastMessage(
                                                    'First name is required');
                                              } else if (_lastNameController
                                                  .text.isEmpty) {
                                                Utils.toastMessage(
                                                    'Last Name is required');
                                              } else {
                                                Map data = {
                                                  'id': '${user?.id}',
                                                  'fname':
                                                      '${_firstNameController.text}',
                                                  'lname':
                                                      '${_lastNameController.text}',
                                                  'about':
                                                      '${_aboutController.text}',
                                                  'city':
                                                      '${_cityController.text}',
                                                  'state':
                                                      '${_stateController.text}',
                                                  'workplace':
                                                      '${_workplaceController.text}',
                                                  'hobbies':
                                                      '${_hobbiesController.text}',
                                                  'high_school':
                                                      '${_highSchoolController.text}',
                                                  'gender': gender,
                                                  'relationship': relationship,
                                                };
                                                if (isProcessing == false) {
                                                  setState(() {
                                                    isProcessing = true;
                                                  });
                                                  dynamic response =
                                                      await userDetailViewModel
                                                          .updateSocialInfo(
                                                              data,
                                                              '${authToken}');
                                                  if (response['success'] ==
                                                      true) {
                                                    Provider.of<UserViewModel>(
                                                            context,
                                                            listen: false)
                                                        .setemptyUser();
                                                    await Provider.of<
                                                                UserViewModel>(
                                                            context,
                                                            listen: false)
                                                        .getUserDetails(data,
                                                            '${authToken}');
                                                    Utils.toastMessage(
                                                        '${response['message']}');
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    Utils.toastMessage(
                                                        '${response['message']}');
                                                  }
                                                  setState(() {
                                                    isProcessing = false;
                                                  });
                                                }
                                              }
                                            },
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ]
                        ] else if (userDetailViewModel
                                .getUserDetailStatus.status ==
                            Status.BUSY) ...[
                          Container(
                            height: MediaQuery.of(context).size.height - 200,
                            child: Center(
                              child: Utils.LoadingIndictorWidtet(),
                            ),
                          )
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
      backgroundColor: Colors.white,
    );
  }
}
