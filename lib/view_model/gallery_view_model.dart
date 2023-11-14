import 'package:flutter/material.dart';
import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/Post.dart';
import 'package:connect_social/model/User.dart';
import 'package:connect_social/model/apis/api_response.dart';
import 'package:connect_social/model/directories/gallery_repo.dart';
import 'package:connect_social/model/directories/post_repo.dart';
import 'package:connect_social/model/Gallery.dart';

class GalleryViewModel extends ChangeNotifier {

  
  Gallery? galleryResponse=Gallery();
  GalleryRepo _galleryRepo=GalleryRepo();

  GalleryViewModel({this.galleryResponse});


  List<Gallery?> _myGalleryImages=[];
  List<Gallery?> get getGalleryImages => _myGalleryImages;

  void setGallery(List<Gallery> _myImages) {
    _myGalleryImages = _myImages;
    notifyListeners();
  }


  ApiResponse _fetchGalleryStatus=ApiResponse();
  ApiResponse get getGalleryStatus => _fetchGalleryStatus;

  Future fetchMyGallery(dynamic data,String token) async {
    _fetchGalleryStatus = ApiResponse.loading('Fetching gallery images');
    try{
      final response =  await _galleryRepo.getGalleryImages(data,token);
      List<Gallery?> myGalleryImages=[];
      response['data'].forEach((item) {
        item['createdat']=NpDateTime.fromJson(item['createdat']);
        myGalleryImages.add(Gallery.fromJson(item));
      });
      _myGalleryImages=myGalleryImages;
      _fetchGalleryStatus = ApiResponse.completed(_myGalleryImages);
      notifyListeners();
    }catch(e){
      _fetchGalleryStatus= ApiResponse.error('Please try again.!');
    }

  }



}