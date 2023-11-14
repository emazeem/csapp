abstract class BaseApiServices{
  Future<dynamic> getPostApiResponse(String url,dynamic data);
  Future<dynamic> getPostAuthApiResponse(String url,dynamic data,String token);
}