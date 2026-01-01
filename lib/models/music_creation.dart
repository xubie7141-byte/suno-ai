import 'package:json_annotation/json_annotation.dart';

part 'music_creation.g.dart';

@JsonSerializable()
class MusicCreation {
  final String id;
  final String title;
  final String? lyrics;
  final String genre;
  final String mood;
  final String? instrumentChoice;
  final String? singerStyle;
  final int? tempo;
  final String status; // 'draft', 'generating', 'completed', 'failed'
  final String? errorMessage;
  final String? generatedMusicUrl;
  final String? generatedVideoUrl;
  final String? coverImageUrl;
  final DateTime createdAt;
  final DateTime? completedAt;
  final Map<String, dynamic>? parameters;

  MusicCreation({
    required this.id,
    required this.title,
    this.lyrics,
    required this.genre,
    required this.mood,
    this.instrumentChoice,
    this.singerStyle,
    this.tempo,
    this.status = 'draft',
    this.errorMessage,
    this.generatedMusicUrl,
    this.generatedVideoUrl,
    this.coverImageUrl,
    required this.createdAt,
    this.completedAt,
    this.parameters,
  });

  factory MusicCreation.fromJson(Map<String, dynamic> json) =>
      _$MusicCreationFromJson(json);
  Map<String, dynamic> toJson() => _$MusicCreationToJson(this);

  MusicCreation copyWith({
    String? id,
    String? title,
    String? lyrics,
    String? genre,
    String? mood,
    String? instrumentChoice,
    String? singerStyle,
    int? tempo,
    String? status,
    String? errorMessage,
    String? generatedMusicUrl,
    String? generatedVideoUrl,
    String? coverImageUrl,
    DateTime? createdAt,
    DateTime? completedAt,
    Map<String, dynamic>? parameters,
  }) {
    return MusicCreation(
      id: id ?? this.id,
      title: title ?? this.title,
      lyrics: lyrics ?? this.lyrics,
      genre: genre ?? this.genre,
      mood: mood ?? this.mood,
      instrumentChoice: instrumentChoice ?? this.instrumentChoice,
      singerStyle: singerStyle ?? this.singerStyle,
      tempo: tempo ?? this.tempo,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      generatedMusicUrl: generatedMusicUrl ?? this.generatedMusicUrl,
      generatedVideoUrl: generatedVideoUrl ?? this.generatedVideoUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      parameters: parameters ?? this.parameters,
    );
  }
}
