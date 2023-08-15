//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:housekeeper_v1/commons.dart';

class CreateUnitPage extends StatefulWidget{
  @override
  State<CreateUnitPage> createState() => _CreateUnitPageState();
}

class _CreateUnitPageState extends State<CreateUnitPage> {
  TextEditingController _unitNameController = TextEditingController();
  UnitType? selectedType;
  UnitRole? selectedRole;
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    var unitState = Provider.of<UnitState>(context);
    //var repositoryUnit = unitState.repositoryUnit;
    var repositoryUnitType = unitState.repositoryUnitType;
    var repositoryUnitRole = unitState.repositoryUnitRole;
    var appState = Provider.of<AppState>(context);


    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Unit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _unitNameController,
              decoration: InputDecoration(labelText: 'Unit Name'),
            ),
            SizedBox(height: 20),
            Text('select the type'),
            StreamBuilder(
              stream: repositoryUnitType.getStream(),
              builder: (context,snapshot) {
                //if (!snapshot.hasData) return const LinearProgressIndicator();
                return _buildListUnitType(context, snapshot.data?.docs ?? []);
              }),
            SizedBox(height: 20),
            Text('select your role'),
            StreamBuilder(
              stream: repositoryUnitRole.getPublicStream(),
              builder: (context,snapshot) {
                //if (!snapshot.hasData) return const LinearProgressIndicator();
                return _buildListUnitRole(context, snapshot.data?.docs ?? []);
              }),
            SizedBox(height: 20),
            if (showError)
              Text(
                'Please enter a valid name and choose a unit type and role your user has',
                style: TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: () {
                var unitName = _unitNameController.text.trim();
                if (unitName.isEmpty || selectedType == null || selectedRole == null) {
                  setState(() {
                    showError = true;
                  });
                } else {
                  // Save the new unit and navigate back to the previous page
                  Unit newUnit = Unit(name: unitName, type: selectedType!,rolesAndUsers: {selectedRole!:[appState.getCurrentUser()]});
                  //Unit newUnit = Unit(name: 'test', rolesAndUsers: {UnitRole(name: 'roletest'):[User(email: 'email', password: 'password')]}, type: UnitType(name: 'typeee'));
                  print('ok'); //tot hier alles ok, probleem is met map
                  unitState.addUnit(newUnit);
                  appState.addUnitToCurrentUser(newUnit,selectedRole!);
                  Navigator.pop(context);
                }
              },
              child: Text('Create Unit'),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildListUnitType(BuildContext context, List<DocumentSnapshot> snapshot) {

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: snapshot.map((data) => _buildListItemUnitType(context, data)).toList(),
      ),
    );
  }

  Widget _buildListItemUnitType(BuildContext context, DocumentSnapshot snapshot) {
    final unitType = UnitType.fromSnapshot(snapshot);
    final isSelected= selectedType==unitType;

    return TextButton(
      onPressed: () {
        setState(() {
          selectedType=unitType;
          print(selectedType?.name);

        });
      }, 
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? Colors.red.shade700 : Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        unitType.getName(),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildListUnitRole(BuildContext context, List<DocumentSnapshot> snapshot) {

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: snapshot.map((data) => _buildListItemUnitRole(context, data)).toList(),
      ),
    );
  }

  Widget _buildListItemUnitRole(BuildContext context, DocumentSnapshot snapshot) {
    final unitRole = UnitRole.fromSnapshot(snapshot);
    final isSelected= selectedRole==unitRole;


    return TextButton(
      onPressed: () {
        setState(() {
          selectedRole=unitRole;
          print(selectedRole?.name);
        });
      }, 
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue.shade700 : Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        unitRole.getName(),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

