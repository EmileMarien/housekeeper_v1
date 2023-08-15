import 'package:housekeeper_v1/commons.dart';

class UnitAccDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var unitState = Provider.of<UnitState>(context);
    var appState = Provider.of<AppState>(context);
    User currentUser = appState.currentUser;
    List<Unit> units = currentUser.getUnits();

    return Drawer(
      child: ListView.builder(
        itemCount: units.length + 1, // Add 1 for the "Create New Unit" item
        itemBuilder: (context, index) {
          if (index < units.length) {
            Unit unit = units[index];
            return ListTile(
              title: Text(unit.getName()),
              onTap: () {
                unitState.setCurrentUnit(unit); // Call the method in UnitState to update the current unit
                Navigator.pop(context); // Close the drawer after selecting a unit
              },
            );
          } else {
            return ListTile(
              title: Text(
                'Create New Unit',
                style: TextStyle(
                  color: Colors.black, // Change the text color here
                ),
              ),
              leading: Icon(
                Icons.add_circle, // Add the '+' icon here
                color: Colors.green, // Change the icon color here
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer before navigating to the new page
                Navigator.pushNamed(context, '/create_unit'); // Navigate to the new unit creation page
              },
            );
          }
        },
      ),
    );
  }
}