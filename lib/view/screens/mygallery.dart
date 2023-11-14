import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_social/model/apis/api_response.dart';
import 'package:connect_social/res/app_url.dart';
import 'package:connect_social/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:connect_social/model/Gallery.dart';
import 'package:connect_social/res/constant.dart';
import 'package:connect_social/view/screens/single_post.dart';
import 'package:connect_social/shared_preference/app_shared_preference.dart';
import 'package:connect_social/view_model/gallery_view_model.dart';
import 'package:provider/provider.dart';

class MyGalleryScreen extends StatefulWidget {
  final int? user_id;
  const MyGalleryScreen(this.user_id);

  @override
  State<MyGalleryScreen> createState() => _MyGalleryScreenState();
}

class _MyGalleryScreenState extends State<MyGalleryScreen> {


  var authId;
  String? authToken;
  String? key='image';


  List filter=[
    {'icon':Icons.menu,'title':'All','value':'all'},
    {'icon':Icons.photo,'title':'Images','value':'image'},
    {'icon':Icons.video_collection,'title':'Video','value':'video'},
    {'icon':Icons.audio_file,'title':'Audio','value':'audio'},
  ];

  Future<void> _pullRefresh(ctx,key) async {
    Map data={'id': '${widget.user_id}','key':key};
    Provider.of<GalleryViewModel>(context,listen: false).setGallery([]);
    Provider.of<GalleryViewModel>(context,listen: false).fetchMyGallery(data,'${authToken}');
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      authToken=await AppSharedPref.getAuthToken();
      authId=await AppSharedPref.getAuthId();
      _pullRefresh(context,key);
    });
  }


  @override
  Widget build(BuildContext context) {


    GalleryViewModel _galleryViewModel=Provider.of<GalleryViewModel>(context);

    List<Gallery?> galleryImages=_galleryViewModel.getGalleryImages;


    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Constants.titleImage2(context),

        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 4,horizontal: 2),
                child: Row(
                  children: [
                    Icon(Icons.image),
                    Text('Gallery',style:Constants().np_heading,),
                  ],
                ),
              ),
              Divider(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2,left: 10,right: 10),
                  child: Row(
                      children: [
                        for (var item in filter)...[
                          InkWell(
                            onTap: (){
                              setState(() {
                                key=item['value'];
                              });
                              _pullRefresh(context, item['value']);
                            },
                            child: Container(
                                decoration: new BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: key==item['value']?Colors.black:Colors.transparent
                                        )
                                    )
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 7,vertical: 7),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child:Row(
                                  children: [Icon(item['icon']), Text(item['title'])],
                                )
                            ),
                          ),
                        ]
                      ]
                  ),
                ),
              ),

              Divider(),

              if (_galleryViewModel.getGalleryStatus.status == Status.IDLE) ...[
                if (galleryImages.length == 0) ...[
                  Card(
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(Constants.np_padding),
                      child: Text('No media'),
                    ),
                  )
                ] else ...[
                  new Expanded(
                    child: GridView.count(
                        crossAxisCount: 3,
                        //padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        children: List<Widget>.generate(galleryImages.length, (index){
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SinglePostScreen(galleryImages[index]?.post_id)));
                            },
                            child:
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: (galleryImages[index]?.type=='image')
                                  ? FadeInImage.assetNetwork(
                                placeholder: 'assets/images/image-placeholder.png',
                                image: Constants.postImage(galleryImages[index]),
                                fit: BoxFit.cover,
                              )
                                  :(galleryImages[index]?.type=='audio')?
                              Column(
                                children: [
                                  Expanded(child: Image.asset('assets/images/${galleryImages[index]?.type}-placeholder.png',fit: BoxFit.cover),),
                                  Padding(
                                      padding: EdgeInsets.only(top: 3),
                                      child: Text('${galleryImages[index]?.file}',style: TextStyle(fontSize: 11),overflow: TextOverflow.ellipsis,)
                                  )
                                ],
                              )    :(galleryImages[index]?.type=='video')?
                              FadeInImage(
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: AssetImage('assets/images/${galleryImages[index]?.type}-placeholder.png'),
                                image: CachedNetworkImageProvider('${AppUrl.url}storage/a/posts/thumbnail-${galleryImages[index]?.file?.split(".")[0]}.png'),
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/images/video-placeholder.png', fit: BoxFit.fitWidth);
                                },
                              )
                                  : Image.asset('assets/images/${galleryImages[index]?.type}-placeholder.png',fit: BoxFit.cover),
                            )
                          );
                        })
                    ),
                  )
                ]
              ] else if (_galleryViewModel.getGalleryStatus.status == Status.BUSY) ...[
                Utils.LoadingIndictorWidtet(),
              ],
            ],

          ),
        )
    );
  }
}

