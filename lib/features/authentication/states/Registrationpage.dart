import 'package:housekeeper_v1/commons.dart';

import '../repositories/auth.dart';

class Register extends StatefulWidget{
  /// Registers a user
  final Function? toggleView;
   Register({this.toggleView});

   @override
  State<StatefulWidget> createState() {
    return _Register();
  }
}

class _Register extends State<Register>{
  final AuthService _auth = AuthService();

  bool _obscureText = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);

    void navigateToHome(){
      Navigator.pushNamed(context, '/home');
    }

    final emailField = TextFormField(
        controller: _email,
        autofocus: false,
        validator: (value) {
          if (value != null) {
            if (value.contains('@') && value.endsWith('.com')) {
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
        } ,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
             suffixIcon: IconButton(icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: (){
              setState(() {
                _obscureText = !_obscureText;
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
              User result = await _auth.registerEmailPassword(User(email: _email.text,password: _password.text));
               if (result.referenceId == null) { //null means unsuccessfull authentication
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(result.code!),
                    );
                  },
                );
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
          autovalidateMode: AutovalidateMode.always,
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

/*
class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    List<User> persons  = appState.accounts;
    User newPerson = Person();
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: Column(
        children: [
          Builder(
            builder: (context) => Material(
              child: Column(
              children:  [
                TextField(
                  onChanged: (usernameInput) {
                    setState(() {
                      newPerson.setName(usernameInput);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter username',
                ),
              ),
              TextField( // TODO only add unit after creation of account
                  onChanged: (passwordInput) {
                    setState(() {
                      newPerson.setPassWord(passwordInput);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter password' 
                  ),
                ),
              ],
            ),
          ),
          ),

            
          
          ElevatedButton(
            onPressed: () {
              appState.addPerson(newPerson);
              Navigator.pop(context); // Return to the previous page
            },
            child: Text('Register'),
          ),
        ],
      ),
    );
    
  }
}
*/
/*
class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Define the form key
  bool _showErrors = false;

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    return Scaffold(
      // ... Rest of the code ...
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            makeInputRegister(
              label: "Username",
              controller: _usernameController,
              validate: (value) {
                if (value.isEmpty) {
                  return 'Username is required';
                }
                if (appState.accounts.any((account) => account.username == value)) {
                  return 'Username already exists';
                }
                return null;
              },
              showError: _showErrors,
            ),
            makeInputRegister(
              label: "Email",
              controller: _emailController,
              validate: (value) {
                if (value.isEmpty) {
                  return 'Email is required';
                }
                if (appState.accounts.any((account) => account.email == value)) {
                  return 'Email already exists';
                }
                return null;
              },
              showError: _showErrors,
            ),
            makeInputRegister(
              label: "Password",
              controller: _passwordController,
              obscureText: true,
              validate: (value) {
                if (value.isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
              showError: _showErrors,
            ),
            makeInputRegister(
              label: "Confirm Password",
              controller: _confirmPasswordController,
              obscureText: true,
              validate: (value) {
                if (value.isEmpty) {
                  return 'Confirm password is required';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              showError: _showErrors,
            ),
            SizedBox(height: 20),
            MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () {
                setState(() {
                  _showErrors = true;
                });
                if (_formKey.currentState?.validate() ?? false) {
                  // All validation checks pass, add the new account to appState.accounts
                  String username = _usernameController.text;
                  String email = _emailController.text;
                  String password = _passwordController.text;

                  User newUser =
                      User(username: username, email: email, password: password);
                  appState.addUser(newUser);
                  appState.setCurrentUser(newUser);

                  Navigator.pushNamed(context, '/home');
                }
              },
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      // ... Rest of the code ...
    );
  }
}

Widget makeInputRegister({label, obscureText = false, controller, validate, showError}) {
  final errorText = showError ? validate(controller.text) : null;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 5),
      TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
      SizedBox(height: 5),
      // Show the error message if showError is true
      if (showError && errorText != null)
        Text(
          errorText,
          style: TextStyle(color: Colors.red),
        ),
      SizedBox(height: 30),
    ],
  );
}

*/

/*
class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Define the form key
  bool _showErrors = false;

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text ("Sign up", style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height: 20,),
                        Text("Create an User, Its free",style: TextStyle(
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
                          Form(key: _formKey, 
                          child:Column(
                            children: [
                              makeInputRegister(label: "Username", controller: _usernameController, validate: (value) {
                                if (value.isEmpty) {
                                  return 'Username is required';
                                }
                                if (appState.accounts.any((account) => account.username == value)) {
                                  return 'Username already exists';
                                }
                                return null;
                                },showError: _showErrors,
                                ),
                              makeInputRegister(label: "Email", controller: _emailController, validate: (value) {
                                if (value.isEmpty) {
                                  return 'Email is required';
                                }
                                if (appState.accounts.any((account) => account.email == value)) {
                                  return 'Email already exists';
                                }
                                return null;
                                },showError: _showErrors,
                                ),
                              makeInputRegister(label: "Password", controller: _passwordController, obscureText: true, validate: (value) {
                                if (value.isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                                },showError: _showErrors,
                                ),
                              makeInputRegister(label: "Confirm Password", controller: _confirmPasswordController, obscureText: true, validate: (value) {
                                if (value.isEmpty) {
                                  return 'Confirm password is required';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                                },showError: _showErrors,
                                ),
                            ],
                          ),
                          ),
                            
                          SizedBox(height: 20),
                          MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () {
                            setState(() {
                              _showErrors = true;
                            });
                            if (_formKey.currentState?.validate() ?? false) {
                              print("test");
                              // All validation checks pass, add the new account to appState.accounts
                              String username = _usernameController.text;
                              String email = _emailController.text;
                              String password = _passwordController.text;
                              User newUser = User(username: username, email: email, password: password);
                              appState.addUser(newUser);
                              appState.setCurrentUser(newUser);

                              Navigator.pushNamed(context, '/home');
                            }
                            else {
                              print("false");
                            }
                          },
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text("Sign Up",style: TextStyle(
                            fontWeight: FontWeight.w600,fontSize: 16,

                          ),),
                        ),
                        ]
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? "),
                        Text("Login",style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
                      ],
                    )
                  ],

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


Widget makeInputRegister({label, obscureText = false, controller, validate, showError}) {
  final errorText = showError ? validate(controller.text) : null;
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 5),
      TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
SizedBox(height: 5),
      // Show the error message if showError is true
      if (showError && errorText != null)
        Text(
          errorText,
          style: TextStyle(color: Colors.red),
        ),
      SizedBox(height: 30),
    ],
  );
}



*/
