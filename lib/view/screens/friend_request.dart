
import 'package:flutter/material.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/other_profile.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:connect_social/model/apis/api_response.dart';

class FriendRequestScreen extends StatefulWidget {
  const FriendRequestScreen({
    Key? key,
    this.user_id,
  }) : super(key: key);
  final int? user_id;

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  bool authUser = false;
  bool refreshBtn = true;
  int? authId;
  Map? data = {};
  List<User> friends = [];
  String? authToken;
  String _networkType = 'friends';

  List? networks = [
    {'title': 'Friends', 'key': 'friends'},
    {'title': 'Connections', 'key': 'connections'},
  ];

  // Future<void> _initializeApp(BuildContext context) async {}

  Future<void> _pullRefresh(ctx, key) async {
    data = {'id': '${authId}', 'key': key};
    Provider.of<UserViewModel>(context, listen: false).setFriendsRequestResponse([]);
    Provider.of<UserViewModel>(context, listen: false).fetchFriendsRequest(data!, '${authToken}');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();
      _pullRefresh(context, 'friends');
    });
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    List<User?> friends = Provider.of<UserViewModel>(context).getFriendsRequest;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Constants.titleImage(context),
      ),
      body: Container(
        color: Constants.np_bg_clr,
        child: Padding(
          padding: EdgeInsets.all(Constants.np_padding_only),
          child: RefreshIndicator(
            child: ListView(
                children: [
              Container(
                  child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text('Network Requests', style: TextStyle(fontSize: 20))
                  ],
                ),
              )),
              Divider(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  for (var item in networks!) ...[
                    InkWell(
                      onTap: () {
                        setState(() {
                          _networkType = item['key'];
                        });
                        _pullRefresh(context, item['key']);
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          color: (_networkType == item['key'])
                              ? Colors.black
                              : Colors.grey.shade200,
                          padding:EdgeInsets.symmetric( vertical: 10),
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (_networkType == item['key'])
                                  ? MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(invertColors: true),
                                      child: Image.asset(
                                        'assets/images/${item['key']}.png',
                                        width: 20,
                                      ),
                                    )
                                  : Image.asset(
                                      'assets/images/${item['key']}.png',
                                      width: 20,
                                    ),
                              Text(
                                '${item['title']}',
                                style: TextStyle(
                                  color: (_networkType == item['key'])
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              )
                            ],
                          )),
                    )
                  ],
                ]),
              ),
              Divider(),
              if (_userViewModel.getFetchFriendRequestStatus.status == Status.IDLE) ...[
                if (friends.length == 0) ...[
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(Constants.np_padding),
                      child: Text('No network requests.'),
                    ),
                  )
                ]
                else ...[
                  for (var friend in friends) friendRequestCard(friend),
                ],
              ]
              else if (_userViewModel.getFetchFriendRequestStatus.status == Status.BUSY) ...[
                Container(
                  height: 100,
                  child: Center(
                    child: Utils.LoadingIndictorWidtet(size: 40.0),
                  ),
                ),
              ],
            ]),
            onRefresh: () async {
              _pullRefresh(context, _networkType);
            },
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget friendRequestCard(User? user) {

    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    acceptOrRejectRequest(type,status) async {
      dynamic response;
      if(type=='friend'){
        response = await _userViewModel.acceptOrRejectFriendRequest({'id': '${user?.id}', 'auth_id': '${authId}', 'status': status}, '${authToken}');
      }
      if(type=='connection'){
        response = await _userViewModel.acceptOrRejectConnectionRequest({'id': '${user?.id}', 'auth_id': '${authId}', 'status': status}, '${authToken}');
      }

      if (response['success'] == true) {
        Utils.toastMessage(response['message']);
        _pullRefresh(context, _networkType);

      } else {
        Utils.toastMessage('Some error occurred.!');
      }
    }


    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfileScreen(user?.id)));
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network('${Constants.profileImage(user)}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover, errorBuilder: (BuildContext context,
                        Object exception, StackTrace? stackTrace) {
                  return Constants.defaultImage(50.0);
                }),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    width: 150,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '${user?.fname} ${user?.lname}',
                          style: TextStyle(fontSize: 16),
                        )),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    height: 30,
                    color: Constants.np_yellow,
                    child: InkWell(
                      onTap: () async{
                        await acceptOrRejectRequest(
                            (_networkType=='friends')?'friend':'connection','1'
                        );

                      },
                      child: Row(
                        children: [
                          Icon(Icons.check, size: 15, color: Colors.white),
                          /*Text(
                            'Accept',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(2)),
                  Container(
                    height: 30,
                    color: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      onTap: () async{
                        await acceptOrRejectRequest(
                            (_networkType=='friends')?'friend':'connection','2'
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.close, size: 15, color: Colors.white),
                          /*Text(
                            'Reject',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
