import 'package:connect_social/model/Privacy.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view_model/privacy_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatePrivacyScreen extends StatefulWidget {
  final columnKey;
  final column;
  const UpdatePrivacyScreen(this.columnKey, this.column);

  @override
  State<UpdatePrivacyScreen> createState() => _UpdatePrivacyScreenState();
}

class _UpdatePrivacyScreenState extends State<UpdatePrivacyScreen> {
  var authToken;
  var authId;
  bool isProcessing=false;
  List<String>? _updatedPrivacy = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic privacyViewModel = Provider.of<PrivacyViewModel>(context);
    Privacy? privacyValues = privacyViewModel.getPrivacy;

    if (widget.columnKey == 'about') {
      _updatedPrivacy = privacyValues?.about;
    }
    if (widget.columnKey == 'city') {
      _updatedPrivacy = privacyValues?.city;
    }
    if (widget.columnKey == 'state') {
      _updatedPrivacy = privacyValues?.state;
    }
    if (widget.columnKey == 'relationship_status') {
      _updatedPrivacy = privacyValues?.relationship_status;
    }
    if (widget.columnKey == 'joining') {
      _updatedPrivacy = privacyValues?.joining;
    }
    if (widget.columnKey == 'workplace') {
      _updatedPrivacy = privacyValues?.workplace;
    }
    if (widget.columnKey == 'high_school') {
      _updatedPrivacy = privacyValues?.high_school;
    }
    if (widget.columnKey == 'hobbies') {
      _updatedPrivacy = privacyValues?.hobbies;
    }
    if (widget.columnKey == 'email') {
      _updatedPrivacy = privacyValues?.email;
    }
    if (widget.columnKey == 'phone') {
      _updatedPrivacy = privacyValues?.phone;
    }
    if (widget.columnKey == 'gender') {
      _updatedPrivacy = privacyValues?.gender;
    }

    if (widget.columnKey == 'friends') {
      _updatedPrivacy = privacyValues?.friends;
    }
    if (widget.columnKey == 'connections') {
      _updatedPrivacy = privacyValues?.connections;
    }

    List<Widget> allPrivacy = [];
    allPrivacy.add(
      Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Update Privacy of ${widget.column}',
              style: TextStyle(fontSize: 18),
            ),
            InkWell(
              child: Container(
                margin: EdgeInsets.all(10),
                child: Icon(Icons.close),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
    allPrivacy.add(Divider());
    for (var v in Constants.networkList(showOnlyMe: true)) {
      allPrivacy.add(InkWell(
        onTap: () {
          setState(() {
            if (widget.columnKey == 'friends' || widget.columnKey == 'connections') {
              _updatedPrivacy?.clear();
              _updatedPrivacy?.add(v['key']);
            } else {
              setState(() {
                var key = v['key'];
                if (_updatedPrivacy!.contains(key)) {
                  _updatedPrivacy!.remove(key);
                } else {
                  _updatedPrivacy!.add(key);
                  if (_updatedPrivacy!.contains('global') || _updatedPrivacy!.contains('public') || _updatedPrivacy!.contains('only-me')) {
                    _updatedPrivacy!.clear();
                    _updatedPrivacy!.add(key);
                  }
                  if(_updatedPrivacy!.contains('public') && _updatedPrivacy!.contains('global')){
                    _updatedPrivacy!.clear();
                    _updatedPrivacy!.add(key);
                  }
                  if(_updatedPrivacy!.contains('only-me') && (_updatedPrivacy!.contains('global') || _updatedPrivacy!.contains('public'))){
                    _updatedPrivacy!.clear();
                    _updatedPrivacy!.add(key);
                  }
                  if (_updatedPrivacy!.contains('friends') && _updatedPrivacy!.contains('connections') && _updatedPrivacy!.contains('tier-1') && _updatedPrivacy!.contains('tier-2')) {
                    _updatedPrivacy!.clear();
                    _updatedPrivacy!.add('public');
                  }
                }
              });
            }
          });
        },
        child: Container(
          color: (_updatedPrivacy?.contains(v['key']) == true)
              ? Colors.grey.shade300
              : Colors.transparent,
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Image.asset(
                'assets/images/${v['key']}.png',
                width: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(v['title'], style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ));
    }
    allPrivacy.add(Divider());

    allPrivacy.add(
      Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    )),
                child:(isProcessing==true)?Utils.LoadingIndictorWidtet(): Text('Update', style: TextStyle(color: Colors.white),),
              ),
              onTap: () async {
                if (_updatedPrivacy!.length == 0) {
                  Utils.toastMessage('Please select privacy to update.');
                } else {
                  if(isProcessing==false){
                    setState(() { isProcessing=true; });
                    String columnKey = widget.columnKey;
                    dynamic data = {
                      'id': '${authId}',
                      'column': '${columnKey.replaceAll('_', '-')}',
                      'privacies': '${_updatedPrivacy}'
                    };
                    dynamic response = await Provider.of<PrivacyViewModel>(context, listen: false).updatePrivacy(data, authToken);
                    setState(() { isProcessing=false; });
                    Utils.toastMessage('${response['message']}');
                    if (response['data'] == true) {
                      Navigator.pop(context);
                    }
                  }

                }
              },
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Constants.titleImage2(context),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: allPrivacy.length,
          itemBuilder: (context, index) {
            return allPrivacy[index];
          },
        ),
      ),
    );
  }
}
