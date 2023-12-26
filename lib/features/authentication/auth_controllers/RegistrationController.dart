import 'package:housekeeper_v1/commons.dart';

import '../repositories/auth.dart';

class RegistrationController {
  final BuildContext context;
  final AuthService _auth;
  final AppState appState;

  RegistrationController(this.context) : _auth = AuthService(), appState = Provider.of<AppState>(context);

  bool _obscureText = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool get obscureText => _obscureText;


  void navigateToHome(){
    Navigator.pushNamed(context, '/home');
  }


  void toggleObscureText() {
    _obscureText = !_obscureText;
  }

  Future<User?> register() async {
    if (formKey.currentState!.validate()) {
      User result = await _auth.registerEmailPassword(
        User(email: emailController.text, password: passwordController.text),
      );

      if (result.referenceId == null) {
        // Unsuccessful authentication

      } else {
        print('test');

        User newUser = User(
          email: result.email,
          referenceId: result.referenceId,); //do not provide password, keep this in authentication and out of database for security

        appState.addUserWithId(newUser);
        appState.setCurrentUserId(result.referenceId!);
        navigateToHome();
      }
    }
  }

}
