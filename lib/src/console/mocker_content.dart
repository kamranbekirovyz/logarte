import 'package:flutter/material.dart';
import 'package:logarte/src/console/mocker_key_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockerContent extends StatefulWidget {
  const MockerContent({super.key});

  @override
  State<MockerContent> createState() => _MockerContentState();
}

class _MockerContentState extends State<MockerContent> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final keys = snapshot.data!.getKeys();
        final preferences = snapshot.data!;
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 52,
              horizontal: 16,
            ),
            child: ElevatedButton(
              onPressed: () {
                _navigationToDetails(context, null);
              },
              child: const Text('Add'),
            ),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  ...keys.map((e) {
                    return InkWell(
                      onTap: () {
                        _navigationToDetails(context, e);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(e),
                            ),
                            const Icon(Icons.chevron_right)
                          ],
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigationToDetails(BuildContext context, String? key) async {
    final shouldReload = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MockerKeyDetailScreen(
          mockKey: key,
        ),
      ),
    );
    if (shouldReload == true) {
      setState(() {});
    }
  }
}
