import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/User.dart';

class Notifications {
  String? id;
  String? msg;
  String? read_at;
  String? url;
  int? data_id;
  NpDateTime? createdat;
  User? from;

  Notifications({this.id, this.msg,this.url, this.data_id,this.read_at, this.createdat, this.from});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
        id :json['id'] as String,
        msg: json['msg'] as String,
        url : json['url'] as String?,
        data_id : json['data_id'] as int?,
        read_at : json['read_at'] as String?,
        createdat : json['createdat'] as NpDateTime,
        from : json['from'] != null ? User.fromJson(json['from']) : null,
    );
  }
}
