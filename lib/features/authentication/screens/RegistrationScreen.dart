import 'package:housekeeper_v1/commons.dart';

import '../controllers/RegistrationController.dart';

class RegistrationScreen extends StatefulWidget {
  final Function? toggleView;
  const RegistrationScreen({super.key, this.toggleView});

  @override
  State<StatefulWidget> createState() {
    return _RegistrationScreen();
  }
}

class _RegistrationScreen extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController(); //Don't put in build because then it will be reinitialized every time build is called
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    RegistrationController controller = RegistrationController(context);

    final emailField = TextFormField(
      controller: emailController,
      autofocus: false,
      validator: (value) {
        if (value != null) {
          if (value != null && RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value)) {
            return null;
          }
          return 'Enter a Valid Email Address';
        }
      },
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

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
      } ,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          suffixIcon: IconButton(icon: Icon(controller.obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: (){
              setState(() {
                controller.toggleObscureText();
              });
            },),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final txtbutton = TextButton(
        onPressed: () {
          widget.toggleView!();
        },
        child: const Text('Go to login'));

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            User? result = await controller.register(emailController.text, passwordController.text);
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
          "Register",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Registration Demo Page'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 45.0),
                  emailField,
                  const SizedBox(height: 25.0),
                  passwordField,
                  const SizedBox(height: 25.0),
                  txtbutton,
                  const SizedBox( height: 35.0),
                  registerButton,
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