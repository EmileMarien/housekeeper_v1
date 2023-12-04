import 'package:housekeeper_v1/commons.dart';

import '../repositories/auth.dart';

class LoginController {
  final BuildContext context;
  LoginController(this.context);
  final AuthService _auth = AuthService();

  bool _obscureText = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); //TODO: what does this do?

  bool get obscureText => _obscureText;

  void toggleObscureText() {
    _obscureText = !_obscureText;
  }

  Future<bool> checkIfEmailExists() async {
    Stream<List<User>> accountsStream = repositoryUser.getUsersStream();

    bool emailExists = false;
    await accountsStream.first.then((accountsList) {
      print("test2");
      for (User account in accountsList) {
        if (account.getEmail() == _email.text) {
          emailExists = true;
          break;
        }
      }
    });

    return emailExists;
  }

  Future<User?> loginEmailPassword() async {
    if (formKey.currentState!.validate()) {
      User result = await _auth.signInEmailPassword(
        User(email: emailController.text, password: passwordController.text),
      );

      if (result.referenceId == null) {
        // Unsuccessful authentication
        return null;
      } else {
        // Successful registration
        return result;

      }
    }
  }
  Future<User?> loginGoogle() async {
    if (formKey.currentState!.validate()) {
      User result = await _auth.signInEmailPassword(
        User(email: emailController.text, password: passwordController.text),
      );

      if (result.referenceId == null) {
        // Unsuccessful authentication
        return null;
      } else {
        // Successful registration
        return result;

      }
    }
  }
}




