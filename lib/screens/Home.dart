import 'package:housekeeper_v1/commons.dart';

import '../features/authentication/repositories/auth.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  //Unit _selectedUnit = Unit(name: "", type: UnitType(name: "")); // Add a variable to store the selected unit
  final AuthService _auth = new AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Add a GlobalKey for the Scaffold
  String acc_name ="";

  void _onItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showCustomPopupMenu(BuildContext context) async {
  final appState = context.read<AppState>();
  final unitState = context.read<UnitState>();
  final units = appState.currentUser.getUnits();
  //final name = appState.currentUser.getName();


  final selectedUnit = await showMenu<Unit>(
    context: context,
    position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width - 250.0, kToolbarHeight, 0, 0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
        bottom: Radius.circular(20.0), 
      ),
    ),
    items: [
      PopupMenuItem<Unit>(
        child: Center(
          child: Container(
            //color: Colors.grey[200], // Light grey background color
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                      child: Icon(Icons.settings,color: Colors.black,),
                    ),
                    Spacer(),
                    Text(acc_name), // Add a spacer to push the icons to the right
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        await _auth.signOut();
                      },
                      child: Icon(Icons.exit_to_app_outlined,color: Colors.black,),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                PopupMenuDivider(),
                ...units.map((unit) {
                  return PopupMenuItem<Unit>(
                    value: unit,
                    child: Text(unit.getName()),
                  );
                }),
                PopupMenuDivider(),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.add_circle, color: Colors.green),
                    title: Text(
                      'Create New Unit',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context); // Close the drawer before navigating to the new page
                      Navigator.pushNamed(context, '/create_unit'); // Navigate to the new unit creation page
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        enabled: false,
      ),
    ],
  );

  if (selectedUnit != null) {
    setState(() {
      unitState.setCurrentUnit(selectedUnit);
    });
  }
}

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<AppState>();
    //var unitState = context.watch<UnitState>();
    //List<Unit> units = appState.currentUser.getUnits();


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Open the drawer when the menu icon is pressed
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [ //add button on the right side of appbar
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              _showCustomPopupMenu(context);
            },
          ),
        ],
      ),
      drawer: UnitAccDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: [
                    CalendarPage(),
                    MessagingPage(),
                    // Add more pages as needed
                  ],
                ),
              ),
            ],
          ),
          
        ],
      ),
      bottomNavigationBar: PageNavigationBar(
        currentIndex: _currentIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}



/*

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;


  void _onItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //var appState = Provider.of<AppState>(context); // Access the AppState instance
    //var unitState = Provider.of<UnitState>(context); // Access the UnitState instance


    return Scaffold(
      appBar: AppBar(
        title: Text('New Page'),
        leading: Builder(
          builder: (context) => IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Open the drawer when the menu icon is pressed
            Scaffold.of(context).openDrawer();
          },
        ),
        ),
      ),
      drawer: UnitAccDrawer(),
      body: Column(
        children: [
          Expanded(
            child: UnitAccMenu()),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                CalendarPage(),
                MessagingPage(),
                // Add more pages as needed
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: PageNavigationBar(
        currentIndex: _currentIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}


*/
