// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InviteModelImpl _$$InviteModelImplFromJson(Map<String, dynamic> json) =>
    _$InviteModelImpl(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      groupName: json['groupName'] as String,
      invitedBy: json['invitedBy'] as String,
      invitedByName: json['invitedByName'] as String,
      inviteeEmail: json['inviteeEmail'] as String?,
      inviteeUsername: json['inviteeUsername'] as String?,
      inviteeUserId: json['inviteeUserId'] as String?,
      status: json['status'] as String? ?? AppConstants.inviteStatusPending,
      createdAt: _timestampFromJson(json['createdAt']),
      respondedAt: _timestampFromJson(json['respondedAt']),
      expiresAt: _timestampFromJson(json['expiresAt']),
    );

Map<String, dynamic> _$$InviteModelImplToJson(_$InviteModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'groupName': instance.groupName,
      'invitedBy': instance.invitedBy,
      'invitedByName': instance.invitedByName,
      'inviteeEmail': instance.inviteeEmail,
      'inviteeUsername': instance.inviteeUsername,
      'inviteeUserId': instance.inviteeUserId,
      'status': instance.status,
      'createdAt': _timestampToJson(instance.createdAt),
      'respondedAt': _timestampToJson(instance.respondedAt),
      'expiresAt': _timestampToJson(instance.expiresAt),
    };
