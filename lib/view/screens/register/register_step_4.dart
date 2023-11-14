import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:indexed/indexed.dart';
import 'package:intl/intl.dart';
import 'package:connect_social/model/UDetails.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/view/screens/account_verification.dart';
import 'package:connect_social/view/screens/home.dart';
import 'package:connect_social/view/screens/new_password.dart';
import 'package:connect_social/view_model/auth_view_model.dart';
import 'package:connect_social/view_model/u_details_view_model.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:connect_social/utils/utils.dart';
import 'package:connect_social/res/routes.dart' as route;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterRejectedScreen extends StatefulWidget {
  const RegisterRejectedScreen();

  @override
  State<RegisterRejectedScreen> createState() => _RegisterRejectedScreenState();
}

class _RegisterRejectedScreenState extends State<RegisterRejectedScreen> {

  var authId;
  var authToken;

  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _npiController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading=false;
  String? gender = 'Male';

  changeGender(value){
    setState(() {
      gender=value;
    });
    return true;
  }
  var inputFormat = DateFormat('yyyy-M-dd');
  //Method for showing the date picker
  void _chooseDateDialog() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        //which date will display when user open the picker
        firstDate: DateTime(1950),
        //what will be the previous supported year in picker
        lastDate: DateTime
            .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();
      Provider.of<UserViewModel>(context, listen: false).getUserDetails({'id': '${authId}'}, '${authToken}');
    });
  }

  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    User? user = Provider.of<UserViewModel>(context).getUser;
    UserDetail? u_details = Provider.of<UserDetailsViewModel>(context).getDetails;
    _usernameController.text='${user?.username}';
    _phoneController.text='${user?.phone}';
    _npiController.text='${u_details?.npi}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('NP Social'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
              left: Constants.np_padding_only,
              right: Constants.np_padding_only,
              top: 20),
          child: Card(
            shadowColor: Colors.black12,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListView(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Your identification is rejected by Super Admin',
                    style: Constants().np_heading,
                  ),
                ),
                Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: Text('Rejection reason:',style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('${u_details?.kyc_reject_reason}'),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: (){
                        AppSharedPref.logout(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(Constants.np_padding_only),
                        child: Row(
                          children: [
                            Icon(Icons.logout,color: Constants.np_yellow,),
                            Text('Logout',style: TextStyle(color: Constants.np_yellow,),),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone',
                        prefixIcon: Icon(Icons.plus_one),
                      ),
                      keyboardType: TextInputType.phone
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    controller: _npiController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'NPI Number',
                    ),
                    inputFormatters:<TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(3),),
                      side: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('Gender'),
                              Theme(
                                data: Theme.of(context).copyWith(
                                  cardColor: Colors.white,
                                ),
                                child: PopupMenuButton<String>(
                                    icon: Icon(Icons.arrow_drop_down),
                                    color: Colors.white,
                                    onSelected: (String pri) {
                                      changeGender(pri);
                                    },
                                    itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'Male',
                                        child: Text('Male'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'Female',
                                        child: Text('Female'),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                          Text(gender!),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: MediaQuery.of(context).size.width * 1,
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      child: _isLoading ? Utils.LoadingIndictorWidtet() : Text('Re Submit'),

                      onPressed: () async {

                        if (_phoneController.text.isEmpty) {
                          Utils.toastMessage('Phone is required.');
                        } else if (_npiController.text.isEmpty) {
                          Utils.toastMessage('NPI number is required.');
                        } else if (_usernameController.text.isEmpty) {
                          Utils.toastMessage('Username is required.');
                        }/* else if (_selectedDate==null) {
                          Utils.toastMessage('Date of birth is required.');
                        }*/ else {

                          Map<dynamic,dynamic> data = {
                            'id':'${user?.id}',
                            'phone': _phoneController.text,
                            'npi': _npiController.text,
                            'gender': gender,
                            'username': _usernameController.text,
                            /*'dob': inputFormat.format(_selectedDate!),*/
                          };
                          setState(() { _isLoading=true; });
                          Map response = await authViewModel.afterRejected(data, authToken);
                          setState(() { _isLoading=false; });
                          if (response['register'] == true) {
                            Utils.toastMessage(response['message']);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountVerificationScreen()));
                          } else {
                            Utils.toastMessage(response['message']);
                          }
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
