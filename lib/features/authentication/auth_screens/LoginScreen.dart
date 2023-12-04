import 'package:housekeeper_v1/commons.dart';

import '../auth_controllers/LoginController.dart';

class LoginScreen extends StatefulWidget {
  final Function? toggleView;
  LoginScreen({this.toggleView});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  final LoginController _controller = LoginController();

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    var _obscureText=_controller.obscureText;

    void navigateToHome(){
      Navigator.pushNamed(context, '/home');
    }
    final emailField = TextFormField(
      controller: _controller.emailController,
      autofocus: false,
      validator: (value) {
        if (value != null) {
          if (value.contains('@') && value.endsWith('.com')) {
            _controller.checkIfEmailExists().then((emailExists) {
              if (emailExists) {
                // Email exists
                return null; // Email exists
              } else {
                return 'Email not registered yet';
              }
            });
          } else {
            return 'Enter a Valid Email Address';
          }
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordField = TextFormField(
        obscureText: _obscureText,
        controller: _controller.passwordController,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          if (value.trim().length < 8) {
            return 'Password must be at least 8 characters in length';
          }
          // Return null if the entered password is valid
          return null;
        },
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
        onPressed: () {
          widget.toggleView!();
        },
        child: const Text('New? Register here'));

    final loginGoogleButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          dynamic result = await _controller.loginGoogle();
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
            navigateToHome();
          }

        },
        child: Text(
          "Log in with Google",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,

        ),
      ),
    );


    final loginEmailPasswordButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
            User? result = await _controller.loginEmailPassword();
            if (result == null) { //null means unsuccessfull authentication
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('Registration failed'),
                    );
                  });
            } else {
              appState.setCurrentUserId(result.referenceId!);
              Navigator.pushNamed(context, '/home');
            }
          },
        child: Text(
          "Log in",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _controller.formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  loginGoogleButon,
                  const SizedBox(height: 45.0),
                  emailField,
                  const SizedBox(height: 25.0),
                  passwordField,
                  txtbutton,
                  const SizedBox(height: 35.0),
                  loginEmailPasswordButon,
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}