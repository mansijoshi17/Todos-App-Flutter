import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
    brightness:  Brightness.light,
    primaryColor: Colors.blueAccent,
    accentColor: Colors.orange
  ),
  home: MyApp(),
));

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  List todo = List();
  String input = "";

  createTodo (){
     DocumentReference documentReference = 
         Firestore.instance.collection("MyTodos").document(input);

     Map<String, String> todo = {"todoTitle" : input};
     
     documentReference.setData(todo).whenComplete(() {
       print(" $input created");
     });

  }

  deleteTodo (item){
    DocumentReference documentReference =
    Firestore.instance.collection("MyTodos").document(item);

    documentReference.delete().whenComplete(() {
      print("deleted");
    });

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Mytodos"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context,
          builder: (BuildContext context){
           return AlertDialog(
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text("Add Todolist"),
             content: TextField(
               onChanged: (String value){
                 input = value;
               },
             ),
             actions: <Widget>[
               FlatButton(
                 onPressed: (){
                   createTodo();
                   Navigator.of(context).pop();
                 },
                 child: Text("Add"),
               )
             ],
           );
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
        body: StreamBuilder(stream: Firestore.instance.collection("MyTodos").snapshots(), builder: (context, snapshots){
    return ListView.builder(
       shrinkWrap: true,
        itemCount: snapshots.data.documents.length,
        itemBuilder: (context, index){
          DocumentSnapshot documentSnapshot = snapshots.data.documents[index];
          return Dismissible(key: Key(index.toString()), child: Card(
            elevation: 4,
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child:ListTile(
              title: Text(documentSnapshot["todoTitle"]),
              trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red,),
                onPressed: (){
                  deleteTodo(documentSnapshot["todoTitle"]);
                }),
            ),
          ));
        });
    }),
    );
  }
}


