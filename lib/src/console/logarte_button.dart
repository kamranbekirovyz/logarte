import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/logarte_auth_screen.dart';

const double _buttonSize = 52.0;
const double _edgeMargin = 12.0;

/// The draggable floating button that opens and closes the console.
class LogarteButton extends StatefulWidget {
  final Logarte instance;

  const LogarteButton(
    this.instance, {
    Key? key,
  }) : super(key: key);

  @override
  State<LogarteButton> createState() => _LogarteButtonState();
}

class _LogarteButtonState extends State<LogarteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  Animation<Offset>? _animation;
  Offset _offset = Offset.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        final animation = _animation;
        if (animation != null) setState(() => _offset = animation.value);
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final size = MediaQuery.of(context).size;
        setState(() {
          _offset = Offset(
            size.width - _buttonSize - _edgeMargin,
            (size.height / 2) - _edgeMargin,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _animationController.stop();
    setState(() => _isDragging = true);
  }

  void _updatePosition(DragUpdateDetails details) {
    final size = MediaQuery.of(context).size;
    setState(() {
      _offset = Offset(
        (_offset.dx + details.delta.dx).clamp(0, size.width - _buttonSize),
        (_offset.dy + details.delta.dy).clamp(0, size.height - _buttonSize),
      );
    });
  }

  void _snapToEdge(DragEndDetails details) {
    final size = MediaQuery.of(context).size;
    final distanceToLeft = _offset.dx;
    final distanceToRight = size.width - (_offset.dx + _buttonSize);
    final targetX = distanceToLeft < distanceToRight
        ? _edgeMargin
        : size.width - _buttonSize - _edgeMargin;

    _animation = Tween<Offset>(
      begin: _offset,
      end: Offset(targetX, _offset.dy),
    )
        .chain(CurveTween(curve: Curves.easeOutExpo))
        .animate(_animationController);

    _animationController.forward(from: 0);
    setState(() => _isDragging = false);
  }

  void _onTap() {
    if (_isDragging) return;

    if (widget.instance.button.isConsoleOpen.value) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => LogarteAuthScreen(widget.instance),
          settings: const RouteSettings(name: '/logarte_auth'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _updatePosition,
          onPanEnd: _snapToEdge,
          child: ValueListenableBuilder<bool>(
            valueListenable: widget.instance.button.isConsoleOpen,
            builder: (_, isOpen, __) {
              return GestureDetector(
                onTap: _onTap,
                onDoubleTap: () {
                  if (!isOpen && !_isDragging) {
                    widget.instance.onRocketDoubleTapped?.call(context);
                  }
                },
                onLongPress: () {
                  if (!isOpen && !_isDragging) {
                    widget.instance.onRocketLongPressed?.call(context);
                  }
                },
                child: AnimatedContainer(
                  duration: kThemeAnimationDuration,
                  width: _buttonSize,
                  height: _buttonSize,
                  decoration: BoxDecoration(
                    color: isOpen ? Colors.red : Colors.lightBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isOpen ? Icons.close : Icons.terminal,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
