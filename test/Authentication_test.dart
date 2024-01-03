


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housekeeper_v1/commons.dart';
import 'package:housekeeper_v1/core/states/UserState.dart';
import 'package:housekeeper_v1/features/authentication/screens/LoginScreen.dart';
import 'package:housekeeper_v1/features/authentication/screens/RegistrationScreen.dart';
import 'package:housekeeper_v1/features/authentication/states/AuthenticationState.dart';

import 'mock.dart';

Widget createLoginScreen() => MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context) => UserState()),
    ChangeNotifierProvider(create: (context) => UnitState()),
    ChangeNotifierProvider(create: (context) => AuthenticationState()),
  ],
    child: Builder(
    builder: (context) => MaterialApp(
      home: LoginScreen(),
    ),
  ),
);

Widget createRegistrationScreen() => MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context) => UserState()),
    ChangeNotifierProvider(create: (context) => UnitState()),
    ChangeNotifierProvider(create: (context) => AuthenticationState()),
  ],
  child: Builder(
    builder: (context) => MaterialApp(
      home: RegistrationScreen(),
    ),
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); //Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('LoginScreen Widget Tests', () {

    testWidgets('initialscreen Test', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('Email Field Test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(createLoginScreen());

      // Verify that the email field is initially empty
      expect(find.text(''), findsNWidgets(2));

      // Enter 'hi' into the TextField.
      await tester.enterText(find.byKey(const Key('loginEmailField')), 'hi');

      // Verify that the email field is no longer empty
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('Invalid Password Test', (WidgetTester tester) async {
      // Build our app and trigger a frame.

      await tester.pumpWidget(createLoginScreen());

      // Verify that the password validation works as expected

      // Enter an invalid password (less than 8 characters)
      await tester.enterText(
          find.byKey(const Key('loginPasswordField')), 'short');

      // Trigger a form validation
      await tester.pump();
      await tester.tap(find.byKey(const Key('loginEmailPasswordButton')));

      // Trigger validation
      await tester.pump();

      // Expect an error message since the password is invalid
      expect(find.text('Password must be at least 8 characters in length'),findsOneWidget);
    });

  });

  group('RegistrationScreen Widget Tests', () {

    testWidgets('initialscreen Test', (WidgetTester tester) async {
      await tester.pumpWidget(createRegistrationScreen());
      expect(find.byType(RegistrationScreen), findsOneWidget);
    });

    testWidgets('Email Field Test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(createRegistrationScreen());

      // Verify that the email field is initially empty
      expect(find.text(''), findsNWidgets(2));

      // Enter 'hi' into the TextField.
      await tester.enterText(find.byKey(const Key('registrationEmailField')), 'hi');

      // Verify that the email field is no longer empty
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('Invalid Password Test', (WidgetTester tester) async {
      // Build our app and trigger a frame.

      await tester.pumpWidget(createRegistrationScreen());

      // Verify that the password validation works as expected

      // Enter an invalid password (less than 8 characters)
      await tester.enterText(
          find.byKey(const Key('registrationPasswordField')), 'short');

      // Trigger a form validation
      await tester.pump();
      await tester.tap(find.byKey(const Key('registrationEmailPasswordButton')));

      // Trigger validation
      await tester.pump();

      // Expect an error message since the password is invalid
      expect(find.text('Password must be at least 8 characters in length'),findsOneWidget);
    });

  });

  group('Registration and login page interaction' , () {

    testWidgets('Registration and login page interaction', (WidgetTester tester) async {
      await tester.pumpWidget(createRegistrationScreen());
      expect(find.byType(RegistrationScreen), findsOneWidget);

      await tester.tap(find.byKey(const Key('registrationTxtButton')));
      await tester.pumpAndSettle();
      expect(find.text('This field is required'), findsNWidgets(2));

      await tester.enterText(find.byKey(const Key('registrationEmailField'));
    });
  });
}
/*



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
 */