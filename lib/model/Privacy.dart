class Privacy {
  List<String>? about;
  List<String>? city;
  List<String>? state;
  List<String>? relationship_status;
  List<String>? joining;
  List<String>? workplace;
  List<String>? high_school;
  List<String>? hobbies;
  List<String>? email;
  List<String>? phone;
  List<String>? gender;
  List<String>? friends;
  List<String>? connections;


  Privacy({
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
    this.friends,
    this.connections,
  });

  factory Privacy.fromJson(Map<String, dynamic> json) {
    return Privacy(
      about :json['about'].cast<String>(),
      city: json['city'].cast<String>(),
      state : json['state'].cast<String>(),
      relationship_status : json['relationship_status'].cast<String>(),
      joining : json['joining'].cast<String>(),
      workplace : json['workplace'].cast<String>(),
      high_school : json['high_school'].cast<String>(),
      hobbies : json['hobbies'].cast<String>(),
      email : json['email'].cast<String>(),
      phone : json['phone'].cast<String>(),
      gender : json['gender'].cast<String>(),
      friends : json['friends'].cast<String>(),
      connections : json['connections'].cast<String>(),
    );
  }
}
