
import 'package:housekeeper_v1/screens/settings/Settings.dart' as hk;
import '../commons.dart';
import 'routes.dart';

Map<String, WidgetBuilder> routesApp = {
  Routes.home: (context) => HomeScreen(),
  Routes.authentication: (context) => Authentication(),
  Routes.create_unit: (context) => CreateUnitPage(),
  Routes.settings: (context) => hk.Settings(),
};