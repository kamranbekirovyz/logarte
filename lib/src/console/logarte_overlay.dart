import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/logarte_auth_screen.dart';
import 'package:logarte/src/console/logarte_fab_state.dart';

class LogarteOverlay extends StatelessWidget {
  final Logarte instance;

  const LogarteOverlay._internal({
    required this.instance,
    Key? key,
  }) : super(key: key);

  // Static tracking mechanism
  static OverlayEntry? _currentEntry;
  static bool _isAttached = false;

  /// Check if LogarteOverlay is currently attached
  static bool get isAttached => _isAttached;

  /// Get the current overlay entry (if attached)
  static OverlayEntry? get currentEntry => _currentEntry;

  static void attach({
    required BuildContext context,
    required Logarte instance,
  }) {
    // Remove existing overlay if already attached
    if (_isAttached && _currentEntry != null) {
      _currentEntry!.remove();
      _isAttached = false;
      _currentEntry = null;
    }

    _currentEntry = OverlayEntry(
      builder: (context) {
        return LogarteOverlay._internal(
          instance: instance,
        );
      },
    );

    Future.delayed(kThemeAnimationDuration, () {
      final overlay = Overlay.of(context);
      overlay.insert(_currentEntry!);
      _isAttached = true;
    });
  }

  /// Detach the current overlay
  static void detach() {
    if (_isAttached && _currentEntry != null) {
      _currentEntry!.remove();
      _isAttached = false;
      _currentEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _DraggableLogarteFAB(instance: instance);
  }
}

class _DraggableLogarteFAB extends StatefulWidget {
  final Logarte instance;

  const _DraggableLogarteFAB({
    Key? key,
    required this.instance,
  }) : super(key: key);

  @override
  State<_DraggableLogarteFAB> createState() => _DraggableLogarteFABState();
}

class _DraggableLogarteFABState extends State<_DraggableLogarteFAB>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
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
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final size = MediaQuery.of(context).size;
        setState(() {
          _offset = Offset(size.width - 52.0 - 12.0, (size.height / 2) - 12.0);
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updatePosition(DragUpdateDetails details) {
    if (!mounted) return;

    final size = MediaQuery.of(context).size;
    setState(() {
      _offset = Offset(
        (_offset.dx + details.delta.dx).clamp(0, size.width - 52.0),
        (_offset.dy + details.delta.dy).clamp(0, size.height - 52.0),
      );
    });
  }

  void _snapToEdge(DragEndDetails details) {
    final size = MediaQuery.of(context).size;
    const buttonWidth = 52.0;
    const edgeMargin = 12.0;

    // Determine which edge is closest
    final distanceToLeft = _offset.dx;
    final distanceToRight = size.width - (_offset.dx + buttonWidth);

    // Calculate target position with margin
    final targetX = distanceToLeft < distanceToRight
        ? edgeMargin
        : size.width - buttonWidth - edgeMargin;

    // Create and configure animation
    _animation = Tween<Offset>(
      begin: _offset,
      end: Offset(targetX, _offset.dy),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutExpo,
    ))
      ..addListener(() {
        if (mounted) {
          setState(() {
            _offset = _animation!.value;
          });
        }
      });

    // Start animation
    _animationController.reset();
    _animationController.forward();

    setState(() => _isDragging = false);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onPanStart: (_) => setState(() => _isDragging = true),
          onPanUpdate: _updatePosition,
          onPanEnd: _snapToEdge,
          child: _LogarteFAB(
            instance: widget.instance,
            onTapAllowed: !_isDragging,
          ),
        ),
      ),
    );
  }
}

class _LogarteFAB extends StatefulWidget {
  final Logarte instance;
  final bool onTapAllowed;

  const _LogarteFAB({
    Key? key,
    required this.instance,
    this.onTapAllowed = true,
  }) : super(key: key);

  @override
  _LogarteFABState createState() => _LogarteFABState();
}

class _LogarteFABState extends State<_LogarteFAB> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _onPressed() async {
    if (!widget.onTapAllowed) return;

    if (LogarteFabState.instance.isOpened) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) {
            return LogarteAuthScreen(widget.instance);
          },
          settings: const RouteSettings(name: '/logarte_auth'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: LogarteFabState.instance.fabStateListener,
      builder: (_, bool isOpened, Widget? child) {
        return GestureDetector(
          onTap: _onPressed,
          onDoubleTap: () {
            if (!isOpened && widget.onTapAllowed) {
              widget.instance.onRocketDoubleTapped?.call(context);
            }
          },
          onLongPress: () {
            if (!isOpened && widget.onTapAllowed) {
              widget.instance.onRocketLongPressed?.call(context);
            }
          },
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isOpened ? Colors.red : Colors.lightBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isOpened ? Icons.close : Icons.terminal,
              size: 28,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
