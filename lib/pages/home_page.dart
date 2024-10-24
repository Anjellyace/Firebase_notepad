
import 'package:adet_notepad/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //firestore
  final FirestoreService firestoreService = FirestoreService();
  //text controller - how we access what the user typed
  final TextEditingController textController = TextEditingController();

  // dialogue box opens upon pressing plus sign
  void openNoteBox({String? docID}) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
      //user input text
      content: TextField(
        controller: textController,
      ),
      actions: [
        //save button
        ElevatedButton(onPressed: () {
          //adds note
          if (docID == null) {
            firestoreService.addNote(textController.text);
          }
          //updates note
          else {
            firestoreService.updateNote(docID, textController.text);
          }

          //clears text controller
          textController.clear();
          
          //close text box
          Navigator.pop(context);
        }, 
        child: Text("Add"))
      ],
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Notepad"),),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            //display as a list
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                //gets individual doc
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                //gets note from each doc
                Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                //displays as a list tile
                return ListTile(
                  title: Text(noteText),
                  trailing: Row (
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //updated
                      IconButton(
                        onPressed: () => openNoteBox(docID: docID),
                        icon: Icon(Icons.settings),
                      ),
                      IconButton(
                        onPressed: () => firestoreService.deleteNote(docID), 
                        icon: Icon(Icons.delete),
                        )
                    ],
                  ),
                );
              }
            );
          }
          else {
            return Text("Your notes are empty for now");
          }
        }
        )
    );
  }
}