import 'package:connect_social/model/User.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:connect_social/model/apis/api_response.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/chat.dart';
import 'package:connect_social/view/screens/chatbox.dart';
import 'package:connect_social/view/screens/other_profile.dart';
import 'package:connect_social/view/screens/single_post.dart';
import 'package:connect_social/view/screens/widgets/layout.dart';
import 'package:connect_social/view_model/notification_view_model.dart';
import 'package:connect_social/model/Notification.dart';
import 'package:provider/provider.dart';
import 'package:connect_social/res/routes.dart' as route;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var authToken;
  int? authId;

  Future<void> _pullRefresh(ctx) async {
    Map data = {'id': '${authId}'};
    Provider.of<NotificationViewModal>(context, listen: false)
        .fetchNotifications(data, '${authToken}');
    Provider.of<NotificationViewModal>(context, listen: false)
        .allNotificationsMarkAsRead(data, '${authToken}');
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();
      Provider.of<NotificationViewModal>(context, listen: false)
          .setMyNotification([]);
      _pullRefresh(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    NotificationViewModal notificationViewModal =
        Provider.of<NotificationViewModal>(context);
    List<Notifications?> notifications =
        notificationViewModal.getMyNotification;
    print(notifications);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Constants.titleImage(context),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () async {
            authToken = await AppSharedPref.getAuthToken();
            authId = await AppSharedPref.getAuthId();
            Provider.of<UserViewModel>(context, listen: false).setUser(User());
            Provider.of<UserViewModel>(context, listen: false)
                .getUserDetails({'id': '${authId}'}, '${authToken}');
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
          color: Constants.np_bg_clr,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: RefreshIndicator(
                onRefresh: () async {
                  _pullRefresh(context);
                },
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'All Notifications',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Divider(),
                    if (notificationViewModal.getNotificationStatus.status ==
                        Status.IDLE) ...[
                      if (notifications.length == 0) ...[
                        Card(
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(Constants.np_padding),
                            child: Text('No notification'),
                          ),
                        )
                      ] else ...[
                        for (var notification in notifications)
                          notificationCard(notification),
                      ]
                    ] else if (notificationViewModal
                            .getNotificationStatus.status ==
                        Status.BUSY) ...[
                      Utils.LoadingIndictorWidtet(),
                    ],
                  ],
                ),
              ))),
      backgroundColor: Colors.white,
    );
  }

  Widget notificationCard(Notifications? notification) {
    return InkWell(
      onTap: () {
        if (notification?.url == 'friend') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OtherProfileScreen(notification?.data_id)));
        }
        if (notification?.url == 'post') {
          print(notification?.data_id);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SinglePostScreen(notification?.data_id)));
        }
        if (notification?.url == 'chat') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NPLayout(currentIndex: 3)));
        }
      },
      child: Card(
        color: (notification?.read_at == null)
            ? Colors.grey.shade100
            : Colors.white,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  '${Constants.profileImage(notification?.from)}',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Constants.defaultImage(40.0);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${notification?.from?.fname}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 3)),
                        Text(
                          '${notification?.from?.lname}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: Text(
                        '${notification?.msg}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                    Text(
                      '${notification?.createdat?.h}:${notification?.createdat?.i} ${notification?.createdat?.A} ${notification?.createdat?.m}-${notification?.createdat?.m}-${notification?.createdat?.Y}',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
