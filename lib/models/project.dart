import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Project portofolio yang disinkronkan dengan API Django REST Framework.
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    required this.title,
    required this.description,
    required this.techStack,
    required this.projectUrl,
    this.projectImageUrl = '',
    this.id,
  });

  /// Membuat objek dari JSON hasil API.
  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  /// id (UUID) dibuat oleh server, jadi tidak ikut dikirim saat POST
  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String description;
  final String techStack;
  final String projectUrl;

  /// Opsional: tetap berhasil dibaca walau nilainya tidak ada atau null
  @JsonKey(defaultValue: '')
  final String projectImageUrl;

  /// Mengubah objek menjadi JSON untuk dikirim ke API.
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
