// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tutor _$TutorFromJson(Map<String, dynamic> json) => Tutor(
  user: json['user'] as Map<String, dynamic>,
  bio: json['bio'] as String?,
  rating: json['rating'] as String?,
  subjects: json['subjects'] as List<dynamic>,
);

Map<String, dynamic> _$TutorToJson(Tutor instance) => <String, dynamic>{
  'user': instance.user,
  'bio': instance.bio,
  'rating': instance.rating,
  'subjects': instance.subjects,
};
