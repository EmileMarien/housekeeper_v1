
import '../../commons.dart';
import '../repositories/data_repository.dart';
import '../models/unit.dart';

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