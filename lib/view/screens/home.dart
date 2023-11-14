import 'package:flutter/material.dart';
import 'package:connect_social/model/Post.dart';
import 'package:connect_social/model/apis/api_response.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/widgets/show_post.dart';
import 'package:connect_social/view_model/post_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? authToken;
  int? AuthId;
  bool showMoreBtnFlag = true;
  int showMoreCounter = 0;
  Widget _showMoreBtn = Container();
  bool _isLoadingMore = false;

  String _selectedPrivacy = 'public';

  Future<void> _pullRefresh(ctx, showMoreCounter) async {
    showMoreCounter = 0;
    showMoreBtnFlag = true;
    _isLoadingMore = false;
    Provider.of<PostViewModel>(context, listen: false).setPublicPost([]);
    Map data = {
      'id': '${AuthId}',
      'number': '${showMoreCounter}',
      'key': _selectedPrivacy
    };
    Provider.of<PostViewModel>(context, listen: false)
        .fetchAllPost(data, '${authToken}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      AuthId = await AppSharedPref.getAuthId();
      _pullRefresh(context, showMoreCounter);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget build(BuildContext context) {
    PostViewModel postViewModel = Provider.of<PostViewModel>(context);
    List<Post?> post = Provider.of<PostViewModel>(context).getPublicPosts;
    Widget _child = _defaultHomePage('Fetching posts. Please wait.', true);
    showTwoMorePosts(network) async {
      if (_isLoadingMore == false) {
        if (!mounted) return;
        setState(() {
          _isLoadingMore = true;
          showMoreCounter = showMoreCounter + 4;
        });

        Map data = {
          'id': '${AuthId}',
          'number': '${showMoreCounter}',
          'key': network
        };
        List<Post?> twoMorePost =
            await Provider.of<PostViewModel>(context, listen: false)
                .fetchTwoMorePosts(data, '${authToken}');
        if (twoMorePost.isEmpty) {
          setState(() {
            showMoreBtnFlag = false;
          });
        }
        if (!mounted) return;
        setState(() {
          _isLoadingMore = false;
          post.addAll(twoMorePost);
        });
      }
    }

    _showMoreBtn = Visibility(
      visible: showMoreBtnFlag,
      child: InkWell(
          onTap: () {
            showTwoMorePosts(_selectedPrivacy);
          },
          child: Container(
              width: 120,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top:5,bottom: 5),
              decoration: BoxDecoration(
                  color: _isLoadingMore
                      ? Colors.black.withOpacity(0.8)
                      : Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !_isLoadingMore
                      ? Text(
                          'Show more',
                          style: TextStyle(color: Colors.white),
                        )
                      : Text(
                          'Processing',
                          style: TextStyle(color: Colors.white),
                        ),
                  SizedBox(
                    width: 4,
                  ),
                  _isLoadingMore
                      ? Utils.LoadingIndictorWidtet(size: 10.0)
                      : Text('')
                ],
              ))),
    );

    if (postViewModel.fetchAllPostStatus.status == Status.IDLE) {
      if (post.length == 0) {
        _child = _defaultHomePage('Post not found.', false);
      } else {
        _child = Column(
            children: <Widget>[
              for(Post? p in post)...[
                ShowPostCard(p),
              ],
              _showMoreBtn,
            ]);
      }
    } else if (postViewModel.fetchAllPostStatus.status == Status.BUSY) {
      _child = _defaultHomePage('Fetching posts. Please wait.', true);
    }

    return Container(
      color: Constants.np_bg_clr,
        child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding:
                      const EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: Row(children: [
                        for (var item in Constants.networkList()) ...[
                          InkWell(
                            onTap: () {
                              setState(() {
                                _selectedPrivacy = item['key'];
                                print("privacy click");
                              });
                              _pullRefresh(context, 0);
                            },
                            child: Container(
                              //color: _selectedPrivacy==item['key']?Colors.black:Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 7),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 4),
                                  decoration: new BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: _selectedPrivacy !=
                                                  item['key']
                                                  ? Colors.transparent
                                                  : Colors.black))),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/${item['key']}.png',
                                        width: 20,
                                      ),
                                      Text(
                                        item['title'],
                                        style: TextStyle(color: Colors.black
                                          //color:  _selectedPrivacy!=item['key']?Colors.black:Colors.white
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          )
                        ],
                      ]),
                    ),
                  ),
                  Expanded(
                      child:RefreshIndicator(
                          child:ListView(
                            children: [
                              _child
                            ],
                          ),
                          onRefresh: ()async{
                            _pullRefresh(context, showMoreCounter);
                          })
                  )
                ],
              )

    );
  }

  Widget _defaultHomePage(String? text, bool _showLoading) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height - 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 10),
          (_showLoading)
              ? Utils.LoadingIndictorWidtet(size: 30.0)
              : Container(),
        ],
      ),
    );
  }
}
