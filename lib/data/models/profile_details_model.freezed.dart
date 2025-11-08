// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProfileDetailsModel _$ProfileDetailsModelFromJson(Map<String, dynamic> json) {
  return _ProfileDetailsModel.fromJson(json);
}

/// @nodoc
mixin _$ProfileDetailsModel {
  String get realName => throw _privateConstructorUsedError;
  String get hobbies => throw _privateConstructorUsedError;
  String get wishes => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ProfileDetailsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileDetailsModelCopyWith<ProfileDetailsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileDetailsModelCopyWith<$Res> {
  factory $ProfileDetailsModelCopyWith(
          ProfileDetailsModel value, $Res Function(ProfileDetailsModel) then) =
      _$ProfileDetailsModelCopyWithImpl<$Res, ProfileDetailsModel>;
  @useResult
  $Res call(
      {String realName,
      String hobbies,
      String wishes,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$ProfileDetailsModelCopyWithImpl<$Res, $Val extends ProfileDetailsModel>
    implements $ProfileDetailsModelCopyWith<$Res> {
  _$ProfileDetailsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? realName = null,
    Object? hobbies = null,
    Object? wishes = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      realName: null == realName
          ? _value.realName
          : realName // ignore: cast_nullable_to_non_nullable
              as String,
      hobbies: null == hobbies
          ? _value.hobbies
          : hobbies // ignore: cast_nullable_to_non_nullable
              as String,
      wishes: null == wishes
          ? _value.wishes
          : wishes // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileDetailsModelImplCopyWith<$Res>
    implements $ProfileDetailsModelCopyWith<$Res> {
  factory _$$ProfileDetailsModelImplCopyWith(_$ProfileDetailsModelImpl value,
          $Res Function(_$ProfileDetailsModelImpl) then) =
      __$$ProfileDetailsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String realName,
      String hobbies,
      String wishes,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$ProfileDetailsModelImplCopyWithImpl<$Res>
    extends _$ProfileDetailsModelCopyWithImpl<$Res, _$ProfileDetailsModelImpl>
    implements _$$ProfileDetailsModelImplCopyWith<$Res> {
  __$$ProfileDetailsModelImplCopyWithImpl(_$ProfileDetailsModelImpl _value,
      $Res Function(_$ProfileDetailsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? realName = null,
    Object? hobbies = null,
    Object? wishes = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ProfileDetailsModelImpl(
      realName: null == realName
          ? _value.realName
          : realName // ignore: cast_nullable_to_non_nullable
              as String,
      hobbies: null == hobbies
          ? _value.hobbies
          : hobbies // ignore: cast_nullable_to_non_nullable
              as String,
      wishes: null == wishes
          ? _value.wishes
          : wishes // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileDetailsModelImpl extends _ProfileDetailsModel {
  const _$ProfileDetailsModelImpl(
      {this.realName = '',
      this.hobbies = '',
      this.wishes = '',
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.updatedAt})
      : super._();

  factory _$ProfileDetailsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileDetailsModelImplFromJson(json);

  @override
  @JsonKey()
  final String realName;
  @override
  @JsonKey()
  final String hobbies;
  @override
  @JsonKey()
  final String wishes;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ProfileDetailsModel(realName: $realName, hobbies: $hobbies, wishes: $wishes, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileDetailsModelImpl &&
            (identical(other.realName, realName) ||
                other.realName == realName) &&
            (identical(other.hobbies, hobbies) || other.hobbies == hobbies) &&
            (identical(other.wishes, wishes) || other.wishes == wishes) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, realName, hobbies, wishes, updatedAt);

  /// Create a copy of ProfileDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileDetailsModelImplCopyWith<_$ProfileDetailsModelImpl> get copyWith =>
      __$$ProfileDetailsModelImplCopyWithImpl<_$ProfileDetailsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileDetailsModelImplToJson(
      this,
    );
  }
}

abstract class _ProfileDetailsModel extends ProfileDetailsModel {
  const factory _ProfileDetailsModel(
      {final String realName,
      final String hobbies,
      final String wishes,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? updatedAt}) = _$ProfileDetailsModelImpl;
  const _ProfileDetailsModel._() : super._();

  factory _ProfileDetailsModel.fromJson(Map<String, dynamic> json) =
      _$ProfileDetailsModelImpl.fromJson;

  @override
  String get realName;
  @override
  String get hobbies;
  @override
  String get wishes;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt;

  /// Create a copy of ProfileDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileDetailsModelImplCopyWith<_$ProfileDetailsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
