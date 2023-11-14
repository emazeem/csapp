
import 'package:connect_social/model/User.dart';

class Like {
  final int? id;
  final int? user_id;
  final int? post_id;
  final User? user;
  final String? type;

  Like({
    this.id,
    this.user_id,
    this.post_id,
    this.type,
    this.user,
  });
  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id:json['id'] as int?,
      user_id:json['user_id'] as int?,
      post_id:json['post_id'] as int?,
      type:json['type'] as String?,
      user:json['user'] as User?,
    );
  }
}