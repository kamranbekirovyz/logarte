import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/network_log_entry_details_screen.dart';

void main() {
  testWidgets(
    'highlights request and response headers and bodies',
    (WidgetTester tester) async {
      final entry = NetworkLogarteEntry(
        request: const NetworkRequestLogarteEntry(
          url: 'https://example.com/graphql',
          method: 'POST',
          headers: {
            'content-type': 'application/json',
          },
          body: {
            'query': 'query Viewer { viewer { id } }',
          },
        ),
        response: NetworkResponseLogarteEntry(
          statusCode: 200,
          headers: const {
            'content-type': 'application/json',
          },
          body: const {
            'data': {
              'viewer': {
                'id': '1',
              },
            },
          },
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: NetworkLogEntryDetailsScreen(
            entry,
            instance: Logarte(),
          ),
        ),
      );

      expect(_highlightedSources(tester), [
        contains('"content-type": "application/json"'),
        contains('query Viewer'),
      ]);

      await tester.tap(find.text('Response'));
      await tester.pumpAndSettle();

      expect(_highlightedSources(tester), [
        contains('"content-type": "application/json"'),
        contains('"viewer"'),
      ]);
    },
  );

  testWidgets(
    'renders null and non-json payloads without crashing',
    (WidgetTester tester) async {
      final entry = NetworkLogarteEntry(
        request: const NetworkRequestLogarteEntry(
          url: 'wss://example.com/socket',
          method: 'POST',
          headers: {},
          body: 'connected',
        ),
        response: NetworkResponseLogarteEntry(
          statusCode: null,
          headers: null,
          body: null,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: NetworkLogEntryDetailsScreen(
            entry,
            instance: Logarte(),
          ),
        ),
      );

      expect(_highlightedSources(tester), [
        '{}',
        'connected',
      ]);

      await tester.tap(find.text('Response'));
      await tester.pumpAndSettle();

      expect(_highlightedSources(tester), [
        'null',
        'null',
      ]);
    },
  );
}

List<String> _highlightedSources(WidgetTester tester) {
  return tester
      .widgetList<HighlightView>(find.byType(HighlightView))
      .map((widget) => widget.source)
      .toList();
}
