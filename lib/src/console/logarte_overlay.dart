import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/logarte_auth_screen.dart';

class LogarteOverlay extends StatelessWidget {
  final Logarte instance;

  const LogarteOverlay._internal({
    required this.instance,
    Key? key,
  }) : super(key: key);

  static void attach({
    required BuildContext context,
    required Logarte instance,
  }) {
    final entry = OverlayEntry(
      builder: (context) => LogarteOverlay._internal(
        instance: instance,
      ),
    );

    Future.delayed(kThemeAnimationDuration, () {
      final overlay = Overlay.of(context);

      overlay.insert(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = (MediaQuery.of(context).size.height / 2) - 12.0;

    return Positioned(
      right: 0.0,
      bottom: height,
      child: _LogarteFAB(
        instance: instance,
      ),
    );
  }
}

class _LogarteFAB extends StatefulWidget {
  final Logarte instance;

  const _LogarteFAB({
    Key? key,
    required this.instance,
  }) : super(key: key);

  @override
  _LogarteFABState createState() => _LogarteFABState();
}

class _LogarteFABState extends State<_LogarteFAB> {
  bool _isOpened = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _onPressed() async {
    if (_isOpened) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => LogarteAuthScreen(widget.instance),
          settings: const RouteSettings(name: '/logarte_auth'),
        ),
      );
    }

    setState(() => _isOpened = !_isOpened);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.blueGrey.shade900,
      onPressed: _onPressed,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
        ),
      ),
      child: Icon(
        _isOpened ? Icons.close : Icons.rocket_launch,
        color: Colors.white,
      ),
    );
  }
}
