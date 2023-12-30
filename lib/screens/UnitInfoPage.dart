import 'package:housekeeper_v1/commons.dart';

class UnitInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  //var unitState = context.watch<UnitState>();
  var appState = context.watch<UserState>();

  return ListView(
    children: [
      Padding(
        padding: const EdgeInsets.all(20),
        child: Text('You have ${appState.currentUser.getUnits().length} favorites:'),
      ),
      /*for (Unit unit in appState.currentUser.getUnits())     TODO
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text(unit.getName()),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (User person in unit.rolesAndUsers.values.toSet())
                if 
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text(person.getName().toLowerCase()),
                ),
            ],
          ),
        ),
      */  
    ],
  );
  } 
}