import 'package:connect_social/model/NpDateTime.dart';

class UserDetail {
  int? id;
  int? user_id;
  String? about;
  String? city;
  String? state;
  String? country;
  String? relationship;
  String? highSchool;
  String? workplace;
  String? hobbies;
  String? high_school;
  String? cover_photo;
  String? date_of_birth;
  String? npi;
  String? kyc_status;
  String? kyc_reject_reason;
  NpDateTime? createdat;
  String? rank;

  UserDetail(
      {this.id,
      this.user_id,
      this.about,
      this.city,
      this.state,
      this.country,
      this.relationship,
      this.highSchool,
      this.workplace,
      this.hobbies,
      this.high_school,
      this.cover_photo,
      this.date_of_birth,
      this.npi,
      this.kyc_status,
      this.kyc_reject_reason,
      this.rank,
      this.createdat});

  factory UserDetail.fromJson(Map<dynamic, dynamic> data) {
    return UserDetail(
      id: data['id'] as int?,
      user_id: data['user_id'] as int?,
      about: data['about'] as String?,
      city: data['city'] as String?,
      state: data['state'] as String?,
      country: data['country'] as String?,
      relationship: data['relationship'] as String?,
      high_school: data['high_school'] as String?,
      workplace: data['workplace'] as String?,
      hobbies: data['hobbies'] as String?,
      cover_photo: data['cover_photo'] as String?,
      date_of_birth: data['date_of_birth'] as String?,
      npi: data['npi'] as String?,
      kyc_status: data['kyc_status'] as String?,
      kyc_reject_reason: data['kyc_reject_reason'] as String?,
      createdat: data['createdat'] as NpDateTime,
      rank: data['rank'] as String?,
    );
  }
}
