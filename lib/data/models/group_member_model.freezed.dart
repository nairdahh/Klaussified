// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_member_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GroupMemberModel _$GroupMemberModelFromJson(Map<String, dynamic> json) {
  return _GroupMemberModel.fromJson(json);
}

/// @nodoc
mixin _$GroupMemberModel {
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get photoURL => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get joinedAt => throw _privateConstructorUsedError;
  bool get hasPicked => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get pickedAt => throw _privateConstructorUsedError;
  String? get assignedToUserId =>
      throw _privateConstructorUsedError; // Only visible to the user (their Secret Santa assignment)
  ProfileDetailsModel get profileDetails => throw _privateConstructorUsedError;

  /// Serializes this GroupMemberModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupMemberModelCopyWith<GroupMemberModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupMemberModelCopyWith<$Res> {
  factory $GroupMemberModelCopyWith(
          GroupMemberModel value, $Res Function(GroupMemberModel) then) =
      _$GroupMemberModelCopyWithImpl<$Res, GroupMemberModel>;
  @useResult
  $Res call(
      {String userId,
      String displayName,
      String username,
      String photoURL,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime joinedAt,
      bool hasPicked,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? pickedAt,
      String? assignedToUserId,
      ProfileDetailsModel profileDetails});

  $ProfileDetailsModelCopyWith<$Res> get profileDetails;
}

/// @nodoc
class _$GroupMemberModelCopyWithImpl<$Res, $Val extends GroupMemberModel>
    implements $GroupMemberModelCopyWith<$Res> {
  _$GroupMemberModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? username = null,
    Object? photoURL = null,
    Object? joinedAt = null,
    Object? hasPicked = null,
    Object? pickedAt = freezed,
    Object? assignedToUserId = freezed,
    Object? profileDetails = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      photoURL: null == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hasPicked: null == hasPicked
          ? _value.hasPicked
          : hasPicked // ignore: cast_nullable_to_non_nullable
              as bool,
      pickedAt: freezed == pickedAt
          ? _value.pickedAt
          : pickedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      assignedToUserId: freezed == assignedToUserId
          ? _value.assignedToUserId
          : assignedToUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      profileDetails: null == profileDetails
          ? _value.profileDetails
          : profileDetails // ignore: cast_nullable_to_non_nullable
              as ProfileDetailsModel,
    ) as $Val);
  }

  /// Create a copy of GroupMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileDetailsModelCopyWith<$Res> get profileDetails {
    return $ProfileDetailsModelCopyWith<$Res>(_value.profileDetails, (value) {
      return _then(_value.copyWith(profileDetails: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GroupMemberModelImplCopyWith<$Res>
    implements $GroupMemberModelCopyWith<$Res> {
  factory _$$GroupMemberModelImplCopyWith(_$GroupMemberModelImpl value,
          $Res Function(_$GroupMemberModelImpl) then) =
      __$$GroupMemberModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String displayName,
      String username,
      String photoURL,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime joinedAt,
      bool hasPicked,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? pickedAt,
      String? assignedToUserId,
      ProfileDetailsModel profileDetails});

  @override
  $ProfileDetailsModelCopyWith<$Res> get profileDetails;
}

/// @nodoc
class __$$GroupMemberModelImplCopyWithImpl<$Res>
    extends _$GroupMemberModelCopyWithImpl<$Res, _$GroupMemberModelImpl>
    implements _$$GroupMemberModelImplCopyWith<$Res> {
  __$$GroupMemberModelImplCopyWithImpl(_$GroupMemberModelImpl _value,
      $Res Function(_$GroupMemberModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? username = null,
    Object? photoURL = null,
    Object? joinedAt = null,
    Object? hasPicked = null,
    Object? pickedAt = freezed,
    Object? assignedToUserId = freezed,
    Object? profileDetails = null,
  }) {
    return _then(_$GroupMemberModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      photoURL: null == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hasPicked: null == hasPicked
          ? _value.hasPicked
          : hasPicked // ignore: cast_nullable_to_non_nullable
              as bool,
      pickedAt: freezed == pickedAt
          ? _value.pickedAt
          : pickedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      assignedToUserId: freezed == assignedToUserId
          ? _value.assignedToUserId
          : assignedToUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      profileDetails: null == profileDetails
          ? _value.profileDetails
          : profileDetails // ignore: cast_nullable_to_non_nullable
              as ProfileDetailsModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupMemberModelImpl extends _GroupMemberModel {
  const _$GroupMemberModelImpl(
      {required this.userId,
      required this.displayName,
      required this.username,
      this.photoURL = '',
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required this.joinedAt,
      this.hasPicked = false,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.pickedAt,
      this.assignedToUserId,
      this.profileDetails = const ProfileDetailsModel()})
      : super._();

  factory _$GroupMemberModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupMemberModelImplFromJson(json);

  @override
  final String userId;
  @override
  final String displayName;
  @override
  final String username;
  @override
  @JsonKey()
  final String photoURL;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime joinedAt;
  @override
  @JsonKey()
  final bool hasPicked;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? pickedAt;
  @override
  final String? assignedToUserId;
// Only visible to the user (their Secret Santa assignment)
  @override
  @JsonKey()
  final ProfileDetailsModel profileDetails;

  @override
  String toString() {
    return 'GroupMemberModel(userId: $userId, displayName: $displayName, username: $username, photoURL: $photoURL, joinedAt: $joinedAt, hasPicked: $hasPicked, pickedAt: $pickedAt, assignedToUserId: $assignedToUserId, profileDetails: $profileDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupMemberModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.photoURL, photoURL) ||
                other.photoURL == photoURL) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.hasPicked, hasPicked) ||
                other.hasPicked == hasPicked) &&
            (identical(other.pickedAt, pickedAt) ||
                other.pickedAt == pickedAt) &&
            (identical(other.assignedToUserId, assignedToUserId) ||
                other.assignedToUserId == assignedToUserId) &&
            (identical(other.profileDetails, profileDetails) ||
                other.profileDetails == profileDetails));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      displayName,
      username,
      photoURL,
      joinedAt,
      hasPicked,
      pickedAt,
      assignedToUserId,
      profileDetails);

  /// Create a copy of GroupMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupMemberModelImplCopyWith<_$GroupMemberModelImpl> get copyWith =>
      __$$GroupMemberModelImplCopyWithImpl<_$GroupMemberModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupMemberModelImplToJson(
      this,
    );
  }
}

abstract class _GroupMemberModel extends GroupMemberModel {
  const factory _GroupMemberModel(
      {required final String userId,
      required final String displayName,
      required final String username,
      final String photoURL,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required final DateTime joinedAt,
      final bool hasPicked,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? pickedAt,
      final String? assignedToUserId,
      final ProfileDetailsModel profileDetails}) = _$GroupMemberModelImpl;
  const _GroupMemberModel._() : super._();

  factory _GroupMemberModel.fromJson(Map<String, dynamic> json) =
      _$GroupMemberModelImpl.fromJson;

  @override
  String get userId;
  @override
  String get displayName;
  @override
  String get username;
  @override
  String get photoURL;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get joinedAt;
  @override
  bool get hasPicked;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get pickedAt;
  @override
  String?
      get assignedToUserId; // Only visible to the user (their Secret Santa assignment)
  @override
  ProfileDetailsModel get profileDetails;

  /// Create a copy of GroupMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupMemberModelImplCopyWith<_$GroupMemberModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
