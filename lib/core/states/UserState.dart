
import '../../commons.dart';
import '../repositories/data_repository.dart';
import '../models/user.dart';


class UserState extends ChangeNotifier {
  final DataRepositoryUser repositoryUser = DataRepositoryUser();
  String? currentUserId = '';
  User currentUser=User();

  Future<void> updateCurrentUser() async {
    if (currentUserId == '') {
      return;
    }
    else {
      try {
        currentUser = await repositoryUser.getUserById(currentUserId!) ?? User();
      } catch (e) {
        print("Error getting current user: $e");
      }
      notifyListeners();
    }
  }

  User getCurrentUser(){
    updateCurrentUser();
    return currentUser;
  }

  void addUser(User newPerson) {
    repositoryUser.addUser(newPerson);
    notifyListeners();
  }

  void removeUser() {
    currentUserId='';
    notifyListeners();
  }

  Future<bool> checkIfEmailExists(String email) async {
    Stream<List<User>> accountsStream = repositoryUser.getUsersStream();

    bool emailExists = false;
    List<User> accountsList = await accountsStream.first;

    for (User account in accountsList) {
      print(account.getEmail());
      if (account.getEmail() == email) {
        emailExists = true;
        break;
      }
    }

    print(emailExists);
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