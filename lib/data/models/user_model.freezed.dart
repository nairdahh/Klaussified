// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get uid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get photoURL => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<String> get authProviders =>
      throw _privateConstructorUsedError; // Email notification preferences
  bool get emailNotificationsEnabled => throw _privateConstructorUsedError;
  bool get emailInviteNotifications => throw _privateConstructorUsedError;
  bool get emailDeadlineNotifications =>
      throw _privateConstructorUsedError; // Browser notification preferences (placeholder)
  bool get browserNotificationsEnabled => throw _privateConstructorUsedError;
  bool get browserInviteNotifications => throw _privateConstructorUsedError;
  bool get browserDeadlineNotifications => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String uid,
      String email,
      String username,
      String displayName,
      String photoURL,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime updatedAt,
      List<String> authProviders,
      bool emailNotificationsEnabled,
      bool emailInviteNotifications,
      bool emailDeadlineNotifications,
      bool browserNotificationsEnabled,
      bool browserInviteNotifications,
      bool browserDeadlineNotifications});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? username = null,
    Object? displayName = null,
    Object? photoURL = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? authProviders = null,
    Object? emailNotificationsEnabled = null,
    Object? emailInviteNotifications = null,
    Object? emailDeadlineNotifications = null,
    Object? browserNotificationsEnabled = null,
    Object? browserInviteNotifications = null,
    Object? browserDeadlineNotifications = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoURL: null == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      authProviders: null == authProviders
          ? _value.authProviders
          : authProviders // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emailNotificationsEnabled: null == emailNotificationsEnabled
          ? _value.emailNotificationsEnabled
          : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailInviteNotifications: null == emailInviteNotifications
          ? _value.emailInviteNotifications
          : emailInviteNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      emailDeadlineNotifications: null == emailDeadlineNotifications
          ? _value.emailDeadlineNotifications
          : emailDeadlineNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      browserNotificationsEnabled: null == browserNotificationsEnabled
          ? _value.browserNotificationsEnabled
          : browserNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      browserInviteNotifications: null == browserInviteNotifications
          ? _value.browserInviteNotifications
          : browserInviteNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      browserDeadlineNotifications: null == browserDeadlineNotifications
          ? _value.browserDeadlineNotifications
          : browserDeadlineNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String email,
      String username,
      String displayName,
      String photoURL,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime updatedAt,
      List<String> authProviders,
      bool emailNotificationsEnabled,
      bool emailInviteNotifications,
      bool emailDeadlineNotifications,
      bool browserNotificationsEnabled,
      bool browserInviteNotifications,
      bool browserDeadlineNotifications});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? username = null,
    Object? displayName = null,
    Object? photoURL = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? authProviders = null,
    Object? emailNotificationsEnabled = null,
    Object? emailInviteNotifications = null,
    Object? emailDeadlineNotifications = null,
    Object? browserNotificationsEnabled = null,
    Object? browserInviteNotifications = null,
    Object? browserDeadlineNotifications = null,
  }) {
    return _then(_$UserModelImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoURL: null == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      authProviders: null == authProviders
          ? _value._authProviders
          : authProviders // ignore: cast_nullable_to_non_nullable
              as List<String>,
      emailNotificationsEnabled: null == emailNotificationsEnabled
          ? _value.emailNotificationsEnabled
          : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailInviteNotifications: null == emailInviteNotifications
          ? _value.emailInviteNotifications
          : emailInviteNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      emailDeadlineNotifications: null == emailDeadlineNotifications
          ? _value.emailDeadlineNotifications
          : emailDeadlineNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      browserNotificationsEnabled: null == browserNotificationsEnabled
          ? _value.browserNotificationsEnabled
          : browserNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      browserInviteNotifications: null == browserInviteNotifications
          ? _value.browserInviteNotifications
          : browserInviteNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      browserDeadlineNotifications: null == browserDeadlineNotifications
          ? _value.browserDeadlineNotifications
          : browserDeadlineNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl(
      {required this.uid,
      required this.email,
      required this.username,
      this.displayName = '',
      this.photoURL = '',
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required this.updatedAt,
      final List<String> authProviders = const [],
      this.emailNotificationsEnabled = true,
      this.emailInviteNotifications = true,
      this.emailDeadlineNotifications = true,
      this.browserNotificationsEnabled = true,
      this.browserInviteNotifications = true,
      this.browserDeadlineNotifications = true})
      : _authProviders = authProviders,
        super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String uid;
  @override
  final String email;
  @override
  final String username;
  @override
  @JsonKey()
  final String displayName;
  @override
  @JsonKey()
  final String photoURL;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime updatedAt;
  final List<String> _authProviders;
  @override
  @JsonKey()
  List<String> get authProviders {
    if (_authProviders is EqualUnmodifiableListView) return _authProviders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_authProviders);
  }

// Email notification preferences
  @override
  @JsonKey()
  final bool emailNotificationsEnabled;
  @override
  @JsonKey()
  final bool emailInviteNotifications;
  @override
  @JsonKey()
  final bool emailDeadlineNotifications;
// Browser notification preferences (placeholder)
  @override
  @JsonKey()
  final bool browserNotificationsEnabled;
  @override
  @JsonKey()
  final bool browserInviteNotifications;
  @override
  @JsonKey()
  final bool browserDeadlineNotifications;

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, username: $username, displayName: $displayName, photoURL: $photoURL, createdAt: $createdAt, updatedAt: $updatedAt, authProviders: $authProviders, emailNotificationsEnabled: $emailNotificationsEnabled, emailInviteNotifications: $emailInviteNotifications, emailDeadlineNotifications: $emailDeadlineNotifications, browserNotificationsEnabled: $browserNotificationsEnabled, browserInviteNotifications: $browserInviteNotifications, browserDeadlineNotifications: $browserDeadlineNotifications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoURL, photoURL) ||
                other.photoURL == photoURL) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._authProviders, _authProviders) &&
            (identical(other.emailNotificationsEnabled, emailNotificationsEnabled) ||
                other.emailNotificationsEnabled == emailNotificationsEnabled) &&
            (identical(other.emailInviteNotifications, emailInviteNotifications) ||
                other.emailInviteNotifications == emailInviteNotifications) &&
            (identical(other.emailDeadlineNotifications,
                    emailDeadlineNotifications) ||
                other.emailDeadlineNotifications ==
                    emailDeadlineNotifications) &&
            (identical(other.browserNotificationsEnabled,
                    browserNotificationsEnabled) ||
                other.browserNotificationsEnabled ==
                    browserNotificationsEnabled) &&
            (identical(other.browserInviteNotifications,
                    browserInviteNotifications) ||
                other.browserInviteNotifications ==
                    browserInviteNotifications) &&
            (identical(other.browserDeadlineNotifications,
                    browserDeadlineNotifications) ||
                other.browserDeadlineNotifications ==
                    browserDeadlineNotifications));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      email,
      username,
      displayName,
      photoURL,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_authProviders),
      emailNotificationsEnabled,
      emailInviteNotifications,
      emailDeadlineNotifications,
      browserNotificationsEnabled,
      browserInviteNotifications,
      browserDeadlineNotifications);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel(
      {required final String uid,
      required final String email,
      required final String username,
      final String displayName,
      final String photoURL,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required final DateTime createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required final DateTime updatedAt,
      final List<String> authProviders,
      final bool emailNotificationsEnabled,
      final bool emailInviteNotifications,
      final bool emailDeadlineNotifications,
      final bool browserNotificationsEnabled,
      final bool browserInviteNotifications,
      final bool browserDeadlineNotifications}) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get uid;
  @override
  String get email;
  @override
  String get username;
  @override
  String get displayName;
  @override
  String get photoURL;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get updatedAt;
  @override
  List<String> get authProviders; // Email notification preferences
  @override
  bool get emailNotificationsEnabled;
  @override
  bool get emailInviteNotifications;
  @override
  bool
      get emailDeadlineNotifications; // Browser notification preferences (placeholder)
  @override
  bool get browserNotificationsEnabled;
  @override
  bool get browserInviteNotifications;
  @override
  bool get browserDeadlineNotifications;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
