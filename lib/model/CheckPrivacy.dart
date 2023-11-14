class CheckPrivacy {
  bool? about;
  bool? city;
  bool? state;
  bool? relationship_status;
  bool? joining;
  bool? workplace;
  bool? high_school;
  bool? hobbies;
  bool? email;
  bool? phone;
  bool? gender;
  bool? friend;
  bool? connection;


  CheckPrivacy({
    this.about,
    this.city,
    this.state,
    this.relationship_status,
    this.joining,
    this.workplace,
    this.high_school,
    this.hobbies,
    this.email,
    this.phone,
    this.gender,
    this.friend,
    this.connection,
  });

  factory CheckPrivacy.fromJson(Map<String, dynamic> json) {
    return CheckPrivacy(
      about :json['about'] as bool?,
      city: json['city'] as bool?,
      state : json['state'] as bool?,
      relationship_status : json['relationship_status'] as bool?,
      joining : json['joining'] as bool?,
      workplace : json['workplace'] as bool?,
      high_school : json['high_school'] as bool?,
      hobbies : json['hobbies'] as bool?,
      email : json['email'] as bool?,
      phone : json['phone'] as bool?,
      gender : json['gender'] as bool?,
      friend : json['friends'] as bool?,
      connection : json['connections'] as bool?,
    );
  }
}
