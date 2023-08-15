
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../commons.dart';
import '../../../main.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    var appState = Provider.of<AppState>(context); // Access the AppState instance
    //var unitState = Provider.of<UnitState>(context); // Access the UnitState instance
    var repositoryUser = appState.repositoryUser;
    return StreamBuilder<QuerySnapshot>(
  stream: repositoryUser.getStream(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return LinearProgressIndicator();

    return _buildList(context, snapshot.data?.docs ?? []);
  });  
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
  
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    // 2
    children: snapshot!.map((data) => _buildListItem(context, data)).toList(),
  );
}
// 3
Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
  // 4
  final account = User.fromSnapshot(snapshot);

  return Text(account.getName());
}
}