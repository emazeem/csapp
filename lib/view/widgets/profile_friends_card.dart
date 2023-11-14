import 'package:flutter/material.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/chatbox.dart';
import 'package:connect_social/view/screens/other_profile.dart';
import 'package:connect_social/res/routes.dart' as route;
import 'package:connect_social/view/screens/profile.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfileFriendCard extends StatefulWidget {
  final User? user;

  const ProfileFriendCard(this.user);

  @override
  State<ProfileFriendCard> createState() => _ProfileFriendCardState();
}

class _ProfileFriendCardState extends State<ProfileFriendCard> {
  var authToken;
  var authId;

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
    return InkWell(
      onTap: () {
        if (widget.user?.id == authId) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfileScreen(widget.user?.id)));
        }
      },
      child: Container(
          width: MediaQuery.of(context).size.width/3.61,
          height: MediaQuery.of(context).size.width/3.61+20,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/image-placeholder.png',
                image:'${Constants.profileImage(widget.user)}',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.width/3.61,
                width: MediaQuery.of(context).size.width/3.61,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Constants.defaultImage(MediaQuery.of(context).size.width/3.61);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 3),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  '${widget.user?.fname} ${widget.user?.lname}',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            /*InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatBoxScreen(widget.user)));
                },
                child: Text(
                  'Send message',
                  style: TextStyle(fontSize: 11),
                ),
              )
              */
          ],
        )
      ),
    );
  }
}
