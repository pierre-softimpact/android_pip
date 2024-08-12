import 'package:flutter/material.dart';
import 'package:android_pip/actions/pip_action.dart';
import 'package:android_pip/actions/pip_actions_layout.dart';
import 'package:android_pip/android_pip.dart';

/// Widget that uses PIP callbacks to build some widgets depending on PIP state.
/// At least one of [builder] or [child] must not be null.
/// At least one of [pipBuilder] or [pipChild] must not be null.
///
/// Parameters:
/// * [pipBuilder] function is used when app is in PIP mode.
/// * [pipChild] widget is used when app is in PIP mode and [pipBuilder] is null.
/// * [builder] function is used when app is not in PIP mode.
/// * [child] widget is used when app is not in PIP mode and [builder] is null.
/// * [onPipEntered] function is called when app enters PIP mode.
/// * [onPipExited] function is called when app exits PIP mode.
/// * [pipLayout] defines the PIP actions preset layout.
///
/// See also:
/// * [AndroidPIP], to handle callbacks.
class PipWidget extends StatefulWidget {
  final VoidCallback? onPipEntered;
  final VoidCallback? onPipExited;
  final VoidCallback? onPipMaximised;
  final Function(PipAction)? onPipAction;
  final Widget Function(BuildContext)? builder;
  final Widget? child;
  final Widget Function(BuildContext)? pipBuilder;
  final Widget? pipChild;
  final bool useIndexedStack;
  final PipActionsLayout pipLayout;
  const PipWidget({
    Key? key,
    this.onPipEntered,
    this.onPipExited,
    this.onPipMaximised,
    this.onPipAction,
    this.builder,
    this.child,
    this.pipBuilder,
    this.pipChild,
    this.pipLayout = PipActionsLayout.none,
    this.useIndexedStack = true,
  })  : assert(child != null || builder != null),
        assert(pipChild != null || pipBuilder != null),
        super(key: key);

  @override
  PipWidgetState createState() => PipWidgetState();
}

class PipWidgetState extends State<PipWidget> {
  /// Pip controller to handle callbacks
  late final AndroidPIP pip;

  /// Whether the app is currently in PIP mode
  bool _pipMode = false;

  @override
  void initState() {
    super.initState();
    pip = AndroidPIP(
      onPipEntered: onPipEntered,
      onPipExited: onPipExited,
      onPipAction: onPipAction,
      onPipMaximised: onPipMaximised,
    );
    pip.setPipActionsLayout(widget.pipLayout);
  }

  /// The app entered PIP mode
  void onPipEntered() {
    setState(() {
      _pipMode = true;
    });
    widget.onPipEntered?.call();
  }

  /// The app exited app via PIP mode
  void onPipExited() {
    setState(() {
      _pipMode = false;
    });
    widget.onPipExited?.call();
  }

  /// The app entered app via PIP mode
  void onPipMaximised() {
    setState(() {
      _pipMode = false;
    });
    widget.onPipMaximised?.call();
  }

  /// The user taps one PIP action
  void onPipAction(PipAction action) {
    widget.onPipAction?.call(action);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useIndexedStack) {
      return IndexedStack(
        index: _pipMode ? 0 : 1,
        children: [
          (widget.pipBuilder?.call(context) ?? widget.pipChild!),
          (widget.builder?.call(context) ?? widget.child!)
        ],
      );
    }
    return _pipMode
        ? (widget.pipBuilder?.call(context) ?? widget.pipChild!)
        : (widget.builder?.call(context) ?? widget.child!);
  }
}
