import 'package:housekeeper_v1/commons.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _selectedDropdownValue = 'User';
  UnitType newUnitType = UnitType(name: '');
  UnitRole newUnitRole = UnitRole(name: '');


  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    var unitState = Provider.of<UnitState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildDropdownButton('User'),
                SizedBox(width: 16.0),
                _buildDropdownButton('Unit'),
              ],
            ),
            SizedBox(height: 16.0),
            if (_selectedDropdownValue == 'User') ...[
              Text('User Settings'),
              SizedBox(height: 8.0),
              Text('User Name: ${appState.currentUser.name}'),
              SizedBox(height: 8.0),
              TextFormField(
                initialValue: appState.currentUser.name,
                onChanged: (newValue) {
                  appState.setCurrentUserName(newValue);
                },
                decoration: InputDecoration(
                  labelText: 'New User Name',
                ),
              ),
            ] else if (_selectedDropdownValue == 'Unit') ...[
              Text('Unit Settings'),
              SizedBox(height: 8.0),
              Text('add new unit Type'),
              SizedBox(height: 8.0),
              TextFormField(
                initialValue: newUnitType.getName(),
                onChanged: (newValue) {
                  setState(() {
                    newUnitType =UnitType(name: newValue);
                  }); 
                },
                decoration: InputDecoration(
                  labelText: 'New unitType Name',
                ),
              ),
              Text('add new unit Role'),
              SizedBox(height: 8.0),
              TextFormField(
                initialValue: newUnitRole.getName(),
                onChanged: (newValue) {
                  setState(() {
                    newUnitRole =UnitRole(name: newValue);
                  }); 
                },
                decoration: InputDecoration(
                  labelText: 'New unitRole Name',
                ),
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  setState(() {
                    unitState.addUnitType(newUnitType);
                    unitState.addUnitRole(newUnitRole);
                  });
                },
                child: Text('Confirm'),  
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButton(String value) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedDropdownValue = value;
        });
      },
      child: Text(value),
    );
  }
}
