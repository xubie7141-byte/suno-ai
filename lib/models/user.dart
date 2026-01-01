import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final int createdMusicCount;
  final int favoritesCount;
  final int followersCount;
  final bool isFollowing;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.createdMusicCount = 0,
    this.favoritesCount = 0,
    this.followersCount = 0,
    this.isFollowing = false,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
