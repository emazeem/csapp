import 'package:connect_social/res/constant.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowImage extends StatefulWidget {
  final String? url;

  const ShowImage(this.url);

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  bool appBarFlag = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarFlag ? Colors.white : Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
        title: appBarFlag
            ? Constants.titleImage(
                context,
              )
            : null,
        automaticallyImplyLeading: appBarFlag,
      ),
      body: InkWell(
        onTap: () {
          setState(() {
            appBarFlag = !appBarFlag;
          });
        },
        child: Container(
            color: Colors.black,
            height: double.infinity,
            child: PhotoView(
              imageProvider: NetworkImage('${widget.url}'),
            )),
      ),
    );
  }
}
