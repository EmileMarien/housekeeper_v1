


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housekeeper_v1/features/authentication/screens/LoginScreen.dart';
import 'package:housekeeper_v1/features/authentication/screens/RegistrationScreen.dart';

void main() {
  group('LoginScreen Widget Tests', () {

    testWidgets('Invalid Password Test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(),
        ),
      );

      // Verify that the password validation works as expected

      // Enter an invalid password (less than 8 characters)
      await tester.enterText(find.byKey(const Key('passwordField')), 'short');

      // Trigger a form validation
      await tester.pump();

      // Expect an error message since the password is invalid
      expect(find.text('Password must be at least 8 characters in length'),
          findsOneWidget);
    });


    testWidgets('Add and remove a todo', (tester) async {
      // Build the widget.
      await tester.pumpWidget(const MaterialApp(
        home: RegistrationScreen(),
      ));

      // Enter 'hi' into the TextField.
      await tester.enterText(find.byType(TextField), 'hi');

      // Tap the add button.
      await tester.tap(find.byType(FloatingActionButton));
      // Rebuild the widget with the new item.
      await tester.pump();

      // Expect to find the item on screen.
      expect(find.text('hi'), findsOneWidget);

      // Swipe the item to dismiss it.
      await tester.drag(find.byType(Dismissible), const Offset(500, 0));

      // Build the widget until the dismiss animation ends.
      await tester.pumpAndSettle();

      // Ensure that the item is no longer on screen.
      expect(find.text('hi'), findsNothing);
    });
  });
}
