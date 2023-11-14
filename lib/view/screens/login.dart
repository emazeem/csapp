import 'dart:io';

import 'package:connect_social/view/screens/account_verification.dart';
import 'package:connect_social/view/screens/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/res/routes.dart' as route;
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/utils.dart';
import 'package:connect_social/view/screens/splash.dart';
import 'package:connect_social/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  bool _passwordVisible = true;

  Future<void>? _launched;
  Future<void> _launchInBrowser(Uri url) async {
    if(Platform.isAndroid){
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch $url';
      }
    }else{
      final UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;
      if (await launcher.canLaunch(url.toString())) {
        await launcher.launch(
          url.toString(),
          useSafariVC: true,
          useWebView: true,
          enableJavaScript: true,
          enableDomStorage: false,
          universalLinksOnly: false,
          headers: <String, String>{'my_header_key': 'my_header_value'},
        );
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString(Constants.authToken);
      if (token != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SplashScreen()));
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: Constants.np_bg_clr,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Image.asset('assets/images/logo 2.png', height: 60),
        ),
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Indexer(
                    children: [
                      Indexed(
                        index: 2,
                        child: Center(
                          child: Container(
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(120)),
                              color: Colors.white,
                            ),
                            transform: Matrix4.translationValues(0.0, -40, 0.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image(
                                    width: 130,
                                    image: AssetImage('assets/images/logo.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Indexed(
                          index: 1,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
                            child: Column(
                              children: [
                                Card(
                                  color: Colors.white,
                                  child: SizedBox(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20, 100, 20, 50),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(
                                                    Constants.np_padding),
                                                child: TextField(
                                                  controller: _emailController,
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Email',
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(
                                                    Constants.np_padding),
                                                child: TextField(
                                                  obscureText: _passwordVisible,
                                                  controller:
                                                      _passwordController,
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Password',
                                                    suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _passwordVisible =
                                                              !_passwordVisible;
                                                        });
                                                      },
                                                      child: new Icon(
                                                          _passwordVisible
                                                              ? Icons.visibility
                                                              : Icons
                                                                  .visibility_off),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    Constants.np_padding),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () => {
                                                        Navigator.pushNamed(
                                                            context,
                                                            route
                                                                .forgotPasswordPage)
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5),
                                                        child: Text(
                                                          'Forgot Password',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              height: 0,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      1,
                                                  height: 50,
                                                  padding: EdgeInsets.all(
                                                      Constants.np_padding),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.black,
                                                    ),
                                                    child: _isLoading
                                                        ? Utils
                                                            .LoadingIndictorWidtet()
                                                        : Text('Login'),
                                                    onPressed: () async {
                                                      if (_emailController
                                                          .text.isEmpty) {
                                                        Utils.toastMessage(
                                                            'Email is required');
                                                      } else if (_passwordController
                                                          .text.isEmpty) {
                                                        Utils.toastMessage(
                                                            'Password is required');
                                                      } else {
                                                        setState(() {
                                                          _isLoading = true;
                                                        });
                                                        Map data = {
                                                          'email':
                                                              _emailController
                                                                  .text,
                                                          'password':
                                                              _passwordController
                                                                  .text,
                                                        };

                                                        Map response =
                                                            await authViewModel
                                                                .loginApi(data,
                                                                    context);
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        if (response['login'] ==
                                                            true) {
                                                          if (response['data']
                                                                      ['user'][
                                                                  'is_deactivated'] ==
                                                              1) {
                                                            Utils.toastMessage(
                                                                'User is deactivated');
                                                          } else {
                                                            Utils.toastMessage(
                                                                response[
                                                                    'message']);
                                                            AppSharedPref
                                                                .saveAuthTokenResponse(
                                                                    response[
                                                                            'data']
                                                                        [
                                                                        'token']);
                                                            AppSharedPref
                                                                .saveLoginUserResponse(
                                                                    response['data']
                                                                            [
                                                                            'user']
                                                                        ['id']);
                                                            print(response);
                                                            if (response['data']
                                                                        ['user']
                                                                    [
                                                                    'email_verified_at'] ==
                                                                null) {
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              AccountVerificationScreen()));
                                                            } else {
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              SplashScreen()));
                                                            }
                                                          }

                                                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                                                        } else {
                                                          setState(() {
                                                            _passwordController
                                                                .text = '';
                                                          });
                                                          Utils.toastMessage(
                                                              response[
                                                                  'message']);
                                                        }
                                                      }
                                                    },
                                                  )),






                                              Container(
                                                padding: EdgeInsets.only(top: 20),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.open_in_new,
                                                      size: 16,
                                                    ),
                                                    InkWell(
                                                      child: Text(
                                                        'Terms',
                                                        style: TextStyle(
                                                          decoration: TextDecoration.underline,
                                                        ),
                                                      ),
                                                      onTap: (){
                                                        setState(() {
                                                          _launched = _launchInBrowser(Uri.parse('https://iamconnect.com/our-policy/payment-terms'));
                                                        });
                                                        FutureBuilder<void>(future: _launched, builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                                                          if (snapshot.hasError) {
                                                            return Text('Error: ${snapshot.error}');
                                                          } else {
                                                            return const Text('');
                                                          }
                                                        });
                                                      },
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 3),
                                                      child: Text('&'),
                                                    ),
                                                    InkWell(
                                                      child: Text(
                                                        'Privacy',
                                                        style: TextStyle(
                                                          decoration: TextDecoration.underline,
                                                        ),
                                                      ),
                                                      onTap: (){
                                                        setState(() {
                                                          _launched = _launchInBrowser(Uri.parse('https://iamconnect.com/our-policy/privacy-policy'));
                                                        });
                                                        FutureBuilder<void>(future: _launched, builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                                                          if (snapshot.hasError) {
                                                            return Text('Error: ${snapshot.error}');
                                                          } else {
                                                            return const Text('');
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),


                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
