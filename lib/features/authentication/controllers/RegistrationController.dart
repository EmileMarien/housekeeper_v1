import 'package:housekeeper_v1/commons.dart';

import '../states/AuthenticationState.dart';

class RegistrationController {
  final BuildContext context;
  final AuthenticationState authState;
  final UserState userState;

  RegistrationController(this.context, {UserState? userState,AuthenticationState? authState})
      : authState = authState ?? AuthenticationState(),
        userState = userState ?? Provider.of<UserState>(context);

  bool _obscureText = true;

  bool get obscureText => _obscureText;

  void navigateToHome(){
    Navigator.pushNamed(context, '/home');
  }


  void toggleObscureText() {
    _obscureText = !_obscureText;
  }

  Future<User?> register(email,password) async {
    User result = await authState.registerEmailPassword(
      User(email: email, password: password),
    );

    if (result.referenceId == null) {
      // Unsuccessful authentication
    } else {

      User newUser = User(
        email: result.email,
        referenceId: result.referenceId,); //do not provide password, keep this in authentication and out of database for security

      userState.addUserWithId(newUser);
      userState.setCurrentUserId(result.referenceId!);
      navigateToHome();
      return result;
    }
  }
}
