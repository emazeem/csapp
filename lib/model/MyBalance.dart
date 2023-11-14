import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/User.dart';

class MyBalance {
  String? balance;
  String? worth;


  MyBalance({
    this.balance,
    this.worth,
  });

  factory MyBalance.fromJson(Map<String, dynamic> json) {
    return MyBalance(
        balance :json['balance'] as String,
        worth: json['worth'] as String
    );
  }
}
