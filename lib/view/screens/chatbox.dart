import 'dart:io';
import 'package:connect_social/res/app_url.dart';
import 'package:connect_social/view/screens/webview/image.dart';
import 'package:connect_social/view_model/auth_view_model.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:connect_social/model/Chat.dart';
import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/apis/api_response.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:path/path.dart';
import 'package:connect_social/utils/Utils.dart';
import 'package:connect_social/view/screens/other_profile.dart';
import 'package:connect_social/view_model/chat_view_model.dart';
import 'package:connect_social/view_model/user_view_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class ChatBoxScreen extends StatefulWidget {
  final User? user;
  const ChatBoxScreen(this.user, {Key? key}) : super(key: key);

  @override
  State<ChatBoxScreen> createState() => _ChatBoxScreenState();
}

class _ChatBoxScreenState extends State<ChatBoxScreen> {
  var authToken;
  var authId;
  Future? isAuth;
  User? authUser;
  final _messageTxtController = TextEditingController();
  final ScrollController _sc = ScrollController();
  File? fileToUpload;
  String? fileName;
  bool isProcessing = false;
  bool isFetchingMessages = false;
  final _messageTxtFocusNode = FocusNode();

  Future<void> _pullMessages(ctx) async {
    setState(() {
      isFetchingMessages = true;
    });

    print('pulling messages');
    Map messagesParams = {'id': '${authId}', 'user': '${widget.user?.id}'};
    Provider.of<ChatViewModel>(this.context, listen: false)
        .fetchAllMessages(messagesParams, '${authToken}');
    setState(() {
      isFetchingMessages = false;
    });
  }

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowCompression: true,
        type: FileType.image,
      );

      if (result != null) {
        fileToUpload = File(result.files.single.path!);
        setState(() {
          fileName = result.files.first.name;
        });
        double temp =
            File(result.files.single.path!).lengthSync() / (1024 * 1024);
        if (temp >= 20) {
          Utils.toastMessage('File should be less than 20MB.');
          fileToUpload = null;
        }
      } else {
        fileToUpload = null;
      }
    } catch (e) {
      print(e);
    }
  }

  void removeFile() {
    setState(() {
      fileName = null;
      fileToUpload = null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authToken = await AppSharedPref.getAuthToken();
      authId = await AppSharedPref.getAuthId();

      isAuth = Provider.of<AuthViewModel>(this.context, listen: false)
          .isAuth(widget.user?.id);

      Map data = {'id': '${authId}'};
      Provider.of<ChatViewModel>(this.context, listen: false)
          .setAllMessages([]);
      Provider.of<UserViewModel>(this.context, listen: false)
          .getUserDetails(data, '${authToken}');

      Map msgMarkAsReadParams = {
        'to': '${authId}',
        'from': '${widget.user?.id}'
      };
      Provider.of<UserViewModel>(this.context, listen: false)
          .messagesMarkAsRead(msgMarkAsReadParams, '${authToken}');
      _pullMessages(context);
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => {_sc.jumpTo(_sc.position.maxScrollExtent)});
    });
  }

  @override
  Widget build(BuildContext context) {
    ChatViewModel _chatViewModel = Provider.of<ChatViewModel>(context);
    List<Chat?> messages = _chatViewModel.getAllMessages;
    authUser = Provider.of<UserViewModel>(context).getUser;

    storeMessage() async {
      if (fileToUpload != null) {
        setState(() {
          isProcessing = true;
        });
        var formData;
        Dio dio = new Dio();
        String path = fileToUpload!.path;
        formData = FormData.fromMap(
          {
            'user': '${widget.user!.id}',
            'id': '${authUser!.id}',
            'message': '${_messageTxtController.text}',
            'file':
                await MultipartFile.fromFile(path, filename: basename(path)),
          },
        );
        String uploadUrl = AppUrl.storeMessages;
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
          setState(() {
            _messageTxtController.clear();
            isProcessing = false;
            fileName != '';
            fileToUpload = null;
            _pullMessages(context);
          });
        } else {
          Utils.toastMessage("Error in sending message. Please try again");
        }
      } else {
        if (_messageTxtController.text.isEmpty) {
          Utils.toastMessage('Please enter a message to send.!');
        } else {
          setState(() {
            isProcessing = true;
          });
          Map data = {
            'user': '${widget.user!.id}',
            'id': '${authUser!.id}',
            'message': '${_messageTxtController.text}',
          };

          dynamic sentMessage = await Provider.of<ChatViewModel>(context, listen: false).storeMessage(data, '${authToken}');
          setState(() {
            _messageTxtController.clear();
            isProcessing = false;
            sentMessage['createdat'] =
                NpDateTime.fromJson(sentMessage['createdat']);
            messages.add(Chat(
              id: sentMessage['id'] as int?,
              from: int.tryParse(sentMessage['from']) as int?,
              to: int.tryParse(sentMessage['to']) as int?,
              message: sentMessage['message'] as String?,
              createdat: sentMessage['createdat'] as NpDateTime?,
            ));

            //_pullMessages(context);
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtherProfileScreen(widget.user?.id)));
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  '${Constants.profileImage(widget.user)}',
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
                child: Text(
                  '${widget.user?.fname} ${widget.user?.lname}',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        color: Constants.np_bg_clr,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                flex: 16,
                child: Container(
                  child: Card(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          _pullMessages(context);
                        },
                        child: (isFetchingMessages == true) ? Utils.LoadingIndictorWidtet() :
                        ListView(
                          children: [
                            if (_chatViewModel.getAllMessagesStatus.status == Status.IDLE) ...[
                              if (messages.length != 0) ...[
                                for (var message in messages)
                                  MessageRow(message),
                              ]
                            ] else if (_chatViewModel.getAllMessagesStatus.status == Status.BUSY) ...[
                              Center(
                                child: Container(
                                  height: 500,
                                  child: Utils.LoadingIndictorWidtet(size: 30.0),
                                ),
                              )
                            ],
                          ],
                        ),
                      )
                  ),
                ),
              ),
              Container(
                child: Card(
                    child: Column(
                      children: [
                        if (fileToUpload != null) ...[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                    BorderSide(color: Colors.grey.shade300)),
                                color: Colors.grey.shade200),
                            padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${fileName}'),
                                InkWell(
                                  onTap: removeFile,
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                  controller: _messageTxtController,
                                  focusNode: _messageTxtFocusNode,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: InputBorder.none,
                                    hintText: 'Type your message here.',
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                //_pullMessages(context);
                                _pickFile();
                              },
                              child: Container(
                                child: Tooltip(
                                  message:
                                  '${fileName != null ? fileName : 'No file selected'}',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.attach_file_sharp,
                                        color: (fileToUpload == null)
                                            ? Colors.black
                                            : Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            isProcessing == true
                                ? Row(
                              children: [
                                Utils.LoadingIndictorWidtet(),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            )
                                : IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.send_rounded),
                              color: (!isProcessing)
                                  ? Colors.black
                                  : Colors.grey.shade100,
                              tooltip: 'Send',
                              onPressed: storeMessage,
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget MessageRow(Chat? chat) {
    User? user;
    var type;
    final messageBg;

    if (chat!.from == widget.user!.id) {
      type = 'left';
      messageBg = Colors.grey[200];
      user = widget.user!;
    } else {
      type = 'right';
      messageBg = Colors.blueGrey[100];
      user = authUser;
    }

    dynamic messageContainer;
    dynamic imageCard = ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image.network(
        '${Constants.profileImage(user)}',
        width: 30,
        height: 30,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Constants.defaultImage(40.0);
        },
      ),
    );

    dynamic messageCard = Container(
      width: MediaQuery.of(this.context).size.width - 100,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: messageBg,
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (chat.message == null) ? Container() : Text('${chat.message}'),
              if (chat.file != null) ...[
                Divider(),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      child: InkWell(
                          onTap: () {
                            Navigator.of(this.context).push(MaterialPageRoute(
                              builder: (context) => ImageScreen(
                                  imageUrl:
                                      '${AppUrl.url}/storage/chat/${type == 'left' ? chat.from : authId}/${chat.file}'),
                            ));
                          },
                          child: Tooltip(
                              message: chat.file,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 15,
                                  ),
                                  Text('${chat.file}'),
                                ],
                              ))),
                    ))
              ],
            ],
          ),
        ),
      ),
    );
    if (type == 'left') {
      messageContainer = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              imageCard,
              messageCard,
            ],
          ),
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Text(
                '${chat.createdat?.h}: ${chat.createdat?.i} ${chat.createdat?.A} ${chat.createdat?.d} ${chat.createdat?.M},${chat.createdat?.y}',
                style: TextStyle(fontSize: 10, color: Colors.grey)),
          )
        ],
      );
    }
    if (type == 'right') {
      messageContainer = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [messageCard, imageCard],
          ),
          Container(
            margin: EdgeInsets.only(left: 24),
            child: Text(
                '${chat.createdat?.h}: ${chat.createdat?.i} ${chat.createdat?.A} ${chat.createdat?.m}-${chat.createdat?.d}-${chat.createdat?.Y}',
                style: TextStyle(fontSize: 10, color: Colors.grey)),
          )
        ],
      );
    }
    return Padding(padding: EdgeInsets.all(10), child: messageContainer);
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        break;
      case 1:
        break;
    }
  }
}
