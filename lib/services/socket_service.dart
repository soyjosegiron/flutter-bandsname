import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/material.dart';


enum ServerStatus{
  Online,
  Offline, 
  Connecting

}


class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;
  
  ServerStatus get serverStatus => this._serverStatus; 
  IO.Socket get socket => this._socket;

  Function get emit => this._socket.emit;


  SocketService(){
    this._initConfig();

  }

  void _initConfig(){
   
    // Dart client
    this._socket = IO.io('http://192.168.0.21:3000',
      IO.OptionBuilder().setTransports(['websocket']).enableAutoConnect().build()

    );
    this._socket.onConnect((_)  {
      print('conectado');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
      });
    this._socket.onDisconnect((_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    this._socket.on('nuevo-mensaje', (payload) {

      print('nuevo-mensaje: $payload');
      print('nombre: '+ payload['nombre']);
      print('mensaje:' + payload['mensaje']);
      print(payload.containsKey('mensaje2')?payload['mensaje2']:'no hay');

    });


    

  }


}