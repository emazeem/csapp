import 'package:flutter/material.dart';
import 'package:connect_social/model/Friend.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/other_profile.dart';
import 'package:connect_social/view/screens/widgets/layout.dart';
import 'package:connect_social/view_model/friend_view_model.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchTxtController = TextEditingController();
  Widget noResults = Padding(
    padding: EdgeInsets.only(top: 30),
    child: Text(
      'No results',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey),
    ),
  );
  var authToken;
  List<Widget> searchResults = [];
  List<User> searchedData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      Provider.of<UserViewModel>(context, listen: false);
      //Provider.of<UserViewModel>(context).getSearchUser;
    });
    searchResults.add(noResults);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _searchTxtController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Constants.titleImage(context),
      ),
      backgroundColor: Constants.np_bg_clr,
      body:Container(
        padding: EdgeInsets.all(10),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child:TextField(
                  onSubmitted: (value) async {
                    if(value==''){
                      Utils.toastMessage('Enter key to search users.');
                    }else{
                      setState(() {
                        searchResults = [Utils.LoadingIndictorWidtet(),];
                      });
                      Map data = {'search': value};
                      dynamic users = await userViewModel.searchUsers(data, authToken);
                      print('users::: ${users}');
                      if (users.length == 0) {
                        setState(() {
                          searchResults = [];
                          searchResults.add(noResults);
                        });
                      } else {
                        setState(() {
                          searchResults = [];
                          users.forEach((element) async {
                            String profile = await Constants.profileImage(element);
                            searchResults.add(resultsCard(element, profile));
                          });
                        });
                      }
                    }

                  },
                  controller: _searchTxtController,
                  textInputAction: TextInputAction.search,

                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder:const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: const BorderSide(color: Colors.black, width: 1.0),
                      ),
                      labelText: 'Search User',
                      suffixIcon: Icon(Icons.search),
                      suffixIconColor: Colors.black,
                      labelStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                ),
              ),
              Expanded(
                flex: 6,
                child: ListView(
                  children: searchResults,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget resultsCard(User user, String profile) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfileScreen(user.id)));
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey.shade100),
        )),
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child:Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                '${profile}',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Constants.defaultImage(40.0);
                },
              ),
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${user.fname} ${user.lname}',style: TextStyle(fontSize: 15),),
                    ],
                  )
              ),
            )
          ],
        ),

      ),
    );
  }

}
