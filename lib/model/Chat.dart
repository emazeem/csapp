
import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/User.dart';

class Chat {
  final int? id;
  final int? from;
  final int? to;
  final String? message;
  final String? file;
  final NpDateTime? createdat;

  Chat({
    this.id,
    this.from,
    this.to,
    this.message,
    this.file,
    this.createdat
  });

  factory Chat.fromJson(Map<dynamic, dynamic> json) {
    return Chat(
        id:json['id'] as int?,
        from:json['from'] as int?,
        to:json['to'] as int?,
        message:json['message'] as String?,
        file: json['file'] as String?,
        createdat:json['createdat'] as NpDateTime?,
    );
  }
}