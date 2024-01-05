import 'package:housekeeper_v1/commons.dart';

import '../repositories/auth.dart';
import '../states/AuthenticationState.dart';

class LoginController {
  final BuildContext context;
  final AuthenticationState authState;
  final UserState userState;

  LoginController(this.context) : authState = AuthenticationState(), userState = Provider.of<UserState>(context);


  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  Future<bool> checkIfEmailExists(String text) async {
    bool emailExists = await userState.checkIfEmailExists(text);
    return emailExists;
  }

  void navigateToHome(){
    Navigator.pushNamed(context, '/home');
  }

  Future<User?> loginEmailPassword(email,password) async {
    User result = await authState.signInEmailPassword(
      User(email: email, password: passwordController.text),
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

  Future<User?> loginGoogle() async {
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


}




