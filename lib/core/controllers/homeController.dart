

import '../../commons.dart';
import '../../features/authentication/states/AuthenticationState.dart';

class HomeController {
  final BuildContext context;
  final UserState userState;
  final UnitState unitState;
  final AuthenticationState authState;

  late List<Unit> units; // It will be initialized before it is used

  HomeController(this.context)
      : unitState = Provider.of<UnitState>(context),
        userState = Provider.of<UserState>(context),
        authState = AuthenticationState();

  int currentIndex = 0;

  String getAccountName() {
    return userState.currentUser.getName();
  }
  List<Unit> getUnits() {
    return userState.getCurrentUser().getUnits();
  }

  void onItemSelected(int index) {
    currentIndex = index;
  }
  void setCurrentUnit(Unit unit) {
    unitState.setCurrentUnit(unit);
    Navigator.pop(context);
  }

  void signOut() {
    authState.signOut();
    userState.removeUser();
    Navigator.pushNamed(context, '/authentication');
  }
}

