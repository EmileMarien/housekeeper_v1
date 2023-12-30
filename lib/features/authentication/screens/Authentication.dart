import '../../../commons.dart';
import 'LoginScreen.dart';
import 'RegistrationScreen.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Authentication();
  }
}

class _Authentication extends State<Authentication> {
  /// Verifies if a user is authenticated already
  /// if yes: go to homepage of authenticated user
  /// else: start authentication by logging in or registering new user

  bool showSignin = true;

  void toggleView() {
    setState(() {
      showSignin = !showSignin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider
        .of<UserState>(context)
        .currentUserId;

    if (user == '') {
      if (showSignin) {
        return LoginScreen(toggleView: toggleView);
      } else {
        return RegistrationScreen(toggleView: toggleView);
      }
    } else {
      return HomeScreen();
    }
  }
}

