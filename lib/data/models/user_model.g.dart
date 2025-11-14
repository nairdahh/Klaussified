// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String? ?? '',
      photoURL: json['photoURL'] as String? ?? '',
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
      authProviders: (json['authProviders'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      emailNotificationsEnabled:
          json['emailNotificationsEnabled'] as bool? ?? true,
      emailInviteNotifications:
          json['emailInviteNotifications'] as bool? ?? true,
      emailDeadlineNotifications:
          json['emailDeadlineNotifications'] as bool? ?? true,
      browserNotificationsEnabled:
          json['browserNotificationsEnabled'] as bool? ?? true,
      browserInviteNotifications:
          json['browserInviteNotifications'] as bool? ?? true,
      browserDeadlineNotifications:
          json['browserDeadlineNotifications'] as bool? ?? true,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'username': instance.username,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
      'authProviders': instance.authProviders,
      'emailNotificationsEnabled': instance.emailNotificationsEnabled,
      'emailInviteNotifications': instance.emailInviteNotifications,
      'emailDeadlineNotifications': instance.emailDeadlineNotifications,
      'browserNotificationsEnabled': instance.browserNotificationsEnabled,
      'browserInviteNotifications': instance.browserInviteNotifications,
      'browserDeadlineNotifications': instance.browserDeadlineNotifications,
    };
