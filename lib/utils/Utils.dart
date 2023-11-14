import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/view/screens/single_post.dart';

class Utils{
  static toastMessage(String message){
    FocusManager.instance.primaryFocus?.unfocus();
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        fontSize: 16.0,
        gravity:ToastGravity.BOTTOM,
    );

  }
  static LoadingIndictorWidtet({size=20.0}){
    return Center(
      child: Container(
        width: size,
        height: size,

        child: CircularProgressIndicator(
          semanticsLabel: 'Circular progress indicator',
          color: Constants.np_yellow,
        ),
      ),
    );
  }
  static flushBarMessage(){

  }
  static imageError(context,size){

  }
  static snackBarMessage(){

  }
  static Widget socialInformation(String column, String value) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${column}', style: TextStyle(fontWeight: FontWeight.bold),),
                Text('${value}')
              ],
            ),
            Divider(),
          ],
        ));
  }
  static Widget galleryImageWidget(context, galleryImage){

    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SinglePostScreen(galleryImage.post_id)));
      },
      child: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width / 3.7,
          height: 130,
          color: Colors.grey,
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/image-placeholder.png',
            image: Constants.postImage(galleryImage),
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          )
          /*child: CachedNetworkImage(
            imageUrl:
            "${Constants.postImage(galleryImage)}",
            fit: BoxFit.cover,
            width: 150,
            height: 150,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Utils.LoadingIndictorWidtet(),
            errorWidget: (context, url, error) => Utils.LoadingIndictorWidtet(),
          )*/

      ),
    );
  }
  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (e) {
      print(e);
      Utils.toastMessage('No internet connection!');
      return false;
    }
  }

}
