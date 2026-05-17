import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:simple_note_app/main.dart';
import 'package:simple_note_app/providers/note_provider.dart';
import 'package:simple_note_app/providers/theme_provider.dart';

void main() {
  group('Simple Note App Widget Tests', () {

    // =========================
    // APP LOAD TEST
    // =========================

    testWidgets(
      'App loads successfully',
          (WidgetTester tester) async {

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => NoteProvider(),
              ),

              ChangeNotifierProvider(
                create: (_) => ThemeProvider(),
              ),
            ],
            child: const MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        // Verify app title
        expect(
          find.text('Simple Note App'),
          findsOneWidget,
        );

        // Verify add button exists
        expect(
          find.byIcon(Icons.add),
          findsOneWidget,
        );
      },
    );

    // =========================
    // OPEN NOTE EDITOR TEST
    // =========================

    testWidgets(
      'Open note editor screen',
          (WidgetTester tester) async {

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => NoteProvider(),
              ),

              ChangeNotifierProvider(
                create: (_) => ThemeProvider(),
              ),
            ],
            child: const MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        // Tap floating action button
        await tester.tap(
          find.byIcon(Icons.add),
        );

        await tester.pumpAndSettle();

        // Verify editor screen opens
        expect(
          find.text('New Note'),
          findsOneWidget,
        );

        // Verify input fields
        expect(
          find.text('Title'),
          findsOneWidget,
        );

        expect(
          find.text('Write your note here...'),
          findsOneWidget,
        );
      },
    );

    // =========================
    // THEME TOGGLE TEST
    // =========================

    testWidgets(
      'Toggle dark/light theme',
          (WidgetTester tester) async {

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => NoteProvider(),
              ),

              ChangeNotifierProvider(
                create: (_) => ThemeProvider(),
              ),
            ],
            child: const MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        // Find theme button
        final themeButton = find.byIcon(
          Icons.light_mode,
        );

        // Verify exists
        expect(themeButton, findsOneWidget);

        // Tap theme toggle
        await tester.tap(themeButton);

        await tester.pumpAndSettle();
      },
    );

    // =========================
    // SEARCH FIELD TEST
    // =========================

    testWidgets(
      'Search field exists',
          (WidgetTester tester) async {

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => NoteProvider(),
              ),

              ChangeNotifierProvider(
                create: (_) => ThemeProvider(),
              ),
            ],
            child: const MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Search notes...'),
          findsOneWidget,
        );
      },
    );
  });
}