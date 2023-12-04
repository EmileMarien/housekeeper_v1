import '../../commons.dart';




class UnitAccMenu extends StatefulWidget {
  @override
  _UnitAccMenuState createState() => _UnitAccMenuState();
}

class _UnitAccMenuState extends State<UnitAccMenu> {
  final AuthService _auth = new AuthService();


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var unitState = context.watch<UnitState>();
    List<Unit> units = appState.currentUser.getUnits();
    Unit selectedUnit = unitState.currentUnit;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your App Title'),
        actions: [
          PopupMenuButton<Unit>(
            icon: Icon(Icons.person),
            onSelected: (Unit unit) {
              setState(() {
                selectedUnit = unit;
              });
            },
            itemBuilder: (BuildContext context) {
              return units.map((Unit unit) {
                return PopupMenuItem<Unit>(
                  value: unit,
                  child: Text(unit.name ?? "null"),
                );
              }).toList();
            },
          ),
          IconButton(
            onPressed: () async {
              await _auth.signOut();
              return Auth_handler();
            }, 
            icon: Icon(Icons.exit_to_app_outlined),
          ),
        ],
      ),
      body: Center(
        child: Text("You are currently on ${selectedUnit.name}"),
      ),
    );
  }
}