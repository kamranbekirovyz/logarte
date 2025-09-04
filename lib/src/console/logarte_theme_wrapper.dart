import 'package:flutter/material.dart';

class LogarteThemeWrapper extends StatelessWidget {
  final Widget child;

  const LogarteThemeWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey.shade900,
        dividerTheme: DividerThemeData(
          color: Colors.blueGrey.shade50,
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      child: child,
    );
  }
}
