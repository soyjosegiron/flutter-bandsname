import 'dart:io';

import 'package:bannedapp/services/socket_service.dart';
import 'package:bannedapp/src/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
   
  ];

  @override
  void initState() { 

    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
    
  }

  _handleActiveBands(dynamic payload){
      this.bands = (payload as List)
        .map((band) => Band.fromMap(band))
        .toList();

        setState(() {
          
        });
  }

  @override
  void dispose() { 
    final socketService = Provider.of<SocketService>(context);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
          appBar: AppBar(
            title:Text('Band Names', style: TextStyle(color: Colors.black87),) ,
            backgroundColor: Colors.white, 
            centerTitle: true,
            elevation: 1,
            actions: [
              Container(
                margin:EdgeInsets.only(right:10),
                child: (socketService.serverStatus == ServerStatus.Online)
                    ? Icon(Icons.check_circle, color: Colors.blue,)
                    : Icon(Icons.offline_bolt, color: Colors.red)
              )
            ],
          ),
          body: Column(
            children: [
              if(bands.isNotEmpty)
            _showGraph(),

            Expanded(child: 
            ListView.builder(
            itemCount: bands.length,
            itemBuilder: (BuildContext context, int index) { 
               
               return bandTile(bands[index]);

             },
            )
            ),
            ],
          ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              elevation: 1,
              onPressed: addNewBand,
              

              ),
    );
  }

  Widget bandTile(Band band) {

    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
          key: Key(band.id),
          direction: DismissDirection.startToEnd,
          onDismissed: (_){
             
             //final socketService = Provider.of<SocketService>(context, listen: false);
             socketService.emit('delete-band', {'id':band.id});
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
                   socketService.socket.emit('vote-band', {'id': band.id});
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
      /*this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0 ));
      setState(() {
        
      });*/
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name':name});

     }
     Navigator.pop(context);

   }
   Widget _showGraph(){

      Map<String, double> dataMap = new Map();

      bands.forEach((band) { 
        dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
      });

      return Container(
        width: double.infinity,
        height: 200,
        child: PieChart(dataMap: dataMap,
            chartValuesOptions: ChartValuesOptions(
              showChartValuesInPercentage: true,
            ),
        
        )
        );
   }
}