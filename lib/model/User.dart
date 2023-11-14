import 'package:connect_social/model/NpDateTime.dart';

class User {
  final int? id;
  final String? fname;
  final String? lname;
  final String? username;
  final String? email;
  final String? country_code;
  final String? phone;
  final String? email_verified_at;
  final String? gender;
  final int? role;
  final bool? is_blocked;
  final String? email_code;
  final String? profile;
  final int? unread_msg;
  final int? anyUnreadMessage;
  final int? anyUnreadNotification;
  final NpDateTime? createdat;
  final bool? is_network;

  User(
      {this.id,
      this.fname,
      this.lname,
      this.username,
      this.email,
      this.country_code,
      this.phone,
      this.email_verified_at,
      this.gender,
      this.role,
      this.email_code,
      this.is_blocked,
      this.profile,
      this.is_network,
      this.unread_msg,
      this.anyUnreadMessage,
      this.anyUnreadNotification,
      this.createdat});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] as int?,
        fname: json['fname'] as String?,
        lname: json['lname'] as String?,
        username: json['username'] as String?,
        email: json['email'] as String?,
        country_code: json['country_code'] as String?,
        phone: json['phone'] as String?,
        email_verified_at: json['email_verified_at'] as String?,
        gender: json['gender'] as String?,
        role: json['role'] as int?,
        unread_msg: json['unread_msg'] as int?,
        is_blocked: json['is_blocked'] as bool?,
        anyUnreadMessage: json['unread_messages'] as int?,
        anyUnreadNotification: json['unread_notification'] as int?,
        email_code: json['email_code'] as String?,
        profile: json['profile'] ?? '' as String?,
        is_network: json['is_network'] as bool?,
        createdat: json['createdat'] as NpDateTime?);
  }
}
