import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/views/logarte_dashboard_screen.dart';

class LogarteAuthScreen extends StatefulWidget {
  const LogarteAuthScreen({super.key});

  @override
  State<LogarteAuthScreen> createState() => _LogarteAuthScreenState();
}

class _LogarteAuthScreenState extends State<LogarteAuthScreen> {
  static bool _isLoggedIn = false;

  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();

    if (_isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
      body: Center(
        child: TextField(
          controller: _controller,
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          if (Logarte.password == _controller.text) {
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
        builder: (_) => const LogarteDashboardScreen(),
      ),
    );

    _isLoggedIn = true;
  }
}
