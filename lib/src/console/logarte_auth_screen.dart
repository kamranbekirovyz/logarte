import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/logarte_dashboard_screen.dart';

T? ambiguate<T>(T? value) => value;

class LogarteAuthScreen extends StatefulWidget {
  final Logarte instance;

  const LogarteAuthScreen(
    this.instance, {
    Key? key,
  }) : super(key: key);

  @override
  State<LogarteAuthScreen> createState() => _LogarteAuthScreenState();
}

class _LogarteAuthScreenState extends State<LogarteAuthScreen> {
  static bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();

    if (_isLoggedIn) {
      ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) {
        _goToDashboard();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logarte Magical Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: TextField(
          autofocus: true,
          controller: _controller,
          decoration: const InputDecoration(
            filled: true,
            labelText: 'Password',
            contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            border: UnderlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          if (widget.instance.consolePassword == _controller.text) {
            _goToDashboard();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Wrong password'),
              ),
            );
          }
        },
        child: const Icon(Icons.login),
      ),
    );
  }

  void _goToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LogarteDashboardScreen(widget.instance),
      ),
    );

    _isLoggedIn = true;
  }
}
