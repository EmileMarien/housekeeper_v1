import 'package:housekeeper_v1/commons.dart';

import '../repositories/auth.dart';
import '../../../services/data_repository.dart';

//add right methods from LoginPage

class Login extends StatefulWidget {
  final Function? toggleView;
  Login({this.toggleView});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();



  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    User currentUser=appState.getCurrentUser();
    var repositoryUser = appState.repositoryUser;

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
    
    final emailField = TextFormField(
          controller: _email,
          autofocus: false,
          validator: (value) {
            if (value != null) {
              if (value.contains('@') && value.endsWith('.com')) {
                checkIfEmailExists().then((emailExists) {
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
        controller: _password,
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
          dynamic result = await _auth.signInWithGoogle();
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
            Navigator.pushNamed(context, '/home');
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
          if (_formKey.currentState!.validate()) {
             print('testttt');

             User result = await _auth.signInEmailPassword(User(email: _email.text,password: _password.text));
              if (result.referenceId == null) { //null means unsuccessfull authentication
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(result.code!),
                      );
                    });
          } else {
            appState.setCurrentUserId(result.referenceId!);
            Navigator.pushNamed(context, '/home');
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
/*


  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading:
          IconButton( onPressed: (){
            Navigator.pop(context);
          },icon:Icon(Icons.arrow_back_ios,size: 20,color: Colors.black,)),
        ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Column(
                  children: [
                    Text ("Login", style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 20,),
                    Text("Welcome back ! Login with your credentials",style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),),
                    SizedBox(height: 30,)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40
                  ),
                  child: Column(
                    children: [
                      makeInputLogin(label: "Email",controller: _email),
                      makeInputLogin(label: "Password",obsureText: true,controller: _password),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height:60,
                      onPressed: (){
                        // get entered email and password
                        String email = _emailController.text;
                        String password = _passwordController.text;

                        bool isValidUser = userUsers.any((user) => user.email == email && user.passw == password);
                        if (isValidUser) {
                          Navigator.pushNamed(context, '/home');
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text('Invalid email or password'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                      },
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text("Login",style: TextStyle(
                        fontWeight: FontWeight.w600,fontSize: 16,color: Colors.white
                      ),),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/newuser');
                      },
                      child: Text("Sign Up",style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                      ),),
                    ),
                  ],
                )
              ],

            ),
          ],
        ),
      ),
    );
  }
}

Widget makeInputLogin({label,obsureText = false,controller}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,style:TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.black87
      ),),
      SizedBox(height: 5,),
      TextField(
        obscureText: obsureText,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)
          ),
        ),
      ),
      SizedBox(height: 30,)

    ],
  );
}
*/