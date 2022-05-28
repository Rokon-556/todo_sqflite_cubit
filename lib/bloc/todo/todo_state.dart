part of 'todo_cubit.dart';

@immutable
 class TodoState extends Equatable{
  const TodoState();
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}

class TodoInitialState extends TodoState {
  final int counter;
  const TodoInitialState(this.counter);
  @override
  // TODO: implement props
  List<Object?> get props => [counter];
}
class TodoAddState extends TodoState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
class TodoRemoveState extends TodoState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
