import 'package:housekeeper_v1/commons.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController(); //Don't put in build because then it will be reinitialized every time build is called
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    LoginController controller = LoginController(context);

    final emailField = TextFormField(
      controller: emailController,
      autofocus: false,
      validator: (value) {
        if (value != null) {
          if (value.contains('@') && value.endsWith('.com')) {
              if (controller.checkIfEmailExists(emailController.text)) {
                // Email exists
                return null; // Email exists
              } else {
                return 'Email not registered yet';
              }
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
        obscureText: controller.obscureText,
        controller: passwordController,
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
              Icon(controller.obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  controller.toggleObscureText();
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            )));

    final txtbutton = TextButton(
        key: const Key('txtbutton'),
        onPressed: () {
          widget.toggleView!();
        },
        child: const Text('New? Register here'));

    final loginGoogleButon = Material(
      key: const Key('loginGoogleButon'),
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
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
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,

        ),
      ),
    );


    final loginEmailPasswordButon = Material(
      key: const Key('loginEmailPasswordButon'),
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            User? result = await controller.loginEmailPassword(emailController.text, passwordController.text);
            if (result == null) { //null means unsuccessfull authentication
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('Registration failed'),
                  );
                },
              );
            }
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
            key: _formKey,
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