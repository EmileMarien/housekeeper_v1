

import 'package:flutter/cupertino.dart';

import '../../../commons.dart';

class homeNoteScreen extends StatefulWidget {
  @override
  _homeNoteScreenState createState() => _homeNoteScreenState();
}

class _homeNoteScreenState extends State<homeNoteScreen> {
  @override
  Widget build(BuildContext context) {

    final notelist = StreamBuilder(stream: FirebaseFirestore.instance.collection("notes").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if (snapshot.connectionState  == ConnectionState.waiting)
        {
          return const Center(
            child: CupertinoActivityIndicator(color: Colors.purple,),
          );
        }

        if (snapshot.data!.docs.isEmpty)
        {
          const Center(child: Text("Data Not Found !"));
        }

        if (snapshot.data != null)
        {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
                var note = snapshot.data!.docs[index]['note'];
                var docId = snapshot.data!.docs[index].id;
                return Card(
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(snapshot.data!.docs[index]['note']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                            onTap: (){
                              //Get.to(const EditNoteScreen(),arguments:
                              //{
                              //  'note' : note,
                              //  'docId' : docId,
                              //});
                            },
                            child: const Icon(Icons.mode_edit_outline,color: Colors.purple,)),
                        const SizedBox(width: 15),
                        GestureDetector(
                            onTap: () async{
                              FirebaseFirestore.instance.collection('notes').doc(docId).delete();
                            },
                            child: const Icon(Icons.delete_rounded,color: Colors.purple,)),
                      ],
                    ),
                  ),
                );
              });
        }
        return Container();
      },
    );

    final createNoteButton= FloatingActionButton(
    backgroundColor: Colors.purple,
    onPressed: (){
    },
    child:  const Icon(Icons.add_circle_outlined),
    );



    return Scaffold(
      body: Column(
        children: [
          Text('TODO'),
          createNoteButton,
        ],
      ),
    );
  }
}