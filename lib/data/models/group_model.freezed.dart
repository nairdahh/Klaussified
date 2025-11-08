// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) {
  return _GroupModel.fromJson(json);
}

/// @nodoc
mixin _$GroupModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get ownerName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get description =>
      throw _privateConstructorUsedError; // Event details/description
  String get location => throw _privateConstructorUsedError; // Event location
  String get budget => throw _privateConstructorUsedError; // Suggested budget
  String get status => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get startedAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get informationalDeadline => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get revealDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get revealedAt => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;
  int get pickedCount => throw _privateConstructorUsedError;
  List<String> get memberIds => throw _privateConstructorUsedError;

  /// Serializes this GroupModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupModelCopyWith<GroupModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupModelCopyWith<$Res> {
  factory $GroupModelCopyWith(
          GroupModel value, $Res Function(GroupModel) then) =
      _$GroupModelCopyWithImpl<$Res, GroupModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String ownerId,
      String ownerName,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime createdAt,
      String description,
      String location,
      String budget,
      String status,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? startedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? informationalDeadline,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? revealDate,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? revealedAt,
      int memberCount,
      int pickedCount,
      List<String> memberIds});
}

/// @nodoc
class _$GroupModelCopyWithImpl<$Res, $Val extends GroupModel>
    implements $GroupModelCopyWith<$Res> {
  _$GroupModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ownerId = null,
    Object? ownerName = null,
    Object? createdAt = null,
    Object? description = null,
    Object? location = null,
    Object? budget = null,
    Object? status = null,
    Object? startedAt = freezed,
    Object? informationalDeadline = freezed,
    Object? revealDate = freezed,
    Object? revealedAt = freezed,
    Object? memberCount = null,
    Object? pickedCount = null,
    Object? memberIds = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerName: null == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      informationalDeadline: freezed == informationalDeadline
          ? _value.informationalDeadline
          : informationalDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      revealDate: freezed == revealDate
          ? _value.revealDate
          : revealDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      revealedAt: freezed == revealedAt
          ? _value.revealedAt
          : revealedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      pickedCount: null == pickedCount
          ? _value.pickedCount
          : pickedCount // ignore: cast_nullable_to_non_nullable
              as int,
      memberIds: null == memberIds
          ? _value.memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupModelImplCopyWith<$Res>
    implements $GroupModelCopyWith<$Res> {
  factory _$$GroupModelImplCopyWith(
          _$GroupModelImpl value, $Res Function(_$GroupModelImpl) then) =
      __$$GroupModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String ownerId,
      String ownerName,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime createdAt,
      String description,
      String location,
      String budget,
      String status,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? startedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? informationalDeadline,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? revealDate,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? revealedAt,
      int memberCount,
      int pickedCount,
      List<String> memberIds});
}

/// @nodoc
class __$$GroupModelImplCopyWithImpl<$Res>
    extends _$GroupModelCopyWithImpl<$Res, _$GroupModelImpl>
    implements _$$GroupModelImplCopyWith<$Res> {
  __$$GroupModelImplCopyWithImpl(
      _$GroupModelImpl _value, $Res Function(_$GroupModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ownerId = null,
    Object? ownerName = null,
    Object? createdAt = null,
    Object? description = null,
    Object? location = null,
    Object? budget = null,
    Object? status = null,
    Object? startedAt = freezed,
    Object? informationalDeadline = freezed,
    Object? revealDate = freezed,
    Object? revealedAt = freezed,
    Object? memberCount = null,
    Object? pickedCount = null,
    Object? memberIds = null,
  }) {
    return _then(_$GroupModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerName: null == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      budget: null == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      informationalDeadline: freezed == informationalDeadline
          ? _value.informationalDeadline
          : informationalDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      revealDate: freezed == revealDate
          ? _value.revealDate
          : revealDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      revealedAt: freezed == revealedAt
          ? _value.revealedAt
          : revealedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      pickedCount: null == pickedCount
          ? _value.pickedCount
          : pickedCount // ignore: cast_nullable_to_non_nullable
              as int,
      memberIds: null == memberIds
          ? _value._memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupModelImpl extends _GroupModel {
  const _$GroupModelImpl(
      {required this.id,
      required this.name,
      required this.ownerId,
      required this.ownerName,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required this.createdAt,
      this.description = '',
      this.location = '',
      this.budget = '',
      this.status = AppConstants.statusPending,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.startedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.informationalDeadline,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.revealDate,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.revealedAt,
      this.memberCount = 0,
      this.pickedCount = 0,
      final List<String> memberIds = const []})
      : _memberIds = memberIds,
        super._();

  factory _$GroupModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String ownerId;
  @override
  final String ownerName;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;
  @override
  @JsonKey()
  final String description;
// Event details/description
  @override
  @JsonKey()
  final String location;
// Event location
  @override
  @JsonKey()
  final String budget;
// Suggested budget
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? startedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? informationalDeadline;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? revealDate;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? revealedAt;
  @override
  @JsonKey()
  final int memberCount;
  @override
  @JsonKey()
  final int pickedCount;
  final List<String> _memberIds;
  @override
  @JsonKey()
  List<String> get memberIds {
    if (_memberIds is EqualUnmodifiableListView) return _memberIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberIds);
  }

  @override
  String toString() {
    return 'GroupModel(id: $id, name: $name, ownerId: $ownerId, ownerName: $ownerName, createdAt: $createdAt, description: $description, location: $location, budget: $budget, status: $status, startedAt: $startedAt, informationalDeadline: $informationalDeadline, revealDate: $revealDate, revealedAt: $revealedAt, memberCount: $memberCount, pickedCount: $pickedCount, memberIds: $memberIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.informationalDeadline, informationalDeadline) ||
                other.informationalDeadline == informationalDeadline) &&
            (identical(other.revealDate, revealDate) ||
                other.revealDate == revealDate) &&
            (identical(other.revealedAt, revealedAt) ||
                other.revealedAt == revealedAt) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.pickedCount, pickedCount) ||
                other.pickedCount == pickedCount) &&
            const DeepCollectionEquality()
                .equals(other._memberIds, _memberIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      ownerId,
      ownerName,
      createdAt,
      description,
      location,
      budget,
      status,
      startedAt,
      informationalDeadline,
      revealDate,
      revealedAt,
      memberCount,
      pickedCount,
      const DeepCollectionEquality().hash(_memberIds));

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupModelImplCopyWith<_$GroupModelImpl> get copyWith =>
      __$$GroupModelImplCopyWithImpl<_$GroupModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupModelImplToJson(
      this,
    );
  }
}

abstract class _GroupModel extends GroupModel {
  const factory _GroupModel(
      {required final String id,
      required final String name,
      required final String ownerId,
      required final String ownerName,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      required final DateTime createdAt,
      final String description,
      final String location,
      final String budget,
      final String status,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? startedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? informationalDeadline,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? revealDate,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? revealedAt,
      final int memberCount,
      final int pickedCount,
      final List<String> memberIds}) = _$GroupModelImpl;
  const _GroupModel._() : super._();

  factory _GroupModel.fromJson(Map<String, dynamic> json) =
      _$GroupModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get ownerId;
  @override
  String get ownerName;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime get createdAt;
  @override
  String get description; // Event details/description
  @override
  String get location; // Event location
  @override
  String get budget; // Suggested budget
  @override
  String get status;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get startedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get informationalDeadline;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get revealDate;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get revealedAt;
  @override
  int get memberCount;
  @override
  int get pickedCount;
  @override
  List<String> get memberIds;

  /// Create a copy of GroupModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupModelImplCopyWith<_$GroupModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
