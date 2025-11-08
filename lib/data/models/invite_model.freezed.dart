// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InviteModel _$InviteModelFromJson(Map<String, dynamic> json) {
  return _InviteModel.fromJson(json);
}

/// @nodoc
mixin _$InviteModel {
  String get id => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  String get groupName => throw _privateConstructorUsedError;
  String get invitedBy => throw _privateConstructorUsedError; // userId
  String get invitedByName => throw _privateConstructorUsedError;
  String? get inviteeEmail => throw _privateConstructorUsedError;
  String? get inviteeUsername => throw _privateConstructorUsedError;
  String? get inviteeUserId =>
      throw _privateConstructorUsedError; // If existing user
  String get status => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get respondedAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this InviteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InviteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InviteModelCopyWith<InviteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InviteModelCopyWith<$Res> {
  factory $InviteModelCopyWith(
          InviteModel value, $Res Function(InviteModel) then) =
      _$InviteModelCopyWithImpl<$Res, InviteModel>;
  @useResult
  $Res call(
      {String id,
      String groupId,
      String groupName,
      String invitedBy,
      String invitedByName,
      String? inviteeEmail,
      String? inviteeUsername,
      String? inviteeUserId,
      String status,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? respondedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? expiresAt});
}

/// @nodoc
class _$InviteModelCopyWithImpl<$Res, $Val extends InviteModel>
    implements $InviteModelCopyWith<$Res> {
  _$InviteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InviteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? groupName = null,
    Object? invitedBy = null,
    Object? invitedByName = null,
    Object? inviteeEmail = freezed,
    Object? inviteeUsername = freezed,
    Object? inviteeUserId = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? respondedAt = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
      invitedBy: null == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as String,
      invitedByName: null == invitedByName
          ? _value.invitedByName
          : invitedByName // ignore: cast_nullable_to_non_nullable
              as String,
      inviteeEmail: freezed == inviteeEmail
          ? _value.inviteeEmail
          : inviteeEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      inviteeUsername: freezed == inviteeUsername
          ? _value.inviteeUsername
          : inviteeUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      inviteeUserId: freezed == inviteeUserId
          ? _value.inviteeUserId
          : inviteeUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InviteModelImplCopyWith<$Res>
    implements $InviteModelCopyWith<$Res> {
  factory _$$InviteModelImplCopyWith(
          _$InviteModelImpl value, $Res Function(_$InviteModelImpl) then) =
      __$$InviteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String groupId,
      String groupName,
      String invitedBy,
      String invitedByName,
      String? inviteeEmail,
      String? inviteeUsername,
      String? inviteeUserId,
      String status,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? respondedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? expiresAt});
}

/// @nodoc
class __$$InviteModelImplCopyWithImpl<$Res>
    extends _$InviteModelCopyWithImpl<$Res, _$InviteModelImpl>
    implements _$$InviteModelImplCopyWith<$Res> {
  __$$InviteModelImplCopyWithImpl(
      _$InviteModelImpl _value, $Res Function(_$InviteModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of InviteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? groupName = null,
    Object? invitedBy = null,
    Object? invitedByName = null,
    Object? inviteeEmail = freezed,
    Object? inviteeUsername = freezed,
    Object? inviteeUserId = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? respondedAt = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_$InviteModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
      invitedBy: null == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as String,
      invitedByName: null == invitedByName
          ? _value.invitedByName
          : invitedByName // ignore: cast_nullable_to_non_nullable
              as String,
      inviteeEmail: freezed == inviteeEmail
          ? _value.inviteeEmail
          : inviteeEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      inviteeUsername: freezed == inviteeUsername
          ? _value.inviteeUsername
          : inviteeUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      inviteeUserId: freezed == inviteeUserId
          ? _value.inviteeUserId
          : inviteeUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InviteModelImpl extends _InviteModel {
  const _$InviteModelImpl(
      {required this.id,
      required this.groupId,
      required this.groupName,
      required this.invitedBy,
      required this.invitedByName,
      this.inviteeEmail,
      this.inviteeUsername,
      this.inviteeUserId,
      this.status = AppConstants.inviteStatusPending,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.respondedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.expiresAt})
      : super._();

  factory _$InviteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InviteModelImplFromJson(json);

  @override
  final String id;
  @override
  final String groupId;
  @override
  final String groupName;
  @override
  final String invitedBy;
// userId
  @override
  final String invitedByName;
  @override
  final String? inviteeEmail;
  @override
  final String? inviteeUsername;
  @override
  final String? inviteeUserId;
// If existing user
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? respondedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'InviteModel(id: $id, groupId: $groupId, groupName: $groupName, invitedBy: $invitedBy, invitedByName: $invitedByName, inviteeEmail: $inviteeEmail, inviteeUsername: $inviteeUsername, inviteeUserId: $inviteeUserId, status: $status, createdAt: $createdAt, respondedAt: $respondedAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InviteModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.invitedBy, invitedBy) ||
                other.invitedBy == invitedBy) &&
            (identical(other.invitedByName, invitedByName) ||
                other.invitedByName == invitedByName) &&
            (identical(other.inviteeEmail, inviteeEmail) ||
                other.inviteeEmail == inviteeEmail) &&
            (identical(other.inviteeUsername, inviteeUsername) ||
                other.inviteeUsername == inviteeUsername) &&
            (identical(other.inviteeUserId, inviteeUserId) ||
                other.inviteeUserId == inviteeUserId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      groupId,
      groupName,
      invitedBy,
      invitedByName,
      inviteeEmail,
      inviteeUsername,
      inviteeUserId,
      status,
      createdAt,
      respondedAt,
      expiresAt);

  /// Create a copy of InviteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InviteModelImplCopyWith<_$InviteModelImpl> get copyWith =>
      __$$InviteModelImplCopyWithImpl<_$InviteModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InviteModelImplToJson(
      this,
    );
  }
}

abstract class _InviteModel extends InviteModel {
  const factory _InviteModel(
      {required final String id,
      required final String groupId,
      required final String groupName,
      required final String invitedBy,
      required final String invitedByName,
      final String? inviteeEmail,
      final String? inviteeUsername,
      final String? inviteeUserId,
      final String status,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required final DateTime createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? respondedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? expiresAt}) = _$InviteModelImpl;
  const _InviteModel._() : super._();

  factory _InviteModel.fromJson(Map<String, dynamic> json) =
      _$InviteModelImpl.fromJson;

  @override
  String get id;
  @override
  String get groupId;
  @override
  String get groupName;
  @override
  String get invitedBy; // userId
  @override
  String get invitedByName;
  @override
  String? get inviteeEmail;
  @override
  String? get inviteeUsername;
  @override
  String? get inviteeUserId; // If existing user
  @override
  String get status;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get respondedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get expiresAt;

  /// Create a copy of InviteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InviteModelImplCopyWith<_$InviteModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
