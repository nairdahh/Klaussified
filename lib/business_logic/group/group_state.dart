import 'package:equatable/equatable.dart';
import 'package:klaussified/data/models/group_model.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

class GroupInitial extends GroupState {
  const GroupInitial();
}

class GroupLoading extends GroupState {
  const GroupLoading();
}

class GroupsLoaded extends GroupState {
  final List<GroupModel> activeGroups;
  final List<GroupModel> closedGroups;

  const GroupsLoaded({
    required this.activeGroups,
    required this.closedGroups,
  });

  @override
  List<Object?> get props => [activeGroups, closedGroups];
}

class GroupOperationSuccess extends GroupState {
  final String message;
  const GroupOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class GroupError extends GroupState {
  final String message;
  const GroupError({required this.message});

  @override
  List<Object?> get props => [message];
}
