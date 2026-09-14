import 'package:equatable/equatable.dart';

enum LoadStatus { initial, loading, success, empty, failure }

class LoadState<T> extends Equatable {
  const LoadState({this.status = LoadStatus.initial, this.data, this.message});

  const LoadState.loading({T? previous})
    : status = LoadStatus.loading,
      data = previous,
      message = null;

  const LoadState.success(T value)
    : status = LoadStatus.success,
      data = value,
      message = null;

  const LoadState.empty()
    : status = LoadStatus.empty,
      data = null,
      message = null;

  const LoadState.failure(String error, {T? previous})
    : status = LoadStatus.failure,
      data = previous,
      message = error;

  final LoadStatus status;
  final T? data;
  final String? message;

  bool get isLoading => status == LoadStatus.loading;
  bool get hasData => data != null;

  @override
  List<Object?> get props => [status, data, message];
}
