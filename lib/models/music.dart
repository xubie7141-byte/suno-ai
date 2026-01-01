import 'package:json_annotation/json_annotation.dart';

part 'music.g.dart';

@JsonSerializable()
class Music {
  final String id;
  final String title;
  final String artist;
  final String? description;
  final String? lyrics;
  final String? coverImageUrl;
  final String? musicUrl;
  final String? videoUrl;
  final String genre;
  final String mood;
  final int duration; // 秒
  final int likes;
  final int downloads;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? userId;
  final bool isLocalGeneration; // 本地生成的歌曲

  Music({
    required this.id,
    required this.title,
    required this.artist,
    this.description,
    this.lyrics,
    this.coverImageUrl,
    this.musicUrl,
    this.videoUrl,
    required this.genre,
    required this.mood,
    required this.duration,
    this.likes = 0,
    this.downloads = 0,
    this.isFavorite = false,
    required this.createdAt,
    this.updatedAt,
    this.userId,
    this.isLocalGeneration = false,
  });

  factory Music.fromJson(Map<String, dynamic> json) => _$MusicFromJson(json);
  Map<String, dynamic> toJson() => _$MusicToJson(this);

  Music copyWith({
    String? id,
    String? title,
    String? artist,
    String? description,
    String? lyrics,
    String? coverImageUrl,
    String? musicUrl,
    String? videoUrl,
    String? genre,
    String? mood,
    int? duration,
    int? likes,
    int? downloads,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    bool? isLocalGeneration,
  }) {
    return Music(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      description: description ?? this.description,
      lyrics: lyrics ?? this.lyrics,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      musicUrl: musicUrl ?? this.musicUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      genre: genre ?? this.genre,
      mood: mood ?? this.mood,
      duration: duration ?? this.duration,
      likes: likes ?? this.likes,
      downloads: downloads ?? this.downloads,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      isLocalGeneration: isLocalGeneration ?? this.isLocalGeneration,
    );
  }
}
