import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/logarte_dashboard_screen.dart';
import 'package:logarte/src/console/logarte_theme_wrapper.dart';

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
  bool get _noPassword => widget.instance.consolePassword == null;

  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LogarteThemeWrapper(
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: _isLoggedIn || _noPassword
            ? LogarteDashboardScreen(widget.instance)
            : Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: TextField(
                    autofocus: true,
                    controller: _controller,
                    onSubmitted: (_) => _onSubmit(),
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Password',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      border: UnderlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: FloatingActionButton.large(
                  onPressed: _onSubmit,
                  child: const Icon(Icons.login),
                ),
              ),
      ),
    );
  }

  void _onSubmit() {
    if (widget.instance.consolePassword == _controller.text) {
      _goToDashboard();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong password'),
        ),
      );
    }
  }

  void _goToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LogarteDashboardScreen(widget.instance),
        settings: const RouteSettings(name: '/logarte_dashboard'),
      ),
    );

    _isLoggedIn = true;
  }
}
