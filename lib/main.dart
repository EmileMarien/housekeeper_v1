
import 'package:housekeeper_v1/core/repositories/data_repository.dart';
import 'package:housekeeper_v1/routes/register_routes.dart';

import 'commons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/authentication/states/AuthenticationState.dart';
import 'firebase_options.dart';
import 'features/authentication/repositories/auth.dart';
import 'routes/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //ensure the binding between widget layer and flutter engine is initialized
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); //initialize firebase
  runApp(const MyApp());
}

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
          ChangeNotifierProvider(create: (context) => AuthenticationState()),
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
          routes: routesApp,
        ),
      ),
    );
  }
}