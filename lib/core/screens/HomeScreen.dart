import 'package:housekeeper_v1/commons.dart';

import '../../../commons.dart';
import '../controllers/homeController.dart';
import 'package:housekeeper_v1/features/recipenotes/screens/HomeNoteScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    HomeController controller = HomeController(context);


    final pageSettingsDrawer = Drawer(
      child: ListView.builder(
        itemCount: controller.getUnits().length + 1,
        // Add 1 for the "Create New Unit" item
        itemBuilder: (context, index) {
          if (index < controller.getUnits().length) {
            Unit unit = controller.getUnits()[index];
            return ListTile(
              title: Text(unit.getName()),
              onTap: () {
                controller.setCurrentUnit(
                    unit); // Call the method in UnitState to update the current unit
                //Navigator.pop(context); // Close the drawer after selecting a unit
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
                Navigator.pop(
                    context); // Close the drawer before navigating to the new page
                Navigator.pushNamed(context,
                    '/create_unit'); // Navigate to the new unit creation page
              },
            );
          }
        },
      ),
    );

    final navigationBar = BottomAppBar(
      child: Container(
        height: kToolbarHeight,
        // Set the height to match the default app bar height
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.chat_rounded),
              onPressed: () {
                _currentIndex=0;
                print('0');
              } ,
              color: _currentIndex == 0 ? Colors.blue : Colors.black,
            ),
            IconButton(
              icon: Icon(Icons.calendar_month_sharp),
              onPressed: () {
                _currentIndex=1;
                print('1');
              } ,
              color: _currentIndex == 1 ? Colors.blue : Colors.black,
            ),
            IconButton(
              icon: Icon(Icons.note_alt_sharp),
              onPressed: () {
                _currentIndex=2;
                print('2');
              } ,
              color: _currentIndex == 2 ? Colors.blue : Colors.black,
            ),
            // Add more icons for other pages as needed
          ],
        ),
      ),
    );

    final popupMenu= PopupMenuButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
          bottom: Radius.circular(20.0),
        ),
      ),
      itemBuilder: (BuildContext bc) {
        return [
          PopupMenuItem(
            enabled: false,
            child: Text(controller.getAccountName()),
          ),
          const PopupMenuItem(
            child: Text("Settings"),
            value: '/settings',
          ),
          const PopupMenuItem(
            value: '/sign_out',
            child: Row(
              children: [
                Icon(Icons.exit_to_app), // Use the appropriate icon for sign out
                SizedBox(width: 8), // Adjust the spacing between icon and text
                Text("Sign Out"),
              ],
            ),
           onTap: () {controller.signOut()}, // You can use '/sign_out' or any other value you prefer
          )
        ];
      },
      icon: const Icon(Icons.more_vert),
    );

    /*final popupMenu = showMenu(
      context: context,
      position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width - 250.0, kToolbarHeight, 0, 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
          bottom: Radius.circular(20.0),
        ),
      ),
      items: [
        PopupMenuItem(
          enabled: false,
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
                        child: Icon(Icons.settings, color: Colors.black,),
                      ),
                      Spacer(),
                      Text(controller.getAccountName()),
                      // Add a spacer to push the icons to the right
                      Spacer(),
                      InkWell(
                        onTap: () {
                          controller.signOut();
                        },
                        child: Icon(
                          Icons.exit_to_app_outlined, color: Colors.black,),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  PopupMenuDivider(),
                  ...controller.units.map((unit) {
                    return PopupMenuItem<Unit>(
                      value: unit,
                      child: Text(unit.getName()),
                    );
                  }),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    child: Text('hey')
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    */
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) =>
              IconButton( //TODO: where is this placed
                icon: Icon(Icons.menu),
                onPressed: () {
                  // Open the drawer when the menu icon is pressed
                  print(controller.getUnits());
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        actions: [ //add button on the right side of appbar
          popupMenu,
        ],
      ),
      drawer: pageSettingsDrawer,
      body: IndexedStack(
                  index: _currentIndex,
                  children: [
                    CalendarPage(),
                    MessagingPage(),
                    homeNoteScreen(),
                    // Add more pages as needed
                  ],
                ),
      bottomNavigationBar: navigationBar,
    );
  }
}


