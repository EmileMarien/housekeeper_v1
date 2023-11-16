import 'package:housekeeper_v1/commons.dart';

class PageNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  PageNavigationBar({required this.currentIndex, required this.onItemSelected});


  @override
  Widget build(BuildContext context) {//dd
    return BottomAppBar(
      child: Container(
        height: kToolbarHeight, // Set the height to match the default app bar height
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.chat_rounded),
              onPressed: () => onItemSelected(0),
              color: currentIndex == 0 ? Colors.blue : Colors.black,
            ),
            IconButton(
              icon: Icon(Icons.calendar_month_sharp),
              onPressed: () => onItemSelected(1),
              color: currentIndex == 1 ? Colors.blue : Colors.black,
            ),
            // Add more icons for other pages as needed
          ],
        ),
      ),
    );
  }
}







