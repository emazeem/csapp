
class Friend {
  final int? id;
  final int? from;
  final int? to;
  final String? status;

  Friend({
    this.id,
    this.from,
    this.to,
    this.status,
  });
  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id:json['id'] as int?,
      from:json['from'] as int?,
      to:json['to'] as int?,
      status:json['status'] as String?,
    );
  }
}

class FriendRequest {
  final int? id;
  final int? from;
  final int? to;
  final String? status;

  FriendRequest({
    this.id,
    this.from,
    this.to,
    this.status,
  });
  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id:json['id'] as int?,
      from:json['from'] as int?,
      to:json['to'] as int?,
      status:json['status'] as String?,
    );
  }
}