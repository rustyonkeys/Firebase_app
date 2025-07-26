import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudapp/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //firestone
  final FirestoneServices firestoneServices = FirestoneServices();

  //how to access how the user typed
  final TextEditingController textcontroller = TextEditingController();

  //open the dialogue box
  void opendialoguebox({String? docID}){   //if docID can be null
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          //text field for user input
          content: TextField(
            controller: textcontroller,
          ),
          //button to save
          actions: [
            ElevatedButton(
                onPressed: () {
                  //add a new note
                  if(docID == null){
                    firestoneServices.addNote(textcontroller.text);
                  }

                  //update the existing note
                  else{
                    firestoneServices.updateNote(
                        docID,
                        textcontroller.text);
                  }
                  //clear the dialoge box
                  textcontroller.clear();

                  //close the box
                  Navigator.pop(context);
                },
                child: Text("Add"),)
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(
        child: Text("Notes",
        style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.blue,),
      floatingActionButton: FloatingActionButton(onPressed: opendialoguebox,
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
        foregroundColor: Colors.white,),

      body: StreamBuilder<QuerySnapshot>(
        stream: firestoneServices.getNotesStream(), //this is what it is going to listen
        builder: (context, snapshot) {
          // if we(snapshots) have the data get all the docs
          if(snapshot.hasData){
            List notesList = snapshot.data!.docs;

            //display as a list
            return ListView.builder(
              itemCount: notesList.length,
                itemBuilder: (context, index) {
                  //get each individual doc
                  DocumentSnapshot document = notesList[index]; //getting individual document
                  String docID = document.id;  //to track the notes

                  //get note from each doc and store it in data variable
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  String noteText = data["note"]; //get the text(check it in internet)

                  //display as a list title
                  return ListTile(
                    title: Text(noteText),
                  trailing: IconButton(
                      onPressed: () => opendialoguebox(docID: docID) ,
                      icon: Icon(Icons.add)),);
                },);
          }
          //if there is no data return nothing
          else{
            return const Text("No notes....");
          }
      },),
    );
  }
}
