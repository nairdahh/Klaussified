// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupMemberModelImpl _$$GroupMemberModelImplFromJson(
        Map<String, dynamic> json) =>
    _$GroupMemberModelImpl(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      username: json['username'] as String,
      photoURL: json['photoURL'] as String? ?? '',
      joinedAt: _timestampFromJson(json['joinedAt']),
      hasPicked: json['hasPicked'] as bool? ?? false,
      pickedAt: _timestampFromJson(json['pickedAt']),
      assignedToUserId: json['assignedToUserId'] as String?,
      profileDetails: json['profileDetails'] == null
          ? const ProfileDetailsModel()
          : ProfileDetailsModel.fromJson(
              json['profileDetails'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GroupMemberModelImplToJson(
        _$GroupMemberModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'username': instance.username,
      'photoURL': instance.photoURL,
      'joinedAt': _timestampToJson(instance.joinedAt),
      'hasPicked': instance.hasPicked,
      'pickedAt': _timestampToJson(instance.pickedAt),
      'assignedToUserId': instance.assignedToUserId,
      'profileDetails': instance.profileDetails,
    };
