



import 'package:housekeeper_v1/features/authentication/repositories/auth.dart';

import '../../../commons.dart';
import '../../../core/models/user.dart';



class AuthenticationState extends ChangeNotifier {
  final AuthenticationRepository repositoryAuth = AuthenticationRepository();


  Future<User> registerEmailPassword(User newPerson) async {
    User result = await repositoryAuth.registerEmailPassword(newPerson);
    notifyListeners();
    return result;
  }

  Future<User> signInEmailPassword(User newPerson) async {
    User result = await repositoryAuth.registerEmailPassword(newPerson);
    notifyListeners();
    return result;
  }

  void signOut() {
    repositoryAuth.signOut();

    notifyListeners();
  }
}