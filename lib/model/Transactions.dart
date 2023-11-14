import 'package:connect_social/model/NpDateTime.dart';
import 'package:connect_social/model/User.dart';

class Transactions {
  String? type;
  String? narration;
  String? dr;
  String? cr;
  User? user;
  String? trx;
  NpDateTime? createdat;


  Transactions({
    this.type,
    this.narration,
    this.dr,
    this.cr,
    this.user,
    this.trx,
    this.createdat,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
        type :json['type'] as String,
        narration: json['narration'] as String,
        dr : json['dr'] as String?,
        cr : json['cr'] as String?,
        user : json['user'] as User?,
        trx : json['trx'] as String?,
        createdat : json['createdat'] as NpDateTime,
    );
  }
}
