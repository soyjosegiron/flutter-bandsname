

import 'package:bannedapp/services/socket_service.dart';
import 'package:bannedapp/src/pages/status.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
 
import 'package:bannedapp/src/pages/home.dart';


void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => SocketService())
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home': (_) => HomePage(),
          'status': (_)=>StatusPage()
        },
      ),
    );
  }
}