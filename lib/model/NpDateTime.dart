import 'package:connect_social/model/User.dart';

class NpDateTime {
  final String? H;
  final String? h;
  final String? i;
  final String? s;
  final String? m;
  final String? M;
  final String? d;
  final String? F;
  final String? Y;
  final String? y;
  final String? a;
  final String? A;

  NpDateTime({
    this.H,
    this.h,
    this.i,
    this.s,
    this.m,
    this.M,
    this.d,
    this.F,
    this.Y,
    this.y,
    this.a,
    this.A,
  });

  factory NpDateTime.fromJson(Map<String, dynamic> json) {
    return NpDateTime(
      H: json['H'] as String?,
      h: json['h'] as String?,
      i: json['i'] as String?,
      s: json['s'] as String?,
      m: json['m'] as String?,
      M: json['M'] as String?,
      d: json['d'] as String?,
      F: json['F'] as String?,
      Y: json['Y'] as String?,
      y: json['y'] as String?,
      a: json['a'] as String?,
      A: json['A'] as String?,
    );
  }
}
