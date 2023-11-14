import 'package:connect_social/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:connect_social/model/Friend.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/chatbox.dart';
import 'package:connect_social/view/screens/widgets/layout.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:connect_social/model/apis/api_response.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController editingController = TextEditingController();

  var authToken;
  List<User?> friends = [];
  List<User?> allFriends = [];
  String _networkType = 'all';

  int? authId;
  Future<void> _pullRefresh(ctx) async {
    Provider.of<UserViewModel>(context, listen: false).setFriends([]);
    Map data = {'id': '${authId}', 'key': _networkType, 'with_parents': '1'};
    Provider.of<UserViewModel>(context, listen: false)
        .fetchFriends(data, '${authToken}');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();
      _pullRefresh(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    List<User?> friends = _userViewModel.getFriends;

    return Container(
      height: double.infinity,
      color: Constants.np_bg_clr,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Card(
          child: Container(
            child: RefreshIndicator(
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10, left: 20),
                    child: Text('Messages', style: Constants().np_heading),
                  ),
                  Divider(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 2, left: 10, right: 10),
                      child: Row(children: [
                        for (var item in Constants.networkList(
                            internal: true, showAll: true)) ...[
                          InkWell(
                            onTap: () {
                              setState(() {
                                _networkType = item['key'];
                              });
                              _pullRefresh(context);
                            },
                            child: Container(
                                color: (_networkType == item['key'])
                                    ? Colors.black
                                    : Colors.grey.shade200,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 7),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
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
                  ),
                  Divider(),
                  if (_userViewModel.getFetchFriendStatus.status ==
                      Status.IDLE) ...[
                    if (friends.length == 0) ...[
                      Padding(
                        padding: EdgeInsets.all(Constants.np_padding_only),
                        child: Text('No user'),
                      )
                    ] else ...[
                      for (var friend in friends) chatUsersCard(friend),
                    ]
                  ] else if (_userViewModel.getFetchFriendStatus.status ==
                      Status.BUSY) ...[
                    Container(
                      height: 70,
                      child: Utils.LoadingIndictorWidtet(size: 30.0),
                    ),
                  ],
                ],
              ),
              onRefresh: () async {
                _pullRefresh(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget chatUsersCard(User? friend) {
    return InkWell(
      onTap: () => {
        setState(() {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatBoxScreen(friend)))
              .then((value) => _pullRefresh(context));
        })
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(width: 1, color: Constants.np_bg_clr),
        )),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                Constants.profileImage(friend),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Constants.defaultImage(50.0);
                },
              ),
            ),
            Container(
                child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 140,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${friend?.fname} ${friend?.lname}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      (friend?.unread_msg == 0 ||
                                              friend?.unread_msg == null)
                                          ? Container()
                                          : Container(
                                              width: 20,
                                              height: 20,
                                              margin: EdgeInsets.only(left: 10),
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Constants.np_bg_clr,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: Text(
                                                '${friend?.unread_msg}',
                                                style: TextStyle(fontSize: 10),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )))
          ],
        ),
      ),
    );
  }
/*Card(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _searchTextController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Search with name',
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (key){
                      filterSearchResults(key,_userViewModel);
                    },
                  ),
                ),
              ),
              */
}
