import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:read/main.dart';

void main() {
  group("testing book screen", () {
    testWidgets("start app", (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(ListTile), findsNothing);
    });
    testWidgets("create new book", (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(find.byType(TextFormField), findsNWidgets(2));
      await tester.enterText(
          find.byType(TextFormField).first, "book testing text");
      expect(find.text("book testing text"), findsOneWidget);
      await tester.tap(find.text("OK"));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    testWidgets("create new book", (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(find.byType(TextFormField), findsNWidgets(2));
      await tester.tap(find.text("OK"));
      await tester.pump();
      expect(find.text("Title should not be empty!"), findsOneWidget);
    });
    testWidgets("search", (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();
      expect(find.byType(ListTile), findsOneWidget);
      await tester.enterText(find.byType(TextField), "book");
      expect(find.text("book"), findsOneWidget);
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pump();
      expect(find.byType(ListTile), findsNothing);
    });
  });
}
