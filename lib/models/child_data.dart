import 'package:equatable/equatable.dart';
import 'package:my_school_teacher/models/child.dart';

class ChildData<T> extends Equatable {
  const ChildData({required this.child, required this.data});

  final Child child;
  final T data;

  @override
  List<Object?> get props => [child, data];
}
