
import 'package:housekeeper_v1/screens/settings/Settings.dart' as hk;
import 'package:housekeeper_v1/core/repositories/data_repository.dart';

import 'commons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/authentication/repositories/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //ensure the binding between widget layer and flutter engine is initialized
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); //initialize firebase
  runApp(const MyApp());
}

//void main() {
//  runApp(const MainApp());
//}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthenticationRepository().user,
      initialData: null,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserState()),
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
              displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              titleLarge: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
              bodyLarge: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            ),
            // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan[600]),
          ),
          initialRoute: '/authentication',
          routes: {
            '/authentication': (context) => Authentication(), //Instead of loginpage
            '/home': (context) => HomeScreen(),
            '/create_unit': (context) => CreateUnitPage(),
            '/settings':(context) => hk.Settings(),
          },
        ),
      ),
    );
  }
}