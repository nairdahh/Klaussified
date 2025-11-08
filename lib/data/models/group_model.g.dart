// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupModelImpl _$$GroupModelImplFromJson(Map<String, dynamic> json) =>
    _$GroupModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      createdAt: _timestampFromJson(json['createdAt']),
      status: json['status'] as String? ?? AppConstants.statusPending,
      startedAt: _timestampFromJson(json['startedAt']),
      informationalDeadline: _timestampFromJson(json['informationalDeadline']),
      revealDate: _timestampFromJson(json['revealDate']),
      revealedAt: _timestampFromJson(json['revealedAt']),
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      pickedCount: (json['pickedCount'] as num?)?.toInt() ?? 0,
      memberIds: (json['memberIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GroupModelImplToJson(_$GroupModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ownerId': instance.ownerId,
      'ownerName': instance.ownerName,
      'createdAt': _timestampToJson(instance.createdAt),
      'status': instance.status,
      'startedAt': _timestampToJson(instance.startedAt),
      'informationalDeadline': _timestampToJson(instance.informationalDeadline),
      'revealDate': _timestampToJson(instance.revealDate),
      'revealedAt': _timestampToJson(instance.revealedAt),
      'memberCount': instance.memberCount,
      'pickedCount': instance.pickedCount,
      'memberIds': instance.memberIds,
    };
