import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/User.dart';


class Comment {
  final int? id;
  final int? user_id;
  final int? post_id;
  final String? text;
  final NpDateTime? createdat;
  final User? user;

  Comment({
    this.id,
    this.user_id,
    this.post_id,
    this.text,
    this.createdat,
    this.user,
  });
  factory Comment.fromJson(Map<dynamic, dynamic> json) {
    return Comment(
        id:json['id'] as int?,
        user_id:json['user_id'] as int?,
        post_id:json['post_id'] as int?,
        text:json['text'] as String?,
        createdat:json['createdat'] as NpDateTime,
        user:json['user'] as User?,
    );
  }
}