
import '../../commons.dart';
import '../repositories/data_repository.dart';
import '../models/user.dart';


class UserState extends ChangeNotifier {
  final DataRepositoryUser repositoryUser = DataRepositoryUser();
  String? currentUserId = '';
  User currentUser=User();

  Future<void> updateCurrentUser() async {

    try {
      currentUser = await repositoryUser.getUserById(currentUserId!) ?? User();
    } catch (e) {
      print("Error getting current user: $e");
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

  bool checkIfEmailExists(String email) {
    Stream<List<User>> accountsStream = repositoryUser.getUsersStream();

    bool emailExists = false;
    accountsStream.first.then((accountsList) {
      for (User account in accountsList) {
        if (account.getEmail() == email) {
          emailExists = true;
          break;
        }
      }
    });

    return emailExists;
  }

  void addUserWithId(User newPerson) {
    repositoryUser.addUserWithId(newPerson);
    notifyListeners();
  }

  void setCurrentUserName(String name) async {
    updateCurrentUser();
    User userToUpdate = currentUser;

    userToUpdate.setName(name);
    repositoryUser.updateUser(userToUpdate);
    notifyListeners();
  }

  void setCurrentUserId(String newUserId) {
    currentUserId=newUserId;
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