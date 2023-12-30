import 'package:housekeeper_v1/commons.dart';

import '../repositories/auth.dart';
import '../states/AuthenticationState.dart';

class LoginController {
  final BuildContext context;
  final AuthenticationState authState;
  final UserState userState;
  final GlobalKey<FormState> formKey; //TODO: what does this do?

  LoginController(this.context, this.formKey) : authState = AuthenticationState(), userState = Provider.of<UserState>(context);

  //final repositoryUser = appState.repositoryUser;

  bool _obscureText = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();



  bool get obscureText => _obscureText;

  void toggleObscureText() {
    _obscureText = !_obscureText;
  }

  bool checkIfEmailExists() {
    return userState.checkIfEmailExists(emailController.text);
  }

 /* Future<bool> checkIfEmailExists() async {
    Stream<List<User>> accountsStream = userState.repositoryUser.getUsersStream();

    bool emailExists = false;
    await accountsStream.first.then((accountsList) {
      print("test2");
      for (User account in accountsList) {
        if (account.getEmail() == emailController.text) {
          emailExists = true;
          break;
        }
      }
    });

    return emailExists;
  }
*/

  void navigateToHome(){
    Navigator.pushNamed(context, '/home');
  }

  Future<User?> loginEmailPassword() async {
    if (formKey.currentState!.validate()) {
      User result = await authState.signInEmailPassword(
        User(email: emailController.text, password: passwordController.text),
      );

      if (result.referenceId == null) {
        // Unsuccessful authentication
        return null;
      } else {
        userState.setCurrentUserId(result.referenceId!);
        navigateToHome();
        // Successful registration
        return result;
      }
    }
  }
  Future<User?> loginGoogle() async {
    if (formKey.currentState!.validate()) {
      User result = await authState.signInEmailPassword(
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




