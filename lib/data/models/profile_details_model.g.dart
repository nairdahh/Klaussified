// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileDetailsModelImpl _$$ProfileDetailsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileDetailsModelImpl(
      realName: json['realName'] as String? ?? '',
      hobbies: json['hobbies'] as String? ?? '',
      wishes: json['wishes'] as String? ?? '',
      updatedAt: _timestampFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$ProfileDetailsModelImplToJson(
        _$ProfileDetailsModelImpl instance) =>
    <String, dynamic>{
      'realName': instance.realName,
      'hobbies': instance.hobbies,
      'wishes': instance.wishes,
      'updatedAt': _timestampToJson(instance.updatedAt),
    };
