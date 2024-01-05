import 'package:housekeeper_v1/commons.dart';
import 'package:housekeeper_v1/features/authentication/states/AuthenticationState.dart';

import '../controllers/LoginController.dart';

class LoginScreen extends StatefulWidget {
  final Function? toggleView;
  const LoginScreen({super.key, this.toggleView});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController(); //Don't put in build because then it will be reinitialized every time build is called
  final TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;


  bool _isInvalidAsyncUser = false; // managed after response from server
  bool _isInvalidAsyncPass = false; // managed after response from server

  @override
  Widget build(BuildContext context) {
    LoginController controller = LoginController(context);
    _loginFormKey.currentState!.validate(); //validate form on build to process async results

    // validate user name
    String? _validateUserName(String? userName) {
      if (userName == null || userName.trim().isEmpty) {
        return 'Email cannot be empty';
      }

      if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(userName)) {
        return 'Enter a Valid Email Address';
      }

      return _isInvalidAsyncUser ? 'Email not registered yet' : null;
    }

    // validate password
    String? _validatePassword(String? password) {
      if (password == null || password.trim().isEmpty) {
        return 'Password cannot be empty';
      }

      if (password.length < 8) {
        return 'Password must be at least 8 characters';
      }

      return _isInvalidAsyncPass ? 'Incorrect password' : null;
    }

    Future<void> _submit() async {
      if (_loginFormKey.currentState!.validate()) {
        _loginFormKey.currentState!.save();

        // dismiss keyboard during async call
        FocusScope.of(context).requestFocus(new FocusNode());

        setState(() async {
          if (await controller.checkIfEmailExists(emailController.text)) {
            _isInvalidAsyncUser = false;
            User? result = await controller.loginEmailPassword(
                emailController.text, passwordController.text);
            if (result != null) {
              // username and password are correct
              _isInvalidAsyncPass = false;
            } else
              // username is correct, but password is incorrect
              _isInvalidAsyncPass = true;
          } else {
            // incorrect username and have not checked password result
            _isInvalidAsyncUser = true;
            // no such user, so no need to trigger async password validator
            _isInvalidAsyncPass = false;
          }
          // stop the modal progress HUD
        });
      }
    }

    final emailField = TextFormField(
      key: Key('loginEmailField'),
      controller: emailController,
      autofocus: false,
      validator: _validateUserName,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordField = TextFormField(
        key: Key('loginPasswordField'),
        obscureText: _obscureText,
        controller: passwordController,
        autofocus: false,
        validator: _validatePassword,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            suffixIcon: IconButton(
              icon:
              Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            )));

    final txtbutton = TextButton(
        key: const Key('loginTxtButton'),
        onPressed: () {
          widget.toggleView!();
        },
        child: const Text('New? Register here'));

    final loginGoogleButon = Material(
      key: const Key('loginGoogleButon'),
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme
          .of(context)
          .primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          dynamic result = await controller.loginGoogle();
          if (result == null) {
            // Google Sign-In canceled or failed
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text("Google Sign-In Failed."),
                );
              },
            );
          } else {
            print('went through');
            controller.navigateToHome();
          }
        },
        child: Text(
          "Log in with Google",
          style: TextStyle(color: Theme
              .of(context)
              .primaryColorLight),
          textAlign: TextAlign.center,

        ),
      ),
    );


    final loginEmailPasswordButon = Material(
      key: const Key('loginEmailPasswordButton'),
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme
          .of(context)
          .primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _submit,
        child: Text(
          "Log in",
          style: TextStyle(color: Theme
              .of(context)
              .primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    Widget buildLoginForm(BuildContext context) {
      final TextTheme textTheme = Theme
          .of(context)
          .textTheme;
      // run the validators on reload to process async results
      _loginFormKey.currentState?.validate();
      return Form(
        key: this._loginFormKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: emailField,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: passwordField,
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: txtbutton,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: loginEmailPasswordButon,
            ),
          ],
        ),
      );
    }


    return Consumer3<UserState, UnitState, AuthenticationState>(
      builder: (context, userState, unitState, authState, child) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            body: buildLoginForm(context)
        );
      },
    );
  }
}