import 'package:bannedapp/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

 


class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    final socketService = Provider.of<SocketService>(context);
    


    return SafeArea(
          child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 Text('Server Status:${socketService.serverStatus}')
              ],
            )
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.message),
            onPressed: (){


                socketService.emit('emitir-mensaje', {'nombre': 'Flutter', 'mensaje':'hola'});
            },
          ),
      ),
    );
  }
}