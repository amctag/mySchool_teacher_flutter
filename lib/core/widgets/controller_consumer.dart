import 'package:flutter/material.dart';
import 'package:my_school_teacher/controllers/notifier_controller.dart';
import 'package:provider/provider.dart';

/// Listens for controller state changes and rebuilds the view (MVC + Provider).
class ControllerConsumer<C extends NotifierController<S>, S>
    extends StatefulWidget {
  const ControllerConsumer({
    super.key,
    required this.builder,
    this.listener,
  });

  final Widget Function(BuildContext context, S state) builder;
  final void Function(BuildContext context, S state)? listener;

  @override
  State<ControllerConsumer<C, S>> createState() =>
      _ControllerConsumerState<C, S>();
}

class _ControllerConsumerState<C extends NotifierController<S>, S>
    extends State<ControllerConsumer<C, S>> {
  late final C _controller;
  late S _previous;

  @override
  void initState() {
    super.initState();
    _controller = context.read<C>();
    _previous = _controller.state;
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    final next = _controller.state;
    if (_previous != next) {
      widget.listener?.call(context, next);
      _previous = next;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _controller.state);
}
