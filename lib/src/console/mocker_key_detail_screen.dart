import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockerKeyDetailScreen extends StatefulWidget {
  final String? mockKey;

  const MockerKeyDetailScreen({
    super.key,
    required this.mockKey,
  });

  @override
  State<MockerKeyDetailScreen> createState() => _MockerKeyDetailScreenState();
}

class _MockerKeyDetailScreenState extends State<MockerKeyDetailScreen> {
  final TextEditingController _keyController = TextEditingController();

  final TextEditingController _valueController = TextEditingController();

  late SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _keyController.text = widget.mockKey ?? 'Key';
    _valueController.text =
        _sharedPreferences.getString(widget.mockKey ?? 'Value') ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mockKey ?? 'Add'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 52,
          horizontal: 16,
        ),
        child: ElevatedButton(
          onPressed: () {
            if (_keyController.text.trim().isEmpty ||
                _valueController.text.trim().isEmpty) {
              return;
            }
            _sharedPreferences.setString(
                _keyController.text, _valueController.text);
            Navigator.of(context).pop(true);
          },
          child: const Text('Save'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _keyController,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: _valueController,
            ),
          ],
        ),
      ),
    );
  }
}
