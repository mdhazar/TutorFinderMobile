import 'package:json_annotation/json_annotation.dart';
part 'tutor.g.dart';

@JsonSerializable()
class Tutor {
  final Map<String, dynamic> user; // {username, ...}
  final String? bio;
  final String? rating;
  final List<dynamic> subjects;

  Tutor({required this.user, this.bio, this.rating, required this.subjects});

  factory Tutor.fromJson(Map<String, dynamic> json) => _$TutorFromJson(json);
  Map<String, dynamic> toJson() => _$TutorToJson(this);
}
