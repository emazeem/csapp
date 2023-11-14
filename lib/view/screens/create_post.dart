import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/res/app_url.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/res/routes.dart' as route;
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/widgets/layout.dart';
import 'package:connect_social/view_model/post_view_model.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class CreatePostScreen extends StatefulWidget {
  final String? type;

  const CreatePostScreen(this.type);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  var authToken;
  var authId;

  final _detailsTxtController = TextEditingController();
  File? postImage;
  XFile? imagePath;
  File? postAudio;
  File? postVideo;
  File? videThumbnail;
  int _isUploading = 0;
  List<String?> _selectedPrivacy = [];

  bool? isSelectedFile = false;

  Widget privacyBox(icon, title) {
    return InkWell(
      onTap: () {
        addPrivacyString(icon);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: (_selectedPrivacy.contains(icon))
              ? Colors.grey.shade300
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/${icon}.png',
              width: 20,
            ),
            Text(title,
                style: TextStyle(
                  fontSize: 15,
                )),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();
    });
    _selectedPrivacy.add('public');
  }

  void getImage(String type) async {
    final ImagePicker _picker = ImagePicker();
    imagePath = await _picker.pickImage(
      source: (type == 'gallery') ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 100,
      maxHeight: 800,
    );
    if (imagePath != null) {
      File file = File(imagePath!.path);
      double temp = file.lengthSync() / (1024 * 1024);
      setState(() {
        isSelectedFile = true;
      });
      postImage = file;
    } else {
      setState(() {
        isSelectedFile = false;
      });
      Utils.toastMessage('Image not selected!');
    }
  }

  void removeAttachment() {
    if (widget.type == 'image') {
      imagePath = null;
      postImage = null;
    }
    if (widget.type == 'video') {
      postVideo = null;
    }
    if (widget.type == 'audio') {
      postAudio = null;
    }
    setState(() {
      isSelectedFile = false;
    });
  }

  void _pickVideoFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowCompression: true,
      type: FileType.video,
    );
    String? _path;
    try {
      _path = await VideoThumbnail.thumbnailFile(
        video: result!.files.single.path!,
        thumbnailPath: (await getTemporaryDirectory()).path,

        /// path_provider
        imageFormat: ImageFormat.PNG,
        maxHeight: 800,
        quality: 100,
      );
    } catch (e) {
      print(e);
    }
    if (result != null) {
      postVideo = File(result.files.single.path!);
      if (_path != null) {
        videThumbnail = File(_path!);
      }
      double temp =
          File(result.files.single.path!).lengthSync() / (1024 * 1024);
      setState(() {
        isSelectedFile = true;
      });
      if (temp >= 20) {
        Utils.toastMessage('Video should be less than 20MB.');
        postVideo = null;
        setState(() {
          isSelectedFile = false;
        });
      }
    } else {
      result = null;
      setState(() {
        isSelectedFile = false;
      });
      Utils.toastMessage('Video not selected!');
    }
  }

  void _pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowCompression: true,
        allowedExtensions: ['mp3', 'wav', 'ogg', 'm4a'],
        type: FileType.custom);

    if (result != null) {
      postAudio = File(result.files.single.path!);
      double temp =
          File(result.files.single.path!).lengthSync() / (1024 * 1024);
      setState(() {
        isSelectedFile = true;
      });
      if (temp >= 20) {
        Utils.toastMessage('Video should be less than 20MB.');
        postAudio = null;
        setState(() {
          isSelectedFile = false;
        });
      }
    } else {
      postAudio = null;
      setState(() {
        isSelectedFile = false;
      });
      Utils.toastMessage('Audio not selected!');
    }
  }

  pickRespectiveFile() {
    if (widget.type == 'image') {
      getImage('gallery');
    }
    if (widget.type == 'video') {
      _pickVideoFile();
    }
    if (widget.type == 'audio') {
      _pickAudioFile();
    }
  }

  addPrivacyString(key) {
    setState(() {
      if (_selectedPrivacy.contains(key)) {
        _selectedPrivacy.remove(key);
      } else {
        _selectedPrivacy.add(key);
        if (_selectedPrivacy.contains('global') ||
            _selectedPrivacy.contains('public') ||
            _selectedPrivacy.contains('only-me')) {
          _selectedPrivacy.clear();
          _selectedPrivacy.add(key);
        }
        if (_selectedPrivacy.contains('public') &&
            _selectedPrivacy.contains('global')) {
          _selectedPrivacy.clear();
          _selectedPrivacy.add(key);
        }
        if (_selectedPrivacy.contains('only-me') &&
            (_selectedPrivacy.contains('global') ||
                _selectedPrivacy.contains('public'))) {
          _selectedPrivacy.clear();
          _selectedPrivacy.add(key);
        }
        if (_selectedPrivacy.contains('friends') &&
            _selectedPrivacy.contains('connections') &&
            _selectedPrivacy.contains('tier-1') &&
            _selectedPrivacy.contains('tier-2')) {
          _selectedPrivacy.clear();
          _selectedPrivacy.add('public');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MyPostViewModel _myPostViewModel = Provider.of<MyPostViewModel>(context);
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    User? authUser = _userViewModel.getUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Constants.titleImage2(context),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Constants.np_bg_clr,
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            widget.type == 'simple'
                                ? 'Create post'
                                : 'Create ${widget.type} post',
                            style: Constants().np_heading,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        if (widget.type != 'simple') ...[
                          (isSelectedFile == true)
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child:
                                            Text('1 ${widget.type} selected '),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          removeAttachment();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(2),
                                          color: Colors.black,
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Row(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 10, right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Colors.black,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: InkWell(
                                              onTap: pickRespectiveFile,
                                              child: Row(
                                                children: [
                                                  widget.type == 'image'
                                                      ? Icon(
                                                          Icons.image,
                                                          size: 20,
                                                          color: Colors.white,
                                                        )
                                                      : SizedBox(),
                                                  widget.type == 'video'
                                                      ? Icon(
                                                          Icons
                                                              .slow_motion_video_outlined,
                                                          size: 20,
                                                          color: Colors.white,
                                                        )
                                                      : SizedBox(),
                                                  widget.type == 'audio'
                                                      ? Icon(
                                                          Icons.audiotrack,
                                                          size: 20,
                                                          color: Colors.white,
                                                        )
                                                      : SizedBox(),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    if (widget.type == 'image') ...[
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 10, right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: Colors.black,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              if (widget.type == 'image') {
                                                getImage('camera');
                                              }
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          )),
                                    ]
                                  ],
                                )
                        ],
                      ],
                    ),
                  ),
                  Divider(),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: (authUser?.profile == null)
                              ? Utils.LoadingIndictorWidtet()
                              : Image.network(
                                  '${Constants.profileImage(authUser)}',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Constants.defaultImage(40.0);
                                  },
                                ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          '${authUser?.fname} ${authUser?.lname}',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(10),
                      height: 8 * 24.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: _detailsTxtController,
                        maxLines: 8,
                        decoration: InputDecoration(
                          hintText: 'Write something...',
                          fillColor: Colors.grey[100],
                          filled: true,
                          border: InputBorder.none,
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu_outlined,
                          size: 16,
                        ),
                        Text('Choose Privacy')
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          privacyBox('global', 'Global'),
                          privacyBox('public', 'Public'),
                          privacyBox('friends', 'Friends'),
                          privacyBox('connections', 'Connections'),
                          privacyBox('tier-1', 'Personal Tier'),
                          privacyBox('tier-2', 'Extended Tier'),
                          privacyBox('only-me', 'Only me')
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                        child: (_isUploading == 0)
                            ? Text('Share post')
                            : Utils.LoadingIndictorWidtet(),
                        onPressed: () async {
                          if (_selectedPrivacy.length == 0 &&
                              _isUploading == 0) {
                            Utils.toastMessage('Please select privacy');
                          } else {
                            uploadFile(context);
                          }
                        },
                      ),
                    )
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Dio dio = new Dio();

  uploadFile(context) async {
    if (_isUploading == 0) {
      setState(() {
        _isUploading = 1;
      });
      String uploadUrl = AppUrl.createPost;
      var formData;
      if (widget.type != 'simple') {
        if (widget.type == 'image') {
          if (imagePath != null) {
            String path = imagePath!.path;
            formData = FormData.fromMap(
              {
                'details': _detailsTxtController.text,
                'user': "${authId}",
                'privacy': "${_selectedPrivacy}",
                'attachment': await MultipartFile.fromFile(path,
                    filename: basename(path)),
                'file_type': '${widget.type}',
                "image_path": "${postImage!}",
              },
            );
          } else {
            Utils.toastMessage('Please select ${widget.type}');
          }
        } else if (widget.type == 'video') {
          if (postVideo != null) {
            String path = postVideo!.path;
            String vthumbnail = videThumbnail!.path;
            formData = FormData.fromMap(
              {
                'details': _detailsTxtController.text,
                'user': "${authId}",
                'privacy': "${_selectedPrivacy}",
                'attachment': await MultipartFile.fromFile(path,
                    filename: basename(path)),
                'thumbnail': await MultipartFile.fromFile(vthumbnail,
                    filename: basename(vthumbnail)),
                'file_type': '${widget.type}',
                "image_path": "${postVideo!}",
              },
            );
          } else {
            Utils.toastMessage('Please select ${widget.type}');
          }
        } else if (widget.type == 'audio') {
          if (postAudio != null) {
            String path = postAudio!.path;
            formData = FormData.fromMap(
              {
                'details': _detailsTxtController.text,
                'user': "${authId}",
                'privacy': "${_selectedPrivacy}",
                'attachment': await MultipartFile.fromFile(path,
                    filename: basename(path)),
                'file_type': '${widget.type}',
                "image_path": "${postAudio!}",
              },
            );
          } else {
            Utils.toastMessage('Please select ${widget.type}');
          }
        }
      } else {
        if (_detailsTxtController.text.isNotEmpty) {
          formData = FormData.fromMap(
            {
              'details': _detailsTxtController.text,
              'user': "${authId}",
              'privacy': "${_selectedPrivacy}",
            },
          );
        } else {
          Utils.toastMessage('Write something...');
        }
      }
      Response response = await dio.post(
        uploadUrl,
        data: formData,
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': "Bearer " + authToken
          },
          receiveTimeout: 200000,
          sendTimeout: 200000,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        Utils.toastMessage('Your post has been added');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NPLayout()));
      } else {
        print(response.data.toString());
        print(response.statusCode.toString());
      }
      setState(() {
        _isUploading = 0;
      });
    }
  }
}
