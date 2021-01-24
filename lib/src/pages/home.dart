import 'dart:io';

import 'package:bannedapp/src/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Heroes del Silencio', votes:  3),
    Band(id: '2', name: 'Imagine Dragos', votes:  4),
    Band(id: '3', name: 'Mana', votes:  1),
    Band(id: '4', name: 'Alesso', votes:  3),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title:Text('Band Names', style: TextStyle(color: Colors.black87),) ,
            backgroundColor: Colors.white, 
            centerTitle: true,
            elevation: 1,
          ),
          body: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (BuildContext context, int index) { 
               
               return bandTile(bands[index]);

             },
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              elevation: 1,
              onPressed: addNewBand,
              

              ),
    );
  }

  Widget bandTile(Band band) {
    return Dismissible(
          key: Key(band.id),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction){
             
          },
          background: Container(
            padding: EdgeInsets.only(left:8.0),
            color: Colors.red,
            child: Align(
              alignment:  Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.white,),
                  Text('Borrar Banda', style: TextStyle(color: Colors.white)),
                ],
              )
            ),
          ),
          child: ListTile(
                 leading: CircleAvatar(
                   child: Text(band.name.substring(0,2)),
                   backgroundColor: Colors.blue[100],
                 ),
                 title: Text(band.name),
                 trailing: Text('${ band.votes}', style: TextStyle(fontSize: 20),),
                 onTap: (){
                   print(band.name);
                 },
               ),
    );
  }

  addNewBand(){
    //Controlador
    final textController = new TextEditingController();

    if(Platform.isAndroid){
      return showDialog(
      context: context,
      builder: (context){

          return AlertDialog(
            title: Text('Nombre de nueva banda'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
                MaterialButton(
                  child: Text('Agregar'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => addBandToList(textController.text)
                  )
            ],
          );
        }
      );
    }
    showCupertinoDialog(
        context: context,
        builder: ( _ ){
          return CupertinoAlertDialog(
            title: Text('Nuevo nombre de la banda:'),
            content: CupertinoTextField(
              controller: textController ,
              ),
          );
        }
      );

    
    
  }
   
   void  addBandToList(String name){

     if (name.length > 1){
       //aqui se agrega
      this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0 ));
      setState(() {
        
      });
     }
     Navigator.pop(context);

   }
}