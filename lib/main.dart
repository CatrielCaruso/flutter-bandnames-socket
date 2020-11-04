import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_name/src/pages/home.dart';
import 'package:band_name/src/pages/status.dart';
import 'package:band_name/src/services/sockets_services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketServices()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          initialRoute: 'home',
          routes: {
            'home': (_) => HomePage(),
            'status': (_) => StatusPage(),
          }),
    );
  }
}
