import 'package:connect_social/model/NpDateTime.dart';

class Gallery {
  int? id;
  int? post_id;
  String? type;
  String? file;
  NpDateTime? createdat;

  Gallery({this.id, this.post_id, this.type, this.file, this.createdat});

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      id: json['id'] as int,
      post_id: json['post_id'] as int,
      type: json['type'] as String,
      file: json['file'] as String,
      createdat: json['createdat'] as NpDateTime,
    );
  }
}
