


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:housekeeper_v1/commons.dart';
import 'package:housekeeper_v1/core/states/UserState.dart';
import 'package:housekeeper_v1/features/authentication/screens/LoginScreen.dart';
import 'package:housekeeper_v1/features/authentication/screens/RegistrationScreen.dart';
import 'package:housekeeper_v1/features/authentication/states/AuthenticationState.dart';
import 'package:housekeeper_v1/features/authentication/controllers/RegistrationController.dart';

import 'mock.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:mockito/mockito.dart';

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
Widget createAuthenticationScreen() => MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context) => UserState()),
    ChangeNotifierProvider(create: (context) => UnitState()),
    ChangeNotifierProvider(create: (context) => AuthenticationState()),
  ],
  child: Builder(
    builder: (context) => MaterialApp(
      home: Authentication(),
    ),
  ),
);

class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}
class MockUserCredential extends Mock implements firebase_auth.UserCredential {}
class MockBuildContext extends Mock implements BuildContext {}
class MockAuthenticationState extends Mock implements AuthenticationState {

}
class MockUserState extends Mock implements UserState {}

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

  group('Registration and Login Page Interaction', () {

    testWidgets('Registration and Login Page Interaction', (WidgetTester tester) async {
      // Build the Login screen.
      await tester.pumpWidget(createAuthenticationScreen());
      expect(find.byType(LoginScreen), findsOneWidget);

      // Tap on the switch button.
      await tester.tap(find.byKey(Key('loginTxtButton')));
      await tester.pump();

      // Expect the Registration screen to be displayed.
      expect(find.byType(RegistrationScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);

      // Enter valid registration data.
      await tester.enterText(find.byKey(Key('registrationEmailField')), 'test@example.com');
      await tester.enterText(find.byKey(Key('registrationPasswordField')), 'password');

      // Tap on the registration button.
      await tester.tap(find.byKey(Key('registrationEmailPasswordButton')));
      await tester.pumpAndSettle();

      // Expect the Home screen to be displayed.
      //expect(find.byType(HomeScreen), findsOneWidget);

    });
  });

  group('RegistrationController Tests', () { // TODO: fix mockauthstate
    late MockFirebaseAuth mockFirebaseAuth;
    late MockBuildContext mockContext;
    late MockAuthenticationState mockAuthState;
    late MockUserState mockUserState;
    late RegistrationController controller;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      //controller = RegistrationController(mockFirebaseAuth);
      mockContext = MockBuildContext();
      mockAuthState = MockAuthenticationState();
      mockUserState = MockUserState();

      // Set up the behavior of registerEmailPassword on mockAuthState
      when(mockAuthState.registerEmailPassword(User(email: 'test@example.com', password: 'password')))
          .thenReturn(User(referenceId: '123', email: 'test@example.com') as Future<User>);

      controller = RegistrationController(mockContext, authState: mockAuthState, userState: mockUserState);
    });

    test('toggleObscureText', () {
      // Initial state
      expect(controller.obscureText, true);

      // Toggle the obscure text
      controller.toggleObscureText();

      // Expect the obscure text to be toggled
      expect(controller.obscureText, false);
    });

    test('register - Successful Registration', () async {

      // Act
      final result = await controller.register('test@example.com', 'password');

      // Assert
      expect(result?.referenceId, '123');
      verify(mockUserState.addUserWithId(User(referenceId: '123'))).called(1);
      verify(mockUserState.setCurrentUserId('123')).called(1);
      //verify(mockContext.navigator.pushNamed('/home')).called(1);
    });

    test('register - Unsuccessful Registration', () async {
      // Arrange
      when(mockAuthState.registerEmailPassword(User(email: 'test@example.com',password: 'password'))).thenAnswer((_) async => User(referenceId: null, email: 'test@example.com'));

      // Act
      final result = await controller.register('test@example.com', 'password');

      // Assert
      expect(result?.referenceId, null);
      verifyNever(mockUserState.addUserWithId(User(email: result?.email,referenceId: result?.referenceId)));
      //verifyNever(mockUserState.setCurrentUserId(result.referenceId));
      //verifyNever(mockContext.navigator.pushNamed(any));
    });

  });
}
