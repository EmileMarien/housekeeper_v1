
import 'package:housekeeper_v1/screens/settings/Settings.dart' as hk;
import 'package:housekeeper_v1/screens/wrapper.dart';
import 'package:housekeeper_v1/services/data_repository.dart';

import 'commons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/authentication/repositories/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //ensure the binding between widget layer and flutter engine is initialized
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); //initialize firebase
  runApp(MyApp());
}

//void main() {
//  runApp(const MainApp());
//}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AppState()),
          ChangeNotifierProvider(create: (context) => UnitState()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.blue[900],
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.blue[600],
              textTheme: ButtonTextTheme.primary,
              colorScheme:
                  Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
            ),
            fontFamily: 'Arial',
            textTheme: const TextTheme(
              headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              headline6: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
              bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            ),
            // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan[600]),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => Wrapper(), //Instead of loginpage
            '/home': (context) => Home(),
            '/newuser': (context) => Register(),
            '/create_unit': (context) => CreateUnitPage(),
            '/settings':(context) => hk.Settings(),
          },
        ),
      ),
    );
  }
}


class UnitState extends ChangeNotifier {
  final DataRepositoryUnit repositoryUnit = DataRepositoryUnit();
  final DataRepositoryUnitType repositoryUnitType = DataRepositoryUnitType();
  final DataRepositoryUnitRole repositoryUnitRole = DataRepositoryUnitRole();
  String currentUnitId = '';
  Unit currentUnit=Unit();
  //Unit currentUnit = Unit(name:'', type: UnitType(name: ""),rolesAndUsers: {UnitRole(name: ''):[AppState().getCurrentUser()]}); 

  Future<void> updateCurrentUnit() async {
    try {
      currentUnit = await repositoryUnit.getUnitById(currentUnitId) ?? Unit();
    } catch (e) {
      print("Error getting current user: $e");
      return null;
    }
    notifyListeners(); 
  }

  void addUnit(Unit unit) {
    repositoryUnit.addUnit(unit);
    notifyListeners();
  } 

  void addUnitType(UnitType unitType) {
    repositoryUnitType.addUnitType(unitType);
    notifyListeners();
  } 

  void addUnitRole(UnitRole unitRole) {
    repositoryUnitRole.addUnitRole(unitRole);
    notifyListeners();
  } 

  void setCurrentUnit(newUnit){
    //=newUnit;
  }
}



class AppState extends ChangeNotifier {
  final DataRepositoryUser repositoryUser = DataRepositoryUser();
  String currentUserId = '';
  User currentUser=User();

  Future<void> updateCurrentUser() async {
    try {
      currentUser = await repositoryUser.getUserById(currentUserId) ?? User();
    } catch (e) {
      print("Error getting current user: $e");
      return null;
    }
    notifyListeners(); 
  }

  User getCurrentUser(){
    updateCurrentUser();
    return currentUser;
  }

  void addUser(User newPerson) {
    repositoryUser.addUser(newPerson);
    notifyListeners();
  }
  
  void addUserWithId(User newPerson) {
    repositoryUser.addUserWithId(newPerson);
    notifyListeners();
  }

  void setCurrentUserId(String newUserId) {
    currentUserId=newUserId;
    notifyListeners();
  }

void setCurrentUserName(String name) async {
  updateCurrentUser();
  User userToUpdate = currentUser;

  userToUpdate.setName(name);
  repositoryUser.updateUser(userToUpdate);
  notifyListeners();


}

  void addUnitToCurrentUser(Unit unit, UnitRole role) async {
    updateCurrentUser();
    User userToUpdate = currentUser;

    userToUpdate.setUnit(unit, role);
    repositoryUser.updateUser(userToUpdate);

    notifyListeners();
  }

}



/*
class UserStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory(); //TODO: implement way to store newly created accounts in database, current_account stays in variable
    return directory.path;
    }

  Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/accounts.txt');
  }

  Future<File> writeUser(User account) async {
    final file = await _localFile;
    return file.writeAsString('$account');
  }

  Future<User> readUser() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return User.parse
    }
  }
}
*/







/*
class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    List<Person> persons  = appState.persons;
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Page'),
      ),
      body: Column(
        children:[

        Text('go to home'),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
          child: Text('Next')),
          
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/newuser');
          },
          child: Text('Register'),
        )  
        ],
        ),
      );
  }
}

class RegisterUnit extends StatefulWidget {
  @override
  _RegisterUnitState createState() => _RegisterUnitState();
}
class _RegisterUnitState extends State<RegisterUnit> {
  Widget build(BuildContext context) {
    //var appState = context.watch<Uni>();
    List<Unit> units =UnitState().units;
    Unit newUnit = Unit();
    units.add(newUnit);
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Registration Page'),
      ),
      body:
        Builder(
          builder: (context) => Material(
            child: Column(
            children:  [
              TextField(                //change to buttons with image of type and type 
                onChanged: (unitInput) {
                  setState(() {
                    newUnit.setName(unitInput);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Enter Unit type',
              ),
            ),
            TextField( // TODO only add unit after creation of account
                onChanged: (nameInput) {
                  setState(() {
                    newUnit.setName(nameInput);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Enter password' 
                ),
              ),
            ],
            ),
          ),
        )   
      );   
  }
}

*/
