import 'package:flutter/foundation.dart';

/// Base MVC controller: holds view state and notifies Provider listeners.
class NotifierController<T> extends ChangeNotifier {
  NotifierController(this._state);

  T _state;

  T get state => _state;

  @protected
  void emit(T value) {
    _state = value;
    notifyListeners();
  }
}
