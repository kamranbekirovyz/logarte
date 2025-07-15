
import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';

/// A widget that detects taps and shows the [Logarte] widget when the user
class LogarteMagicalTap extends StatefulWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// How this gesture detector should behave during hit testing.
  ///
  /// Defaults to [HitTestBehavior.translucent].
  final HitTestBehavior behavior;

  /// The [Logarte] instance to show when the user taps the widget.
  final Logarte logarte;

  /// Callback to handle taps count.
  final Function(int count)? onTapCountUpdate;

  /// Creates a new instance of [LogarteMagicalTap].
  ///
  /// The [child] and [logarte] arguments are required.
  const LogarteMagicalTap({
    Key? key,
    required this.child,
    required this.logarte,
    this.behavior = HitTestBehavior.translucent,
    this.onTapCountUpdate,
  }) : super(key: key);

  @override
  State<LogarteMagicalTap> createState() => _LogarteMagicalTapState();
}

class _LogarteMagicalTapState extends State<LogarteMagicalTap> {
  late int _count;

  @override
  void initState() {
    super.initState();

    _count = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTap: () {
        _count++;
        widget.onTapCountUpdate?.call(_count);
        if (_count == 10) {
          widget.logarte.attach(context: context, visible: true);
        }
      },
      child: widget.child,
    );
  }
}
